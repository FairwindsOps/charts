#!/bin/sh

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
set -x

OPERATION="${1:-create}"
TEST_CLUSTER_NAME="${3:-helm-e2e}"

setup_cluster () {
    printf "Creating cluster %s.  This could take a minute...\n" "$TEST_CLUSTER_NAME"
    kind create cluster --name="$TEST_CLUSTER_NAME" --wait=120s > /dev/null
}

init_helm() {
    if helm version --short --client; then
        echo "Helm 2 Detected"
        kubectl create ns tiller-system
        kubectl -n tiller-system create sa tiller
        kubectl create clusterrolebinding tiller \
          --clusterrole cluster-admin \
          --serviceaccount=tiller-system:tiller
        helm init --wait --upgrade --service-account tiller --tiller-namespace tiller-system
    fi
}

install_hostpath_provisioner() {
    # https://github.com/helm/chart-testing/blob/master/examples/kind/test/e2e-kind.sh
    # kind doesn't support Dynamic PVC provisioning yet, this one of ways to get it working
    # https://github.com/rimusz/charts/tree/master/stable/hostpath-provisioner

    # delete the default storage class
    kubectl delete storageclass standard

    echo "Install Hostpath Provisioner..."
    helm repo add rimusz https://charts.rimusz.net
    helm repo update
    helm upgrade --install hostpath-provisioner --namespace kube-system rimusz/hostpath-provisioner
    echo
}


teardown () {
    printf "Deleting kind cluster %s and exec container\n" "$TEST_CLUSTER_NAME"
    kind delete cluster --name="$TEST_CLUSTER_NAME"
}

pre_test_script () {
    printf "Running pre-test scripts if they exist...\n"
    scripts/pre-test-script-runner.sh
}

run_tests () {
    printf "Running e2e tests...\n"
    ct install --config scripts/ct.yaml
}


if [ "$OPERATION" = "setup" ]; then
    printf "Running setup.\n"
    setup_cluster
    init_helm
    install_hostpath_provisioner
    printf "e2e testing environment is ready.\n"
elif [ "$OPERATION" = "teardown" ] ; then
    printf "Running teardown.\n"
    teardown
    printf "e2e testing environment torn down.\n"
elif [ "$OPERATION" = "test" ]; then
    printf "Running tests.\n"
    pre_test_script
    run_tests
else
    printf "You need to specify teardown, setup, test"
    exit 1
fi

set +x
