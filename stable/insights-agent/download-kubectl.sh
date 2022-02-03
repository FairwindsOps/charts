#! /bin/sh

set -eo pipefail

mkdir /tmp/bin
export PATH=$PATH:/tmp/bin
cd /tmp/bin
# Download kubectl to match the cluster version,
# using kubectl 1.19 for clusters <= 1.19.
default_kubectl_version='v1.19.6'
echo "Downloading jq . . ."
curl -sSLo jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 && chmod +x jq
echo "Getting the Kubernetes version from the API. . ."
kube_version_info=$(curl -fksS https://kubernetes.default.svc/version?timeout=32s)
echo "Found Kubernetes version info: $kube_version"
kube_minor_version=$(echo "${kube_version_info}" | jq -r .minor)
if [ "${kube_minor_version}" == "null" ]; then
  git_version=$(echo "${kube_version_info}" | jq -r .gitVersion | cut -d- -f1)
  echo "Extracted gitVersion: $git_version"
  kube_minor_version=$(echo $git_version |cut -d. -f2)
fi

echo "Minor version is ${kube_minor_version}"
if [ "${kube_minor_version}" == "" ] || [ "${kube_minor_version}" == "null" ] ; then
  echo "Unable to find cluster version. Using kubectl version ${kubectl_version}"
  kubectl_version="${default_kubectl_version}"
elif [ "$kube_minor_version" -gt 19 ] ; then
  echo "Using kubectl version ${kubectl_version} to match the cluster"
  kubectl_version="${kube_version}"
else
  echo "Using kubectl version ${kubectl_version} because the cluster is <= version 1.19"
  kubectl_version="${default_kubectl_version}"
fi
echo Downloading kubectl version ${kubectl_version}
curl -sSLo kubectl "https://dl.k8s.io/release/${kubectl_version}/bin/linux/amd64/kubectl" && chmod +x kubectl
