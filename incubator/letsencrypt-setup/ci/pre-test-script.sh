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

SCRIPT_PATH="$(cd "$(dirname "$0")" || return ; pwd -P)"
APP_VERSION=$(grep -E "^appVersion:" "$SCRIPT_PATH"/../Chart.yaml | awk '{print $2}')
APP_VERSION_MINI=$(echo "$APP_VERSION" | awk -F"." '{print $1"."$2}'|sed 's/^v//g')

kubectl --validate=false apply -f https://github.com/cert-manager/cert-manager/releases/download/"${APP_VERSION_MINI}"/cert-manager.yaml
