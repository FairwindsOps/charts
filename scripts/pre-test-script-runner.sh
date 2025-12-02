#! /usr/bin/env sh

# Copyright 2019 Fairwinds. All rights reserved.
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

CI_DIR="ci"
SCRIPT_NAME="pre-test-script.sh"
SCRIPT="$CI_DIR/$SCRIPT_NAME"

# Log diagnostic information before running ct list-changed
echo "================================================================================"
echo "DIAGNOSTIC INFORMATION - PRE-TEST SCRIPT RUNNER"
echo "================================================================================"
echo "Current directory: $(pwd)"
echo "User: $(whoami 2>&1 || echo 'N/A')"
echo "System info: $(uname -a 2>&1 || echo 'N/A')"
echo "Memory info:"
free -h 2>&1 || echo "  free command not available"
echo "Disk space:"
df -h . 2>&1 || echo "  df command failed"
echo ""
echo "Chart-testing version: $(ct version 2>&1 || echo 'ct version command failed')"
echo "Chart-testing binary location: $(which ct 2>&1 || echo 'ct not in PATH')"
echo "Chart-testing binary info: $(file $(which ct 2>&1) 2>&1 || echo 'N/A')"
echo ""
echo "Git branch: $(git branch --show-current 2>&1 || echo 'N/A')"
echo "Git commit: $(git rev-parse HEAD 2>&1 || echo 'N/A')"
echo "Git remote origin URL: $(git remote get-url origin 2>&1 || echo 'N/A')"
echo "Git remotes:"
git remote -v 2>&1 || echo "  git remote failed"
echo "Git status:"
git status --short 2>&1 || echo "git status failed"
echo "Git log (last 3 commits):"
git log --oneline -3 2>&1 || echo "git log failed"
echo ""
echo "CT configuration (scripts/ct.yaml):"
cat scripts/ct.yaml 2>&1 || echo "  Failed to read ct.yaml"
echo ""
echo "Target branch from ct.yaml: $(grep -E '^target-branch:' scripts/ct.yaml 2>&1 || echo 'N/A')"
echo "Chart directories: $(grep -E '^chart-dirs:' -A 10 scripts/ct.yaml 2>&1 | grep -E '^\s+-' || echo 'N/A')"
echo ""
echo "Checking git diff capability (this is what ct uses internally):"
echo "  - Testing git diff against target branch:"
TARGET_BRANCH=$(grep -E '^target-branch:' scripts/ct.yaml | sed 's/^target-branch: *//' || echo "master")
echo "    Target branch: $TARGET_BRANCH"
git fetch origin "$TARGET_BRANCH" 2>&1 | head -5 || echo "    git fetch failed"
git diff --name-only "origin/$TARGET_BRANCH" 2>&1 | head -20 || echo "    git diff failed"
echo "================================================================================"
echo "Running ct list-changed command..."
echo "Command: ct list-changed --config scripts/ct.yaml --print-config"
echo "================================================================================"

# Capture both stdout and stderr separately
CHANGED_OUTPUT=""
CHANGED_ERROR=""
set +o errexit  # Temporarily disable errexit to capture the error
CHANGED_OUTPUT=$(ct list-changed --config scripts/ct.yaml --print-config 2> /tmp/ct-list-changed.stderr)
CT_EXIT_CODE=$?
CHANGED_ERROR=$(cat /tmp/ct-list-changed.stderr 2>&1 || echo "")
set -o errexit  # Re-enable errexit

echo "================================================================================"
echo "CT LIST-CHANGED OUTPUT (stdout):"
echo "================================================================================"
echo "$CHANGED_OUTPUT"
echo "================================================================================"
echo "CT LIST-CHANGED ERROR OUTPUT (stderr):"
echo "================================================================================"
echo "$CHANGED_ERROR"
echo "================================================================================"
echo "CT LIST-CHANGED EXIT CODE: $CT_EXIT_CODE"
echo "================================================================================"

# Check if the command failed
if [ $CT_EXIT_CODE -ne 0 ]; then
    echo "ERROR: ct list-changed failed with exit code $CT_EXIT_CODE"
    echo "This may indicate a segmentation fault or other critical error."
    echo ""
    echo "Additional debugging information:"
    echo "  - Checking if target branch exists:"
    TARGET_BRANCH=$(grep -E '^target-branch:' scripts/ct.yaml | sed 's/^target-branch: *//' || echo "master")
    echo "    Target branch: $TARGET_BRANCH"
    git ls-remote --heads origin "$TARGET_BRANCH" 2>&1 || echo "    Could not find target branch in remote"
    echo ""
    echo "  - Checking git diff capability:"
    git diff --name-only HEAD~1 2>&1 | head -20 || echo "    git diff failed"
    echo ""
    echo "  - Checking for large files that might cause issues:"
    find . -type f -size +10M -not -path './.git/*' 2>&1 | head -10 || echo "    No large files found"
    echo ""
    echo "  - Checking for binary files in chart directories:"
    find stable incubator -type f -exec file {} \; 2>&1 | grep -E "(binary|executable)" | head -10 || echo "    No obvious binary files found"
    echo ""
    echo "  - Checking git repository size:"
    du -sh .git 2>&1 || echo "    Could not check .git size"
    echo ""
    echo "  - Checking for corrupted git objects:"
    git fsck --no-full 2>&1 | head -20 || echo "    git fsck failed or found no issues"
    exit 1
fi

# Check if output contains error messages
if echo "$CHANGED_OUTPUT" | grep -qi "failed\|error\|segmentation\|core dumped"; then
    echo "ERROR: ct list-changed output contains error indicators"
    echo "Output: $CHANGED_OUTPUT"
    exit 1
fi

CHANGED="$CHANGED_OUTPUT"

for chart in ${CHANGED}; do
  if test -f "$chart/$SCRIPT"; then
    "$chart/$SCRIPT"
  fi
done
