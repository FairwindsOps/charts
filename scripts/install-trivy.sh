#! /bin/bash
set -eo pipefail

trivyVersion="0.69.2"
baseUrl="https://github.com/aquasecurity/trivy/releases/download/v${trivyVersion}"
tarball="trivy_${trivyVersion}_Linux-64bit.tar.gz"

curl -sSfL "${baseUrl}/${tarball}" -o "$tarball"
curl -sSfL "${baseUrl}/trivy_${trivyVersion}_checksums.txt" -o checksums.txt
grep -E " [* ]${tarball}\$" checksums.txt | sha256sum -c -
tar -xvf "$tarball"
sudo mv ./trivy /usr/local/bin/trivy
rm "$tarball" checksums.txt
