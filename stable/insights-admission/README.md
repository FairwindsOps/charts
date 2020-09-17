# Fairwinds Insights Admission Controller

## Intro

This is an Admission Controller to reject deployment of objects into your Kubernetes cluster that woudld create dangerous action items in [Fairwinds Insights](https://insights.fairwinds.com)

## Installation
```bash
helm repo add fairwinds-stable https://charts.fairwinds.com/stable
helm install gemini fairwinds-stable/insights-admission \
  --namespace insights-admission \
  --set insights.organization=acme-co \
  --set insights.cluster=staging \
  --set insights.base64token="dG9rZW4="
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| certificateupdater.image.repository | string | `"newrelic/k8s-webhook-cert-manager"` |  |
| certificateupdater.image.tag | string | `"1.3.0"` |  |
| certificateupdater.resources.limits.cpu | string | `"150m"` |  |
| certificateupdater.resources.limits.memory | string | `"512Mi"` |  |
| certificateupdater.resources.requests.cpu | string | `"100m"` |  |
| certificateupdater.resources.requests.memory | string | `"128Mi"` |  |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"Always"` |  |
| image.repository | string | `"quay.io/fairwinds/insights-admission-controller"` |  |
| image.tag | string | `"bb-admission-controller"` |  |
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
| rules[0].apiGroups[0] | string | `"apps"` |  |
| rules[0].apiVersion[0] | string | `"v1"` |  |
| rules[0].apiVersion[1] | string | `"v1beta1"` |  |
| rules[0].apiVersion[2] | string | `"v1beta2"` |  |
| rules[0].operations[0] | string | `"CREATE"` |  |
| rules[0].operations[1] | string | `"UPDATE"` |  |
| rules[0].resources[0] | string | `"daemonsets"` |  |
| rules[0].resources[1] | string | `"deployments"` |  |
| rules[0].resources[2] | string | `"statefulsets"` |  |
| rules[0].scope | string | `"Namespaced"` |  |
| rules[1].apiGroups[0] | string | `"batch"` |  |
| rules[1].apiVersions[0] | string | `"v1"` |  |
| rules[1].apiVersions[1] | string | `"v1beta1"` |  |
| rules[1].operations[0] | string | `"CREATE"` |  |
| rules[1].operations[1] | string | `"UPDATE"` |  |
| rules[1].resources[0] | string | `"jobs"` |  |
| rules[1].resources[1] | string | `"cronjobs"` |  |
| rules[1].scope | string | `"Namespaced"` |  |
| rules[2].apiGroups[0] | string | `""` |  |
| rules[2].apiVersions[0] | string | `"v1"` |  |
| rules[2].operations[0] | string | `"CREATE"` |  |
| rules[2].operations[1] | string | `"UPDATE"` |  |
| rules[2].resources[0] | string | `"pods"` |  |
| rules[2].resources[1] | string | `"replicationcontrollers"` |  |
| rules[2].scope | string | `"Namespaced"` |  |
| securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| securityContext.readOnlyRootFilesystem | bool | `true` |  |
| securityContext.runAsNonRoot | bool | `true` |  |
| securityContext.runAsUser | int | `15000` |  |
| service.port | int | `443` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| tolerations | list | `[]` |  |
