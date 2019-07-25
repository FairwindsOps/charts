# Basic Kubernetes Demo

Runs a frontend that shows which pods it is connecting to.  Good for scaling demos.

Credit for the app goes to [ehazlett](https://github.com/ehazlett/docker-demo)

## Values

| Parameter | Description | Default | Required |
| --------- | ----------- | ------- | -------- |
| `affinity` | Pod Affinity  | `{}` | no |
| `demo.metadata` | Flavor text on demo app page  | `ehazlett/docker-demo - Chart by Fairwinds` | |
| `demo.refreshInterval` | How often the demo frontend should refresh (ms)  | `500` | yes |
| `demo.title` | Title on the demo app page | `Kuberneteseckoner Demo` | no |
| `hpa.max` | Maximum replicas  | `20` | yes |
| `hpa.min` | Minimum replicas  | `3` | yes |
| `hpa.cpuTarget` | CPU scaling target if not using custom metrics | `60` | no |
| `hpa.customMetric.enabled` | Enable scaling on custom metrics | `false` | no |
| `hpa.customMetric.metric` | Custom metric to scale on | `cpu` | yes |
| `hpa.customMetric.target` | HPA custom metric target  | `30m` | yes |
| `image.pullPolicy` | Pull Policy  | `Always` | yes |
| `image.repository` | Image Repository  | `ehazlett/docker-demo` | yes |
| `image.tag` | Image Tag  | `latest` | yes |
| `ingress.annotations` | Annotations on Ingress  | `{}` | no |
| `ingress.enabled` | Whether or not to enable the ingress  | `False` | no |
| `ingress.hosts` | Hostnames of ingress  | `chart-example.local` | no |
| `ingress.paths` | Ingress Paths  | `[]` | no |
| `ingress.tls` | Ingress TLS Block  | `[]` | no |
| `nodeSelector` |  | `{}` | no |
| `resources.limits.cpu` |  | `100m` | yes |
| `resources.limits.memory` |  | `128Mi` | yes |
| `resources.requests.cpu` |  | `100m` | yes |
| `resources.requests.memory` |  | `128Mi` | yes |
| `service.port` |  | `80` | no |
| `service.type` |  | `ClusterIP` | yes |
| `tolerations` |  | `[]` | no |
| `linkerd.serviceProfile` | Install a linkerd2 serviceprofile with the app | `false` | no |
