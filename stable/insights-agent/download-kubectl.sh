#! /bin/sh

set -eo pipefail

mkdir /tmp/bin
export PATH=$PATH:/tmp/bin
cd /tmp/bin

# Download kubectl to match the cluster version,
# using kubectl 1.19 for clusters <= 1.19.

old_kubectl_version='v1.19.6'
default_kubectl_version=$(curl -fsSL https://dl.k8s.io/release/stable.txt)
echo "Downloading jq . . ."
curl -fsSLo jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 && chmod +x jq

echo "Getting the Kubernetes version from the API. . ."
kube_version_info=$(curl -kfsSL https://kubernetes.default.svc/version?timeout=32s)
echo "Found Kubernetes version info: $kube_version"
git_version=$(echo "${kube_version_info}" | jq -r .gitVersion | cut -d- -f1)
echo "Git version is ${git_version}"
kube_minor_version=$(echo "${kube_version_info}" | jq -r .minor)
echo "Minor version is ${kube_minor_version}"


version_pattern='v[0-9]+\.[0-9]+.[0-9]+)'
kubectl_version=""
if [ "${git_version}" =~ $pat ];
  kubectl_version="${git_version}"
fi
if [ "$kube_minor_version" -lt 19 ] ; then
  echo "Cluster version earlier than 1.19. Using kubectl version ${old_kubectl_version}"
  kubectl_version="${old_kubectl_version}"
fi
if [ "${kubectl_version}" == "" ] ; then
  echo "Unable to find cluster version. Using kubectl version ${default_kubectl_version}"
  kubectl_version="${default_kubectl_version}"
fi

echo Downloading kubectl version ${kubectl_version}
curl -fsSLo kubectl "https://dl.k8s.io/release/${kubectl_version}/bin/linux/amd64/kubectl" && chmod +x kubectl
