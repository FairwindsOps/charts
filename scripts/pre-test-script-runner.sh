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

# Try ct first, fall back to git if it fails
set +o errexit
CHANGED="$(ct list-changed --config scripts/ct.yaml --target-branch master 2>&1)"
CT_EXIT=$?
set -o errexit

if [ $CT_EXIT -ne 0 ] || echo "$CHANGED" | grep -qE "(Error|error|failed|segmentation|fault)"; then
  # Fallback to git-based detection
  MERGE_BASE=$(git merge-base origin/master HEAD 2>/dev/null || echo "")
  if [ -n "$MERGE_BASE" ]; then
    CHANGED_FILES=$(git diff --find-renames --name-only "$MERGE_BASE" HEAD -- stable incubator 2>/dev/null || echo "")
    if [ -n "$CHANGED_FILES" ]; then
      CHANGED=$(echo "$CHANGED_FILES" | grep -E "^(stable|incubator)/[^/]+/" | sed -E 's|^([^/]+/[^/]+)/.*|\1|' | sort -u | tr '\n' ' ' | sed 's/[[:space:]]*$//')
    fi
  fi
fi

for chart in ${CHANGED}; do
  if test -f "$chart/$SCRIPT"; then
    "$chart/$SCRIPT"
  fi
done
