# Fairwinds Insights Admission Controller

## Intro

This is an Admission Controller to reject deployment of objects into your Kubernetes cluster that woudld create dangerous action items in [Fairwinds Insights](https://insights.fairwinds.com)

## Installation

A valid TLS certificate is required for this admission controller to work. If you have cert-manager installed then everything should work out of the box. If you don't use cert-manager and don't want to install it then you can supply a CA Bundle with the `caBundle` parameter and create a TLS secret and pass the name of that secret as `secretName`.

```bash
helm repo add fairwinds-stable https://charts.fairwinds.com/stable
helm install insights-admission fairwinds-stable/insights-admission \
  --namespace insights-admission \
  --set insights.organization=acme-co \
  --set insights.cluster=staging \
  --set insights.base64token="dG9rZW4="
```

If you have an additional type of object to monitor with this admission controller then you can add a values file that looks like this.

```
rules:
- apiGroups:
  - custom
  apiVersions:
  - v1
  operations:
  - CREATE
  - UPDATE
  resources:
  - customResource
  scope: Namespaced
```

## Chart Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Pod affinity/anti-affinity rules |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `20` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| caBundle | string | `""` | If you are providing your own certificate then this is the Certificate Authority for that certificate |
| defaultRules | list | `[{"apiGroups":["apps"],"apiVersions":["v1","v1beta1","v1beta2"],"operations":["CREATE","UPDATE"],"resources":["daemonsets","deployments","statefulsets"],"scope":"Namespaced"},{"apiGroups":["batch"],"apiVersions":["v1","v1beta1"],"operations":["CREATE","UPDATE"],"resources":["jobs","cronjobs"],"scope":"Namespaced"},{"apiGroups":[""],"apiVersions":["v1"],"operations":["CREATE","UPDATE"],"resources":["pods","replicationcontrollers"],"scope":"Namespaced"}]` | An array of rules for commons types for the ValidatingWebhookConfiguration |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"Always"` | imagePullPolicy - Highly recommended to leave this as 'Always' |
| image.repository | string | `"quay.io/fairwinds/insights-admission-controller"` | Repository for the Insights Admission Controller image |
| image.tag | string | `"0.1"` | The Insights admission controller tag to use. |
| imagePullSecrets | list | `[]` | Secrets to use when pulling this image. |
| insights.base64token | string | `""` | The token for your cluster from the Cluster Settings page in Fairwinds Insights. This should already be base64 encoded. |
| insights.cluster | string | `""` | The name of your cluster from Fairwinds Insights |
| insights.host | string | `"https://insights.fairwinds.com"` | Override the hostname for Fairwinds Insights |
| insights.organization | string | `""` | The name of your Organization from Fairwinds Insights |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| podAnnotations | object | `{}` | Annotations to add to each pod. |
| podSecurityContext | object | `{}` | Security Context for the entire pod. |
| replicaCount | int | `2` | The number of pods to run for the admission contrller. |
| resources | object | `{"limits":{"cpu":1,"memory":"2Gi"},"requests":{"cpu":"100m","memory":"128Mi"}}` | A resources block for the controller. |
| rules | list | `[]` | An array of additional for the ValidatingWebhookConfiguration. Each requires a set of apiGroups, apiVersions, operations, resources, and a scope. |
| secretName | string | `""` |  |
| securityContext | object | `{"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsNonRoot":true,"runAsUser":15000}` | Security Context for the container. |
| service.port | int | `443` | Port to use for the service. |
| service.type | string | `"ClusterIP"` | Type of service to create. |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| test | object | `{"enabled":false,"image":{"repository":"python","tag":"3.6"}}` | Deploy test deployment |
| tolerations | list | `[]` |  |
