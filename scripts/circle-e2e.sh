#!/bin/sh

set -o errexit
set -o nounset
set -x

echo "Starting e2e tests"
echo "helm version: $(helm version --short --client)"

cd /charts
scripts/e2e-test.sh test
