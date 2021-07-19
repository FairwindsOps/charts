# Kubernetes OOM Event Generator
A chart for https://github.com/xing/kubernetes-oom-event-generator

# Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `replicaCount` | int | `1` |  |
| `image.repository` | string | `"xingse/kubernetes-oom-event-generator"` |  |
| `image.pullPolicy` | string | `"Always"` |  |
| `image.tag` | string | `"v1.2.0"` |  |
| `imagePullSecrets` | list | `[]` |  |
| `nameOverride` | string | `""` |  |
| `fullnameOverride` | string | `""` |  |
| `serviceAccount.create` | bool | `true` |  |
| `serviceAccount.annotations` | object | `{}` |  |
| `serviceAccount.name` | string | `""` |  |
| `podAnnotations` | object | `{}` |  |
| `podSecurityContext` | object | `{}` |  |
| `securityContext` | object | `{}` |  |
| `env` | object | `{}` |  |
| `resources.limits.cpu` | string | `"100m"` |  |
| `resources.limits.memory` | string | `"128Mi"` |  |
| `resources.requests.cpu` | string | `"100m"` |  |
| `resources.requests.memory` | string | `"128Mi"` |  |
| `nodeSelector` | object | `{}` |  |
| `tolerations` | list | `[]` |  |
| `affinity` | object | `{}` |  |
