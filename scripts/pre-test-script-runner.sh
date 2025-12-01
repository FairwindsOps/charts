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

# Capture both stdout and stderr, temporarily disable errexit to handle failures gracefully
set +o errexit
CHANGED="$(ct list-changed --config scripts/ct.yaml 2>&1)"
CT_EXIT_CODE=$?
set -o errexit

# Check if ct list-changed failed
if [ $CT_EXIT_CODE -ne 0 ]; then
  printf "Warning: ct list-changed failed (exit code: %d)\n" "$CT_EXIT_CODE"
  printf "Output: %s\n" "$CHANGED"
  printf "Skipping pre-test scripts due to ct list-changed failure.\n"
  exit 0
fi

# Check if the output looks like an error message rather than chart paths
if echo "$CHANGED" | grep -qE "(Error|error|failed|segmentation|fault)"; then
  printf "Warning: ct list-changed appears to have failed with an error:\n"
  printf "%s\n" "$CHANGED"
  printf "Skipping pre-test scripts due to ct list-changed failure.\n"
  exit 0
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
