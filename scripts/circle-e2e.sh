#!/bin/sh

set -o errexit
set -o nounset
set -x

echo "Starting e2e tests"
echo "Helm version: $(helm version --short --client)"
echo "Git version: $(git --version)"
echo "Note: Using Git version from chart-testing Docker image (compatible with ct)"

cd /charts
scripts/e2e-test.sh test
scripts/fleet-install-test.sh
