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

# Try to get changed charts, but handle segmentation fault gracefully
# If ct list-changed fails, we'll process all charts that have pre-test scripts
CHANGED="$(ct list-changed --config scripts/ct.yaml --print-config 2>&1 || echo '')"

# Check if the output contains an error (segmentation fault or other error)
if echo "$CHANGED" | grep -q "segmentation fault\|failed creating diff\|Error:"; then
  echo "Warning: ct list-changed failed, will check all charts for pre-test scripts"
  # Find all charts that have pre-test scripts
  CHANGED=""
  for dir in stable incubator; do
    for chart_dir in "$dir"/*; do
      if [ -d "$chart_dir" ] && [ -f "$chart_dir/$SCRIPT" ]; then
        CHANGED="$CHANGED $chart_dir"
      fi
    done
  done
fi

for chart in ${CHANGED}; do
  if test -f "$chart/$SCRIPT"; then
    "$chart/$SCRIPT"
  fi
done
