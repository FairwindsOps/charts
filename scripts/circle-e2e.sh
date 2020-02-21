#!/bin/sh

set -o errexit
set -o nounset
set -x

echo "Starting e2e tests"

if helm version --short --client; then
    echo "Helm 2 Detected"
fi

cd /charts
scripts/e2e-test.sh test
