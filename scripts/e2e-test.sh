#!/usr/bin/env bash

# Copyright 2018 ReactiveOps. All rights reserved.
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
set -x

OPERATION="${1:-create}"
CI_REF="${2:-master}"
TEST_CLUSTER_NAME="${3:-helm-e2e}"
TILLER_NAMESPACE="${TILLER_NAMESPACE:-helm-system}"
EXEC_CONTAINER_NAME="${4:-executor}"
CHART_TEST_VERSION="v3.4.0"

setup_cluster () {
    printf "Creating cluster %s.  This could take a minute...\n" "$TEST_CLUSTER_NAME"
    kind create cluster --name="$TEST_CLUSTER_NAME" --wait=120s > /dev/null
}

setup_executor () {
    kubeconfig="$(kind get kubeconfig-path --name="$TEST_CLUSTER_NAME")"
    containerName="$TEST_CLUSTER_NAME-control-plane"
    docker rm -f executor || true
    docker run -itd \
        --env TILLER_NAMESPACE="${TILLER_NAMESPACE}" \
        --name "$EXEC_CONTAINER_NAME" \
        --network container:"$containerName" \
        --env KUBECONFIG=/.kube/config \
        gcr.io/kubernetes-charts-ci/test-image:"${CHART_TEST_VERSION}"
    docker exec "$EXEC_CONTAINER_NAME" sh -c 'mkdir -p /.kube'
    docker cp "$kubeconfig" "$EXEC_CONTAINER_NAME":/.kube/config
    port="$(docker inspect "$containerName" | jq -r '.[].NetworkSettings.Ports | keys[]' | sed 's/\/tcp//g')"
    echo "$port"
    docker inspect "$containerName" | jq .
    docker exec "$EXEC_CONTAINER_NAME" sh -c "sed -i 's/https:\/\/localhost:[0-9]\+/https:\/\/localhost:6443/g' /.kube/config"
    docker exec "$EXEC_CONTAINER_NAME" sh -c "sed -i 's/https:\/\/127.0.0.1:[0-9]\+/https:\/\/127.0.0.1:6443/g' /.kube/config"
}

teardown () {
    printf "Deleting kind cluster %s and exec container\n" "$TEST_CLUSTER_NAME"
    kind delete cluster --name="$TEST_CLUSTER_NAME"
    docker rm -f "$EXEC_CONTAINER_NAME" > /dev/null 2>&1 || true
}

setup_tiller () {
    docker exec "$EXEC_CONTAINER_NAME" kubectl create ns "${TILLER_NAMESPACE}"
    docker exec "$EXEC_CONTAINER_NAME" kubectl -n "${TILLER_NAMESPACE}" create sa tiller
    docker exec "$EXEC_CONTAINER_NAME" kubectl create clusterrolebinding tiller \
      --clusterrole cluster-admin \
      --serviceaccount="${TILLER_NAMESPACE}":tiller \
      --serviceaccount=kube-system:tiller
    docker exec "$EXEC_CONTAINER_NAME" helm init --wait --upgrade --service-account tiller --tiller-namespace "${TILLER_NAMESPACE}"
}

install_hostpath-provisioner() {
    # https://github.com/helm/chart-testing/blob/master/examples/kind/test/e2e-kind.sh
    # kind doesn't support Dynamic PVC provisioning yet, this one of ways to get it working
    # https://github.com/rimusz/charts/tree/master/stable/hostpath-provisioner

    # delete the default storage class
    docker exec "$EXEC_CONTAINER_NAME" sh -c "kubectl delete storageclass standard"

    echo "Install Hostpath Provisioner..."
    docker exec "$EXEC_CONTAINER_NAME" sh -c "helm repo add rimusz https://charts.rimusz.net"
    docker exec "$EXEC_CONTAINER_NAME" sh -c "helm repo update"
    docker exec "$EXEC_CONTAINER_NAME" sh -c "helm upgrade --install hostpath-provisioner --namespace kube-system rimusz/hostpath-provisioner"
    echo
}

prep_tests () {
    printf "Preparing e2e tests...\n"
    if [[ ! "$(docker inspect -f '{{.State.Running}}' "$EXEC_CONTAINER_NAME")" ]]; then
        printf "The exec container is not running.  Something is wrong.\n"
        exit 1
    fi

    docker exec "$EXEC_CONTAINER_NAME" sh -c 'helm version'

    docker exec "$EXEC_CONTAINER_NAME" sh -c 'git clone https://github.com/reactiveops/charts && cd charts && git remote add ro https://github.com/reactiveops/charts  &> /dev/null || true'
    docker exec "$EXEC_CONTAINER_NAME" sh -c 'cd charts && git fetch ro master'
    if [ -z "${CIRCLE_PR_NUMBER:-}" ]; then
        docker exec "$EXEC_CONTAINER_NAME" sh -c "cd charts && git checkout $CI_REF"
    else
        docker exec "$EXEC_CONTAINER_NAME" sh -c "cd charts && git fetch origin pull/$CIRCLE_PR_NUMBER/head:pr/$CIRCLE_PR_NUMBER && git checkout pr/$CIRCLE_PR_NUMBER"
    fi
}

prep_tests_local () {
    printf "Preparing e2e tests from local repo...\n"
    if [[ ! "$(docker inspect -f '{{.State.Running}}' "$EXEC_CONTAINER_NAME")" ]]; then
        printf "The exec container is not running.  Something is wrong.\n"
        exit 1
    fi

    docker exec "$EXEC_CONTAINER_NAME" sh -c 'helm version'
    docker cp . "$EXEC_CONTAINER_NAME":/workdir/charts/
    docker exec "$EXEC_CONTAINER_NAME" sh -c 'cd charts && git remote | xargs -n 1 git remote remove && git remote add ro https://github.com/reactiveops/charts && git fetch ro master'
}

pre_test_script () {
    printf "Running pre-test scripts if they exist...\n"

    docker exec "$EXEC_CONTAINER_NAME" sh -c "cd charts && scripts/pre-test-script-runner.sh"
}

run_tests () {
    printf "Running e2e tests...\n"
    if [[ ! "$(docker inspect -f '{{.State.Running}}' "$EXEC_CONTAINER_NAME")" ]]; then
        printf "The exec container is not running.  Something is wrong.\n"
        exit 1
    fi

    docker exec "$EXEC_CONTAINER_NAME" sh -c "cd charts && ct install --config scripts/ct.yaml"
}


if [ "$OPERATION" = "setup" ]; then
    printf "Running setup.\n"
    setup_cluster
    setup_executor
    setup_tiller
    install_hostpath-provisioner
    printf "e2e testing environment is ready.\n"
elif [ "$OPERATION" = "teardown" ] ; then
    printf "Running teardown.\n"
    teardown
    printf "e2e testing environment torn down.\n"
elif [ "$OPERATION" = "test" ]; then
    printf "Running tests.\n"
    prep_tests
    pre_test_script
    run_tests
elif [ "$OPERATION" = "test-local" ]; then
    printf "Running tests.\n"
    prep_tests_local
    pre_test_script
    run_tests
else
    printf "You need to specify teardown, setup, or test"
    exit 1
fi

set +x
