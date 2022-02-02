#! /bin/sh

set -e

mkdir /tmp/bin
export PATH=$PATH:/tmp/bin
cd /tmp/bin
# Download kubectl to match the cluster version,
# using kubectl 1.19 for clusters <= 1.19.
default_kubectl_version='v1.19.6'
echo "Downloading jq . . ."
curl -sSLo jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 && chmod +x jq
echo "Getting the Kubernetes version from the API. . ."
kube_version=$(curl -ksS https://kubernetes.default.svc/version?timeout=32s | jq -r .gitVersion | cut -d- -f1)
echo "Found Kubernetes version $kube_version"
kube_minor_version=$(echo $kube_version |cut -d. -f2)
echo "Minor version is ${kube_minor_version}"
if [ "x${kube_version}" == "x" ] ; then
  kubectl_version="${default_kubectl_version}"
  echo "Unable to find cluster version. Using kubectl version ${kubectl_version}"
elif [ "$kube_minor_version" -gt 19 ] ; then
  kubectl_version="${kube_version}"
  echo "Using kubectl version ${kubectl_version} to match the cluster"
else
  kubectl_version="${default_kubectl_version}"
  echo "Using kubectl version ${kubectl_version} because the cluster is <= version 1.19"
fi
echo Downloading kubectl version ${kubectl_version}
curl -sSLo kubectl "https://dl.k8s.io/release/${kubectl_version}/bin/linux/amd64/kubectl" && chmod +x kubectl
