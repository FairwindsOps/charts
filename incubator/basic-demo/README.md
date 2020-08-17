# Basic Kubernetes Demo

Runs a frontend that shows which pods it is connecting to.  Good for scaling demos.

Credit for the app goes to [ehazlett](https://github.com/ehazlett/docker-demo)

## A Note on Chart Version 0.3.0+

Due to the [future deprecation](https://kubernetes.io/blog/2019/07/18/api-deprecations-in-1-16/) of various `extensions/v1beta1` API's, the 0.3.0 version of this chart will only work on kubernetes 1.14.0+

## Values

| Parameter | Description | Default | Required |
| --------- | ----------- | ------- | -------- |
| `affinity` | Pod Affinity  | `{}` | no |
| `demo.metadata` | Flavor text on demo app page  | `ehazlett/docker-demo - Chart by ReactiveOps` | |
| `demo.refreshInterval` | How often the demo frontend should refresh (ms)  | `500` | yes |
| `demo.title` | Title on the demo app page | `Kuberneteseckoner Demo` | no |
| `hpa.max` | Maximum replicas  | `20` | yes |
| `hpa.min` | Minimum replicas  | `3` | yes |
| `hpa.cpuTarget` | CPU scaling target if not using custom metrics | `60` | no |
| `hpa.customMetric.enabled` | Enable scaling on custom metrics | `false` | no |
| `hpa.customMetric.metric` | Custom metric to scale on | `cpu` | yes |
| `hpa.customMetric.target` | HPA custom metric target  | `30m` | yes |
| `image.pullPolicy` | Pull Policy  | `Always` | yes |
| `image.repository` | Image Repository  | `quay.io/fairwinds/docker-demo` | yes |
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
