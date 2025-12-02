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
    
    # Workaround for partial clone + SSH authentication issues
    # If we have a partial clone and SSH remote, automatically convert to HTTPS
    # This prevents "promisor remote" errors when Git tries to fetch blob objects
    PARTIAL_CLONE=$(git config --get remote.origin.partialclonefilter 2>&1 || echo "")
    CURRENT_REMOTE=$(git remote get-url origin 2>&1)
    
    if [ -n "$PARTIAL_CLONE" ] && echo "$CURRENT_REMOTE" | grep -q 'git@github.com:'; then
        # Convert git@github.com:org/repo.git to https://github.com/org/repo.git
        NEW_REMOTE=$(echo "$CURRENT_REMOTE" | sed 's|git@github.com:\(.*\)|https://github.com/\1|')
        if git remote set-url origin "$NEW_REMOTE" 2>&1; then
            echo "Converted SSH remote to HTTPS for partial clone compatibility"
        fi
    fi
    
    ct install --config scripts/ct.yaml --debug --print-config --upgrade --helm-extra-args "--timeout 600s"
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
