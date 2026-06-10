#! /bin/bash

if hash sudo; then
  SUDO=sudo
else
  SUDO=""
fi

$SUDO apt-get update

if ! hash yq; then
  curl -L "https://github.com/mikefarah/yq/releases/download/v4.50.1/yq_linux_amd64" > yq
  chmod +x yq
  $SUDO mv yq /usr/local/bin/
fi

if ! hash curl; then
  $SUDO apt-get install -y curl
fi

if ! hash unzip; then
  $SUDO apt-get install -y unzip
fi

cd /tmp
curl -LO https://releases.hashicorp.com/vault/1.21.1/vault_1.21.1_linux_amd64.zip
unzip -o vault_1.21.1_linux_amd64.zip

$SUDO mv vault /usr/local/bin/vault
