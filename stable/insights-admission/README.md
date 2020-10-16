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

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| insights.organization | string | `""` | The name of your Organization from Fairwinds Insights |
| insights.cluster | string | `""` | The name of your cluster from Fairwinds Insights |
| insights.host | string | `"https://insights.fairwinds.com"` | Override the hostname for Fairwinds Insights |
| insights.base64token | string | `""` | The token for your cluster from the Cluster Settings page in Fairwinds Insights. This should already be base64 encoded. |
| webhookConfig.failurePolicy | string | `"Fail"` | failurePolicy for the ValidatingWebhookConfiguration |
| webhookConfig.matchPolicy | string | `"Exact"` | matchPolicy for the ValidatingWebhookConfiguration |
| webhookConfig.namespaceSelector | object | `{"matchExpressions":[{"key":"control-plane","operator":"DoesNotExist"}]}` | namespaceSelector for the ValidatingWebhookConfiguration |
| webhookConfig.objectSelector | object | `{}` | objectSelector for the ValidatingWebhookConfiguration |
| webhookConfig.rules | list | `[]` | An array of additional for the ValidatingWebhookConfiguration. Each requires a set of apiGroups, apiVersions, operations, resources, and a scope. |
| webhookConfig.defaultRules | list | `[{"apiGroups":["apps"],"apiVersions":["v1","v1beta1","v1beta2"],"operations":["CREATE","UPDATE"],"resources":["daemonsets","deployments","statefulsets"],"scope":"Namespaced"},{"apiGroups":["batch"],"apiVersions":["v1","v1beta1"],"operations":["CREATE","UPDATE"],"resources":["jobs","cronjobs"],"scope":"Namespaced"},{"apiGroups":[""],"apiVersions":["v1"],"operations":["CREATE","UPDATE"],"resources":["pods","replicationcontrollers"],"scope":"Namespaced"}]` | An array of rules for commons types for the ValidatingWebhookConfiguration |
| resources | object | `{"limits":{"cpu":1,"memory":"2Gi"},"requests":{"cpu":"100m","memory":"128Mi"}}` | A resources block for the controller. |
| image.repository | string | `"quay.io/fairwinds/insights-admission-controller"` | Repository for the Insights Admission Controller image |
| image.pullPolicy | string | `"Always"` | imagePullPolicy - Highly recommended to leave this as 'Always' |
| image.tag | string | `""` | The Insights admission controller tag to use. Defaults to the Chart's AppVersion |
| imagePullSecrets | list | `[]` | Secrets to use when pulling this image. |
| replicaCount | int | `2` | The number of pods to run for the admission contrller. |
| autoscaling.enabled | bool | `false` | Autoscale instead of a static number of pods running. |
| autoscaling.minReplicas | int | `2` | Minimum number of pods to run. |
| autoscaling.maxReplicas | int | `5` | Maximum number of pods to run. |
| autoscaling.targetCPUUtilizationPercentage | int | `80` | Target CPU to scale towards. |
| autoscaling.targetMemoryUtilizationPercentage | string | `nil` | Target memory to scale towards. |
| nameOverride | string | `""` | Overrides the name of the release. |
| fullnameOverride | string | `""` | Long name of the release to override. |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| podAnnotations | object | `{}` | Annotations to add to each pod. |
| podSecurityContext | object | `{}` | Security Context for the entire pod. |
| securityContext | object | `{"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsNonRoot":true,"runAsUser":15000}` | Security Context for the container. |
| service.type | string | `"ClusterIP"` | Type of service to create. |
| service.port | int | `443` | Port to use for the service. |
| nodeSelector | object | `{}` | nodSelector to add to the controller. |
| tolerations | list | `[]` | Toleratations to add to the controller. |
| affinity | object | `{}` | Pod affinity/anti-affinity rules |
| caBundle | string | `""` | If you are providing your own certificate then this is the Certificate Authority for that certificate |
| secretName | string | `""` | If you are providing your own certificate then this is the name of the secret holding the certificate. |
| clusterDomain | string | `"cluster.local"` | The base domain to use for cluster DNS |
| test | object | `{"enabled":false,"image":{"repository":"python","tag":"3.8-alpine"}}` | Used for chart CI only - deploys a test deployment |
