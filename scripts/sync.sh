#!/usr/bin/env bash

# Copyright 2018 The Kubernetes Authors. All rights reserved.
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
set -o pipefail

readonly HELM_URL=https://get.helm.sh
readonly HELM_TARBALL=helm-v3.2.0-linux-amd64.tar.gz
readonly STABLE_REPO_URL=https://charts.fairwinds.com/stable/
readonly INCUBATOR_REPO_URL=https://charts.fairwinds.com/incubator/
readonly JETSTACK_REPO_URL=https://charts.jetstack.io
readonly PROMETHEUS_REPO_URL=https://prometheus-community.github.io/helm-charts
readonly S3_BUCKET_STABLE=s3://fairwinds-helm-charts/stable
readonly S3_BUCKET_INCUBATOR=s3://fairwinds-helm-charts/incubator

main() {
    setup_helm_client
    authenticate

    if ! sync_repo stable "$S3_BUCKET_STABLE" "$STABLE_REPO_URL"; then
        log_error "Not all stable charts could be packaged and synced!"
    fi
    if ! sync_repo incubator "$S3_BUCKET_INCUBATOR" "$INCUBATOR_REPO_URL"; then
        log_error "Not all incubator charts could be packaged and synced!"
    fi
}

setup_helm_client() {
    echo "Setting up Helm client..."

    curl --user-agent curl-ci-sync -sSL -o "$HELM_TARBALL" "$HELM_URL/$HELM_TARBALL"
    tar xzfv "$HELM_TARBALL"

    PATH="$(pwd)/linux-amd64/:$PATH"

    helm repo add fairwinds-stable "$STABLE_REPO_URL"
    helm repo add fairwinds-incubator "$INCUBATOR_REPO_URL"
    helm repo add jetstack "$JETSTACK_REPO_URL"
    helm repo add prometheus-community "$PROMETHEUS_REPO_URL"
}

authenticate() {
    echo "Checking AWS Authentication"
    aws sts get-caller-identity
}

sync_repo() {
    local repo_dir="${1?Specify repo dir}"
    local bucket="${2?Specify repo bucket}"
    local repo_url="${3?Specify repo url}"
    local sync_dir="${repo_dir}-sync"
    local index_dir="${repo_dir}-index"

    echo "Syncing repo '$repo_dir'..."

    mkdir -p "$sync_dir"
    if ! aws s3 cp "$bucket/index.yaml" "$index_dir/index.yaml"; then
        log_error "Exiting because unable to copy index locally. Not safe to proceed."
        exit 1
    fi

    local exit_code=0

    for dir in "$repo_dir"/*; do
        if helm dependency build "$dir"; then
            helm package --destination "$sync_dir" "$dir"
        else
            log_error "Problem building dependencies. Skipping packaging of '$dir'."
            exit_code=1
        fi
    done

    if helm repo index --url "$repo_url" --merge "$index_dir/index.yaml" "$sync_dir"; then
        # Move updated index.yaml to sync folder so we don't push the old one again
        mv -f "$sync_dir/index.yaml" "$index_dir/index.yaml"

        aws s3 sync --exclude index.yaml "$sync_dir" "$bucket"

        # Make sure index.yaml is synced last
        aws s3 cp "$index_dir/index.yaml" "$bucket/index.yaml"
    else
        log_error "Exiting because unable to update index. Not safe to push update."
        exit 1
    fi

    aws cloudfront create-invalidation --distribution-id=E1ZJM6TTQD49VX --paths "/stable/index.yaml" "/incubator/index.yaml"

    ls -l "$sync_dir"

    return "$exit_code"
}

log_error() {
    printf '\e[31mERROR: %s\n\e[39m' "$1" >&2
}

main
