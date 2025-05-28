#!/bin/sh

set -o errexit
set -o nounset
set -x

echo "Starting e2e tests"
echo "Helm version: $(helm version --short --client)"

cd /charts
scripts/e2e-test.sh test
scripts/fleet-install-test.sh
