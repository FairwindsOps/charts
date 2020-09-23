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
| affinity | object | `{}` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| caBundle | string | `""` | If you are providing your own certificate then this is the Certificate Authority for that certificate |
| defaultRules | list | `[{"apiGroups":["apps"],"apiVersions":["v1","v1beta1","v1beta2"],"operations":["CREATE","UPDATE"],"resources":["daemonsets","deployments","statefulsets"],"scope":"Namespaced"},{"apiGroups":["batch"],"apiVersions":["v1","v1beta1"],"operations":["CREATE","UPDATE"],"resources":["jobs","cronjobs"],"scope":"Namespaced"},{"apiGroups":[""],"apiVersions":["v1"],"operations":["CREATE","UPDATE"],"resources":["pods","replicationcontrollers"],"scope":"Namespaced"}]` | An array of rules for commons types for the ValidatingWebhookConfiguration |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"Always"` |  |
| image.repository | string | `"quay.io/fairwinds/insights-admission-controller"` |  |
| image.tag | string | `"0.1"` |  |
| imagePullSecrets | list | `[]` |  |
| insights.base64token | string | `""` |  |
| insights.cluster | string | `""` |  |
| insights.host | string | `"https://insights.fairwinds.com"` |  |
| insights.organization | string | `""` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| podAnnotations | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| replicaCount | int | `1` |  |
| resources.limits.cpu | int | `1` |  |
| resources.limits.memory | string | `"2Gi"` |  |
| resources.requests.cpu | string | `"100m"` |  |
| resources.requests.memory | string | `"128Mi"` |  |
| rules | list | `[]` | An array of additional for the ValidatingWebhookConfiguration. Each requires a set of apiGroups, apiVersions, operations, resources, and a scope. |
| secretName | string | `""` |  |
| securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| securityContext.readOnlyRootFilesystem | bool | `true` |  |
| securityContext.runAsNonRoot | bool | `true` |  |
| securityContext.runAsUser | int | `15000` |  |
| service.port | int | `443` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| test | object | `{"enabled":false,"image":{"repository":"python","tag":"3.6"}}` | Deploy test deployment |
| tolerations | list | `[]` |  |
