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
    
    # Log diagnostic information before running ct install
    echo "================================================================================"
    echo "DIAGNOSTIC INFORMATION - CT INSTALL"
    echo "================================================================================"
    echo "Current directory: $(pwd)"
    echo "Git branch: $(git branch --show-current 2>&1 || echo 'N/A')"
    echo "Git commit: $(git rev-parse HEAD 2>&1 || echo 'N/A')"
    echo "Git remote origin URL: $(git remote get-url origin 2>&1 || echo 'N/A')"
    echo ""
    echo "Checking if this is a partial clone:"
    git config --get remote.origin.partialclonefilter 2>&1 || echo "  No partial clone filter configured"
    git remote show origin 2>&1 | grep -E "(blob|filter|partial)" || echo "  No partial clone indicators in remote"
    echo "  Remote fetch config: $(git config --get remote.origin.fetch 2>&1 || echo 'N/A')"
    echo ""
    echo "Checking git worktree status:"
    git worktree list 2>&1 || echo "  git worktree list failed"
    echo ""
    echo "Checking if target branch commit exists locally:"
    TARGET_BRANCH=$(grep -E '^target-branch:' scripts/ct.yaml | sed 's/^target-branch: *//' || echo "master")
    echo "  Target branch: $TARGET_BRANCH"
    MERGE_BASE=$(git merge-base "origin/$TARGET_BRANCH" HEAD 2>&1 || echo "")
    if [ -n "$MERGE_BASE" ]; then
        echo "  Merge base commit: $MERGE_BASE"
        echo "  Merge base exists locally: $(git cat-file -e "$MERGE_BASE" 2>&1 && echo 'yes' || echo 'no')"
        echo "  Merge base tree: $(git cat-file -p "$MERGE_BASE" 2>&1 | head -5 || echo 'N/A')"
    else
        echo "  Could not determine merge base"
    fi
    echo ""
    echo "Checking git object availability:"
    echo "  Local objects: $(git count-objects -v 2>&1 | grep -E '^(count|size)' || echo 'N/A')"
    echo "  Checking if this is a partial clone (promisor remote):"
    if git config --get remote.origin.partialclonefilter >/dev/null 2>&1; then
        echo "    WARNING: This is a partial clone with filter: $(git config --get remote.origin.partialclonefilter)"
        echo "    This means blob objects are not stored locally and must be fetched on-demand"
        echo "    The 'promisor remote' error occurs when Git tries to fetch missing blobs"
    else
        echo "    Not a partial clone (all objects should be local)"
    fi
    echo "  Checking if we can access remote objects:"
    git ls-remote origin "$TARGET_BRANCH" 2>&1 | head -3 || echo "    Cannot access remote (this may be expected)"
    echo ""
    echo "Checking SSH configuration (if using SSH remote):"
    SSH_KEY_COUNT=0
    if git remote get-url origin 2>&1 | grep -q '@'; then
        echo "  Remote uses SSH"
        SSH_KEY_COUNT=$(find ~/.ssh -name 'id_*' -type f 2>/dev/null | wc -l || echo '0')
        echo "  SSH keys available: $SSH_KEY_COUNT keys found"
        echo "  SSH config: $(test -f ~/.ssh/config && echo 'exists' || echo 'not found')"
    else
        echo "  Remote does not use SSH"
    fi
    echo ""
    echo "Checking existing worktrees that might conflict:"
    find . -maxdepth 1 -name 'ct-previous-revision*' -type d 2>&1 | head -10 || echo "  No existing worktrees found"
    echo ""
    echo "Git configuration that might affect worktree creation:"
    git config --get-regexp '^(remote|fetch|worktree)' 2>&1 | head -10 || echo "  No relevant config found"
    echo "================================================================================"
    
    # Workaround for partial clone + SSH authentication issues
    # If we have a partial clone and SSH remote, try to automatically convert to HTTPS
    PARTIAL_CLONE=$(git config --get remote.origin.partialclonefilter 2>&1 || echo "")
    IS_SSH_REMOTE=$(git remote get-url origin 2>&1 | grep -q '@' && echo "yes" || echo "no")
    CURRENT_REMOTE=$(git remote get-url origin 2>&1)
    
    if [ -n "$PARTIAL_CLONE" ] && [ "$IS_SSH_REMOTE" = "yes" ]; then
        echo "================================================================================"
        echo "AUTOMATIC WORKAROUND: Converting SSH remote to HTTPS"
        echo "================================================================================"
        echo "Detected partial clone with SSH remote that will fail during worktree creation."
        echo "Automatically converting remote URL from SSH to HTTPS to avoid authentication issues."
        echo ""
        echo "Current remote: $CURRENT_REMOTE"
        
        # Extract org/repo from SSH URL (git@github.com:org/repo.git) or HTTPS URL
        if echo "$CURRENT_REMOTE" | grep -q 'git@github.com:'; then
            # Convert git@github.com:org/repo.git to https://github.com/org/repo.git
            NEW_REMOTE=$(echo "$CURRENT_REMOTE" | sed 's|git@github.com:\(.*\)|https://github.com/\1|')
            echo "New remote: $NEW_REMOTE"
            git remote set-url origin "$NEW_REMOTE" 2>&1
            if [ $? -eq 0 ]; then
                echo "✓ Successfully converted remote to HTTPS"
                echo "  This will allow Git to fetch blob objects without SSH authentication"
            else
                echo "✗ Failed to convert remote URL"
            fi
        else
            echo "  Remote URL format not recognized, skipping conversion"
        fi
        echo "================================================================================"
    fi
    
    echo "Running ct install command..."
    echo "Command: ct install --config scripts/ct.yaml --debug --print-config --upgrade --helm-extra-args '--timeout 600s'"
    echo "================================================================================"
    
    # Run ct install and capture exit code
    set +o errexit
    ct install --config scripts/ct.yaml --debug --print-config --upgrade --helm-extra-args "--timeout 600s"
    CT_INSTALL_EXIT_CODE=$?
    set -o errexit
    
    echo "================================================================================"
    echo "CT INSTALL EXIT CODE: $CT_INSTALL_EXIT_CODE"
    echo "================================================================================"
    
    if [ $CT_INSTALL_EXIT_CODE -ne 0 ]; then
        echo "ERROR: ct install failed with exit code $CT_INSTALL_EXIT_CODE"
        echo ""
        
        # Check if this is the known partial clone + SSH issue
        if [ -n "$PARTIAL_CLONE" ] && [ "$IS_SSH_REMOTE" = "yes" ]; then
            echo "================================================================================"
            echo "IDENTIFIED ISSUE: Partial Clone + SSH Authentication Failure"
            echo "================================================================================"
            echo "This repository is a partial clone (filter: $PARTIAL_CLONE) with an SSH remote."
            echo "When chart-testing tries to create a worktree for the previous revision,"
            echo "Git needs to fetch blob objects on-demand from the promisor remote."
            echo "However, SSH authentication is failing, preventing the fetch."
            echo ""
            echo "Error details:"
            echo "  - Partial clone filter: $PARTIAL_CLONE"
            echo "  - Remote URL: $(git remote get-url origin 2>&1)"
            echo "  - SSH keys found: $SSH_KEY_COUNT"
            echo ""
            echo "SOLUTIONS:"
            echo "  1. Configure SSH authentication in CI:"
            echo "     - Add SSH keys to CI environment"
            echo "     - Add GitHub host key to known_hosts"
            echo ""
            echo "  2. Convert remote to HTTPS (if public repo or token available):"
            echo "     git remote set-url origin https://github.com/FairwindsOps/charts.git"
            echo ""
            echo "  3. Use a full clone instead of partial clone:"
            echo "     git config --unset remote.origin.partialclonefilter"
            echo "     git fetch --unshallow  # if shallow clone"
            echo "     # Or re-clone without --filter=blob:none"
            echo ""
            echo "  4. Pre-fetch necessary objects before running ct install"
            echo "================================================================================"
            echo ""
        fi
        
        echo "Post-failure diagnostic information:"
        echo "  - Current worktrees:"
        git worktree list 2>&1 || echo "    git worktree list failed"
        echo ""
        echo "  - Failed worktree directories:"
        find . -maxdepth 1 -name 'ct-previous-revision*' -type d 2>&1 | head -10 || echo "    No worktree directories found"
        echo ""
        echo "  - Git status:"
        git status --short 2>&1 | head -20 || echo "    git status failed"
        echo ""
        echo "  - Checking if merge base commit is available:"
        if [ -n "$MERGE_BASE" ]; then
            git show --stat "$MERGE_BASE" 2>&1 | head -10 || echo "    Cannot show merge base commit"
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
