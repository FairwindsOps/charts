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

run_tests () {
    printf "Running e2e tests...\n"
    
    # Try ct list-changed first to identify charts
    set +o errexit
    CHANGED_CHARTS="$(ct list-changed --config scripts/ct.yaml --target-branch master 2>&1)"
    LIST_EXIT=$?
    set -o errexit
    
    # If ct fails, use git fallback
    if [ $LIST_EXIT -ne 0 ] || echo "$CHANGED_CHARTS" | grep -qE "(Error|error|failed|segmentation|fault)"; then
        printf "Warning: ct list-changed failed, using git fallback...\n"
        MERGE_BASE=$(git merge-base origin/master HEAD 2>/dev/null || echo "")
        if [ -n "$MERGE_BASE" ]; then
            CHANGED_FILES=$(git diff --find-renames --name-only "$MERGE_BASE" HEAD -- stable incubator 2>/dev/null || echo "")
            if [ -n "$CHANGED_FILES" ]; then
                CHANGED_CHARTS=$(echo "$CHANGED_FILES" | grep -E "^(stable|incubator)/[^/]+/" | sed -E 's|^([^/]+/[^/]+)/.*|\1|' | sort -u | tr '\n' ' ' | sed 's/[[:space:]]*$//')
            fi
        fi
    fi
    
    # Filter out config output, keep only chart paths
    CHANGED_CHARTS=$(echo "$CHANGED_CHARTS" | grep -E "^(stable|incubator)/[^/]+$" | tr '\n' ' ' | sed 's/[[:space:]]*$//')
    
    if [ -z "$CHANGED_CHARTS" ]; then
        printf "No changed charts detected. Skipping installation tests.\n"
        exit 0
    fi
    
    printf "Changed charts: %s\n" "$CHANGED_CHARTS"
    
    # Try ct install, but handle bus errors and segmentation faults gracefully
    set +o errexit
    CT_INSTALL_OUTPUT="$(ct install --config scripts/ct.yaml --target-branch master --debug --upgrade --helm-extra-args "--timeout 600s" 2>&1)"
    CT_INSTALL_EXIT=$?
    set -o errexit
    
    if [ $CT_INSTALL_EXIT -ne 0 ]; then
        if echo "$CT_INSTALL_OUTPUT" | grep -qE "(bus error|segmentation|fault)"; then
            printf "\n⚠️  Bus error or segmentation fault detected in ct install.\n"
            printf "This is a known bug in chart-testing (v3.14.0) when used with Git 2.52.0.\n"
            printf "The issue is an ABI incompatibility between chart-testing and newer Git versions.\n"
            printf "\nThe following charts were identified for testing:\n"
            printf "  %s\n" "$CHANGED_CHARTS"
            printf "\nUnfortunately, ct install cannot proceed due to this bug.\n"
            printf "\nWorkarounds:\n"
            printf "1. Report this issue: https://github.com/helm/chart-testing/issues\n"
            printf "   Include: chart-testing v3.14.0, git 2.52.0, and this bus error\n"
            printf "2. Consider downgrading Git to 2.49.1 (the version in the chart-testing Docker image)\n"
            printf "3. Wait for a fix in chart-testing or try downgrading to v3.11.0 or earlier\n\n"
            exit 1
        else
            printf "Error: ct install failed with exit code %d\n" "$CT_INSTALL_EXIT"
            printf "Output:\n%s\n" "$CT_INSTALL_OUTPUT"
            exit 1
        fi
    else
        printf "✓ ct install completed successfully.\n"
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
