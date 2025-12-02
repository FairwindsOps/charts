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
    git remote set-url origin "$NEW_REMOTE" 2>&1 || true
fi

# Capture ct list-changed output and check for errors
set +o errexit
CHANGED_OUTPUT=$(ct list-changed --config scripts/ct.yaml --print-config 2>&1)
CT_EXIT_CODE=$?
set -o errexit

# Check for segfault or other errors
if [ $CT_EXIT_CODE -ne 0 ] || echo "$CHANGED_OUTPUT" | grep -qi "failed\|error\|segmentation\|core dumped"; then
    echo "ERROR: ct list-changed failed"
    echo "Exit code: $CT_EXIT_CODE"
    echo "Output: $CHANGED_OUTPUT"
    exit 1
fi

CHANGED="$CHANGED_OUTPUT"

for chart in ${CHANGED}; do
  if test -f "$chart/$SCRIPT"; then
    "$chart/$SCRIPT"
  fi
done
