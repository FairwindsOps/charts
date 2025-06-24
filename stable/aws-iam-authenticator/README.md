# aws-iam-authenticator

Runs the AWS Iam Authenticator as a daemonset on master nodes in order to authenticate your users with AWS IAM.  This requires additional setup on your cluster to work.  See the [docs](https://github.com/kubernetes-sigs/aws-iam-authenticator) for more information.

## Upgrading to v1.3.0+

In this version, due to updates for Kubernetes 1.16+, the labelSelector for the pod-deployment relationship has changed. This means that the chart will have to be deleted and re-installed in order to accomadate this upgrade.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| image.repository | string | `"602401143452.dkr.ecr.us-west-2.amazonaws.com/amazon/aws-iam-authenticator"` |  |
| image.tag | string | `"v0.5.9"` |  |
| priorityClassName | string | `"system-cluster-critical"` |  |
| volumes.output.mountPath | string | `"/etc/kubernetes/aws-iam-authenticator/"` |  |
| volumes.output.hostPath | string | `"/srv/kubernetes/kube-apiserver/aws-iam-authenticator/"` |  |
| volumes.state.mountPath | string | `"/var/aws-iam-authenticator/"` |  |
| volumes.state.hostPath | string | `"/srv/kubernetes/kube-apiserver/aws-iam-authenticator/"` |  |
| volumes.config.mountPath | string | `"/etc/aws-iam-authenticator/"` |  |
| nodeSelector | object | `{"node-role.kubernetes.io/master":""}` | Node selection constraint |
| tolerations | list | Tolerate node-role.kubernetes.io/master and CriticalAddonsOnly | Taint tolerations |
| configMap | object | `{}` |  |
| resources.requests.memory | string | `"20Mi"` |  |
| resources.requests.cpu | string | `"10m"` |  |
| resources.limits.memory | string | `"20Mi"` |  |
| resources.limits.cpu | string | `"100m"` |  |
| extraManifests | list | `[]` | A list of extra manifests to be installed with this chart. This is useful for installing additional resources that are not part of the chart |
