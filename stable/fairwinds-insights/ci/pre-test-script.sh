#!/bin/sh

# Pre-test script for fairwinds-insights chart
# This script ensures dependencies are properly built before testing

set -o errexit
set -o nounset
set -x

echo "Building dependencies for fairwinds-insights chart..."
helm dependency build .
echo "Dependencies built successfully."
