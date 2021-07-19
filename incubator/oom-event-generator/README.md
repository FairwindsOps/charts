# Kubernetes OOM Event Generator
A chart for https://github.com/xing/kubernetes-oom-event-generator

# Values

| Parameter | Description | Default | Required |
| --------- | ----------- | ------- | -------- |
| `affinity` | Pod Affinity  | `{}` | no |
| `env` | Environment Variables for container | `{}` | no |
| `image.pullPolicy` | Pull Policy  | `Always` | yes |
| `image.repository` | Image Repository  | `xingse/kubernetes-oom-event-generator` | yes |
| `image.tag` | Image Tag  | `v1.2.0` | yes |
| `nodeSelector` |  | `{}` | no |
| `replicaCount` | Number of replicas | `1` | no |
| `resources.limits.cpu` |  | `100m` | yes |
| `resources.limits.memory` |  | `128Mi` | yes |
| `resources.requests.cpu` |  | `100m` | yes |
| `resources.requests.memory` |  | `128Mi` | yes |
| `tolerations` |  | `[]` | no |
