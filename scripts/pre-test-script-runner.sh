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

# Workaround for partial clone + SSH authentication issues
# Convert SSH remote to HTTPS if needed to prevent promisor remote errors
PARTIAL_CLONE=$(git config --get remote.origin.partialclonefilter 2>&1 || echo "")
CURRENT_REMOTE=$(git remote get-url origin 2>&1)
if [ -n "$PARTIAL_CLONE" ] && echo "$CURRENT_REMOTE" | grep -q 'git@github.com:'; then
    NEW_REMOTE=$(echo "$CURRENT_REMOTE" | sed 's|git@github.com:\(.*\)|https://github.com/\1|')
    if git remote set-url origin "$NEW_REMOTE" 2>&1; then
        # Verify the conversion took effect
        git remote get-url origin 2>&1 | grep -q 'https://' || echo "Warning: Remote conversion may not have taken effect"
    fi
fi

# Capture ct list-changed output and check for errors
# Use a temporary file to capture stderr separately
TMP_STDERR=$(mktemp)
set +o errexit
CHANGED_OUTPUT=$(ct list-changed --config scripts/ct.yaml --print-config 2>"$TMP_STDERR")
CT_EXIT_CODE=$?
CT_STDERR=$(cat "$TMP_STDERR" 2>&1 || echo "")
rm -f "$TMP_STDERR"
set -o errexit

# Check for segfault or other errors in exit code, stdout, or stderr
if [ $CT_EXIT_CODE -ne 0 ]; then
    echo "ERROR: ct list-changed failed with exit code $CT_EXIT_CODE"
    echo "STDOUT: $CHANGED_OUTPUT"
    echo "STDERR: $CT_STDERR"
    exit 1
fi

# Check if output or stderr contains error messages (even if exit code was 0)
if echo "$CHANGED_OUTPUT" | grep -qi "failed\|error\|segmentation\|core dumped"; then
    echo "ERROR: ct list-changed output contains error indicators"
    echo "STDOUT: $CHANGED_OUTPUT"
    echo "STDERR: $CT_STDERR"
    exit 1
fi

if echo "$CT_STDERR" | grep -qi "failed\|error\|segmentation\|core dumped"; then
    echo "ERROR: ct list-changed stderr contains error indicators"
    echo "STDOUT: $CHANGED_OUTPUT"
    echo "STDERR: $CT_STDERR"
    exit 1
fi

CHANGED="$CHANGED_OUTPUT"

for chart in ${CHANGED}; do
  if test -f "$chart/$SCRIPT"; then
    "$chart/$SCRIPT"
  fi
done
