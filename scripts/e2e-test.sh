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
    
    # First, try to identify changed charts to see if ct list-changed works
    # If it fails, ct install will also fail, so we can provide a better error message
    set +o errexit
    CHANGED_CHARTS="$(ct list-changed --config scripts/ct.yaml 2>&1)"
    LIST_CHANGED_EXIT=$?
    set -o errexit
    
    if [ $LIST_CHANGED_EXIT -ne 0 ] || echo "$CHANGED_CHARTS" | grep -qE "(Error|error|failed|segmentation|fault)"; then
        printf "Error: ct list-changed failed, which means ct install will also fail.\n"
        printf "This is likely due to a segmentation fault in the chart-testing tool.\n"
        printf "Output from ct list-changed:\n%s\n" "$CHANGED_CHARTS"
        printf "\nPossible solutions:\n"
        printf "1. Update chart-testing to the latest version\n"
        printf "2. Check your git repository state (ensure origin/master is accessible)\n"
        printf "3. Try running: git fetch origin master\n"
        printf "4. Check if there are any corrupted git objects\n"
        exit 1
    fi
    
    # If no charts changed, skip installation
    if [ -z "$CHANGED_CHARTS" ]; then
        printf "No changed charts detected. Skipping installation tests.\n"
        exit 0
    fi
    
    printf "Changed charts detected: %s\n" "$CHANGED_CHARTS"
    printf "Running ct install...\n"
    
    # Now run ct install - wrap in error handling in case it still fails
    set +o errexit
    ct install --config scripts/ct.yaml --debug --upgrade --helm-extra-args "--timeout 600s" 2>&1
    CT_INSTALL_EXIT=$?
    set -o errexit
    
    if [ $CT_INSTALL_EXIT -ne 0 ]; then
        printf "Error: ct install failed with exit code %d\n" "$CT_INSTALL_EXIT"
        printf "This may be due to a segmentation fault in the chart-testing tool.\n"
        printf "\nPossible solutions:\n"
        printf "1. Update chart-testing to the latest version\n"
        printf "2. Check your git repository state\n"
        printf "3. Try running: git fetch origin master\n"
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
