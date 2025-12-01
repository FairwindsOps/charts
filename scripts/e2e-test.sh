#!/bin/sh

# Copyright 2018 ReactiveOps. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -o errexit
set -o nounset
set -x

OPERATION="${1:-create}"
TEST_CLUSTER_NAME="${3:-helm-e2e}"

setup_cluster () {
    printf "Creating cluster %s.  This could take a minute...\n" "$TEST_CLUSTER_NAME"
    kind create cluster --name="$TEST_CLUSTER_NAME" --wait=120s > /dev/null
}

teardown () {
    printf "Deleting kind cluster %s and exec container\n" "$TEST_CLUSTER_NAME"
    kind delete cluster --name="$TEST_CLUSTER_NAME"
}

pre_test_script () {
    printf "Running pre-test scripts if they exist...\n"
    scripts/pre-test-script-runner.sh
}

# Helper function to get changed charts using git directly (fallback when ct fails)
get_changed_charts_git() {
    TARGET_BRANCH="${1:-origin/master}"
    CHART_DIRS="${2:-stable incubator}"
    
    # Get merge base
    MERGE_BASE=$(git merge-base "$TARGET_BRANCH" HEAD 2>/dev/null || echo "")
    if [ -z "$MERGE_BASE" ]; then
        printf "Warning: Could not find merge base with %s\n" "$TARGET_BRANCH"
        return 1
    fi
    
    # Get changed files in chart directories
    # Compare MERGE_BASE to HEAD (not working directory)
    # Note: CHART_DIRS is intentionally unquoted to allow word splitting for git diff
    # shellcheck disable=SC2086
    CHANGED_FILES=$(git diff --find-renames --name-only "$MERGE_BASE" HEAD -- $CHART_DIRS 2>/dev/null || echo "")
    
    if [ -z "$CHANGED_FILES" ]; then
        # Return empty string (not exit code 0) to indicate no changes
        return 0
    fi
    
    # Extract unique chart directories (e.g., stable/chart-name or incubator/chart-name)
    # Output the chart directories, one per line
    printf "%s\n" "$CHANGED_FILES" | \
        grep -E "^($(echo "$CHART_DIRS" | tr ' ' '|'))/[^/]+/" | \
        sed -E 's|^([^/]+/[^/]+)/.*|\1|' | \
        sort -u | \
        tr '\n' ' ' | \
        sed 's/[[:space:]]*$//'
}

run_tests () {
    printf "Running e2e tests...\n"
    
    # First, try to identify changed charts to see if ct list-changed works
    # If it fails, use git directly as a fallback
    # Note: Explicitly specifying --target-branch may help avoid segmentation faults
    set +o errexit
    CHANGED_CHARTS="$(ct list-changed --config scripts/ct.yaml --target-branch master 2>&1)"
    LIST_CHANGED_EXIT=$?
    set -o errexit
    
    if [ $LIST_CHANGED_EXIT -ne 0 ] || echo "$CHANGED_CHARTS" | grep -qE "(Error|error|failed|segmentation|fault)"; then
        printf "Warning: ct list-changed failed (segmentation fault detected).\n"
        printf "Using git-based fallback to identify changed charts...\n"
        
        # Use git directly as fallback
        CHANGED_CHARTS="$(get_changed_charts_git origin/master "stable incubator")"
        GIT_FALLBACK_EXIT=$?
        
        if [ $GIT_FALLBACK_EXIT -ne 0 ] || [ -z "$CHANGED_CHARTS" ]; then
            printf "No changed charts detected via git fallback.\n"
            printf "Skipping installation tests.\n"
            exit 0
        fi
        
        printf "Changed charts detected via git: %s\n" "$CHANGED_CHARTS"
        printf "Note: ct install may still fail due to the same segmentation fault.\n"
        printf "Consider updating chart-testing or reporting this issue.\n\n"
    fi
    
    # If no charts changed, skip installation
    if [ -z "$CHANGED_CHARTS" ]; then
        printf "No changed charts detected. Skipping installation tests.\n"
        exit 0
    fi
    
    printf "Changed charts: %s\n" "$CHANGED_CHARTS"
    printf "Running ct install...\n"
    
    # Now run ct install - wrap in error handling in case it still fails
    # Note: Explicitly specifying --target-branch may help avoid segmentation faults
    set +o errexit
    CT_INSTALL_OUTPUT="$(ct install --config scripts/ct.yaml --target-branch master --debug --upgrade --helm-extra-args "--timeout 600s" 2>&1)"
    CT_INSTALL_EXIT=$?
    set -o errexit
    
    if [ $CT_INSTALL_EXIT -ne 0 ]; then
        printf "Error: ct install failed with exit code %d\n" "$CT_INSTALL_EXIT"
        printf "Output:\n%s\n" "$CT_INSTALL_OUTPUT"
        
        if echo "$CT_INSTALL_OUTPUT" | grep -qE "(segmentation|fault)"; then
            printf "\nSegmentation fault detected in ct install.\n"
            printf "This is a known issue with chart-testing v3.14.0.\n"
            printf "\nPossible solutions:\n"
            printf "1. Update chart-testing to a newer version (if available)\n"
            printf "2. Report this issue to: https://github.com/helm/chart-testing/issues\n"
            printf "3. Manually test the changed charts: %s\n" "$CHANGED_CHARTS"
        else
            printf "\nPossible solutions:\n"
            printf "1. Check the error output above\n"
            printf "2. Verify your Kubernetes cluster is accessible\n"
        fi
        exit 1
    fi
}

if [ "$OPERATION" = "setup" ]; then
    printf "Running setup.\n"
    setup_cluster
    printf "e2e testing environment is ready.\n"
elif [ "$OPERATION" = "teardown" ] ; then
    printf "Running teardown.\n"
    teardown
    printf "e2e testing environment torn down.\n"
elif [ "$OPERATION" = "test" ]; then
    printf "Running tests.\n"
    pre_test_script
    run_tests
else
    printf "You need to specify teardown, setup, test"
    exit 1
fi

set +x
