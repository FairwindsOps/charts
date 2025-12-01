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

# Helper function to get changed charts using git directly (fallback when ct fails)
get_changed_charts_git() {
  TARGET_BRANCH="${1:-origin/master}"
  CHART_DIRS="${2:-stable incubator}"
  
  # Get merge base
  MERGE_BASE=$(git merge-base "$TARGET_BRANCH" HEAD 2>/dev/null || echo "")
  if [ -z "$MERGE_BASE" ]; then
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
  
  # Extract unique chart directories
  # Output the chart directories, one per line (matching ct list-changed format)
  printf "%s\n" "$CHANGED_FILES" | \
    grep -E "^($(echo "$CHART_DIRS" | tr ' ' '|'))/[^/]+/" | \
    sed -E 's|^([^/]+/[^/]+)/.*|\1|' | \
    sort -u | \
    tr '\n' ' ' | \
    sed 's/[[:space:]]*$//'
}

# Capture both stdout and stderr, temporarily disable errexit to handle failures gracefully
# Note: Explicitly specifying --target-branch may help avoid segmentation faults
set +o errexit
CHANGED="$(ct list-changed --config scripts/ct.yaml --target-branch master 2>&1)"
CT_EXIT_CODE=$?
set -o errexit

# Check if ct list-changed failed
if [ $CT_EXIT_CODE -ne 0 ] || echo "$CHANGED" | grep -qE "(Error|error|failed|segmentation|fault)"; then
  printf "Warning: ct list-changed failed. Using git-based fallback...\n"
  CHANGED="$(get_changed_charts_git origin/master "stable incubator")"
  GIT_FALLBACK_EXIT=$?
  
  if [ $GIT_FALLBACK_EXIT -ne 0 ] || [ -z "$CHANGED" ]; then
    printf "No changed charts detected. Skipping pre-test scripts.\n"
    exit 0
  fi
  
  printf "Changed charts detected via git: %s\n" "$CHANGED"
fi

# If CHANGED is empty, there are no changed charts, so skip
if [ -z "$CHANGED" ]; then
  printf "No changed charts detected. Skipping pre-test scripts.\n"
  exit 0
fi

for chart in ${CHANGED}; do
  if test -f "$chart/$SCRIPT"; then
    "$chart/$SCRIPT"
  fi
done
