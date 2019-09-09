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

SCRIPT_PATH="$(cd "$(dirname "$0")" || return ; pwd -P)"
CI_DIR="ci"
SCRIPT_NAME="pre-test-script.sh"
SCRIPT="$CI_DIR/$SCRIPT_NAME"

for chart in "$SCRIPT_PATH"/../incubator/* ; do
  if test -f "$chart/$SCRIPT"; then
    "$chart/$SCRIPT"
  fi
done

for chart in "$SCRIPT_PATH"/../stable/* ; do
  if test -f "$chart/$SCRIPT"; then
    "$chart/$SCRIPT"
  fi
done
