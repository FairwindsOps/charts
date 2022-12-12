#! /bin/sh

set -eo pipefail
# Get the OS and architecture, defaulting to linux/amd64
kubectl_os=$(uname -s | awk '{print tolower($0)}' || echo linux)
kubectl_arch=$(uname -m | awk '{print tolower($0)}' |sed -e 's/aarch/arm/' -e 's/x86_/amd/' || echo amd64)

mkdir /tmp/bin
export PATH=$PATH:/tmp/bin
export SERVICEACCOUNT=/var/run/secrets/kubernetes.io/serviceaccount
export TOKEN=$(cat ${SERVICEACCOUNT}/token)
export CACERT=${SERVICEACCOUNT}/ca.crt
cd /tmp/bin

# Download kubectl to match the cluster version,
# using kubectl 1.19 for clusters <= 1.19.

old_kubectl_version='v1.19.6'
default_kubectl_version=$(curl -fsSL https://dl.k8s.io/release/stable.txt)
version_pattern='v[0-9]+\.[0-9]+.[0-9]+)'
kubectl_version=""

echo "Getting the Kubernetes version from the API. . ."
if kube_version_info=$(curl -kfsSL --cacert ${CACERT} --header "Authorization: Bearer ${TOKEN}" https://kubernetes.default.svc/version?timeout=32s); then
  echo "Found Kubernetes version info: $kube_version_info"
  git_version=$(echo "${kube_version_info}" | jq -r .gitVersion | cut -d- -f1)
  echo "Git version is ${git_version}"
  kube_minor_version=$(echo "${kube_version_info}" | jq -r .minor)
  echo "Minor version is ${kube_minor_version}"
  if echo "${git_version}" | grep "^v[0-9]\+\.[0-9]\+\.[0-9]\+$"; then
    kubectl_version="${git_version}"
  fi
  if [ "$kube_minor_version" -lt 19 ] ; then
    echo "Cluster version earlier than 1.19. Using kubectl version ${old_kubectl_version}"
    kubectl_version="${old_kubectl_version}"
  fi
else
  echo "Was unable to connect to the Kubernetes API to find the current version. Will fall back to kubectl $default_kubectl_version"
  kubectl_version="${default_kubectl_version}"
fi

if [ "${kubectl_version}" == "" ] ; then
  echo "Unable to find cluster version. Using kubectl version ${default_kubectl_version}"
  kubectl_version="${default_kubectl_version}"
fi

echo Downloading kubectl version ${kubectl_version} for ${kubectl_os}/${kubectl_arch}
curl -fsSLo kubectl "https://dl.k8s.io/release/${kubectl_version}/bin/${kubectl_os}/${kubectl_arch}/kubectl" && chmod +x kubectl
echo Downloading kubectl checksum
curl -fsSLO https://dl.k8s.io/${kubectl_version}/bin/${kubectl_os}/${kubectl_arch}/kubectl.sha256 >kubectl.sha256 >/tmp/bin/kubectl.sha256
# THe busybox version of sha256sum wants two spaces between the checksum and filename.
sed -i -e 's/$/  kubectl/'  /tmp/bin/kubectl.sha256
echo Verifying kubectl checksum
sha256sum -c /tmp/bin/kubectl.sha256

