#!/bin/sh

set -o errexit
set -o nounset
set -x

echo "Starting e2e tests"
echo "Helm version: $(helm version --short --client)"

# Upgrade git to 2.52.0 if needed
echo "Current git version: $(git --version)"
CURRENT_GIT_VERSION=$(git --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
if [ "$CURRENT_GIT_VERSION" != "2.52.0" ]; then
  echo "Upgrading git to 2.52.0..."
  apk --no-cache add build-base curl-dev expat-dev gettext-dev openssl-dev zlib-dev perl
  cd /tmp
  curl -L https://github.com/git/git/archive/v2.52.0.tar.gz -o git-2.52.0.tar.gz
  tar -xzf git-2.52.0.tar.gz
  cd git-2.52.0
  make configure
  ./configure --prefix=/usr
  make -j"$(nproc)"
  make install
  echo "Git upgraded to: $(git --version)"
fi

cd /charts
scripts/e2e-test.sh test
scripts/fleet-install-test.sh
