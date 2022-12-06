# Basic Kubernetes Demo

Runs a frontend that shows which pods it is connecting to.  Good for scaling demos.

Credit for the app goes to [ehazlett](https://github.com/ehazlett/docker-demo)

## A Note on Chart Version 0.3.0+

Due to the [future deprecation](https://kubernetes.io/blog/2019/07/18/api-deprecations-in-1-16/) of various `extensions/v1beta1` API's, the 0.3.0 version of this chart will only work on kubernetes 1.14.0+

## Values

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| demo.refreshInterval | int | `500` |  |
| demo.title | string | `"Kubernetes Demo"` |  |
| demo.metadata | string | `""` |  |
| hpa.enabled | bool | `true` |  |
| hpa.min | int | `3` |  |
| hpa.max | int | `20` |  |
| hpa.cpuTarget | int | `60` |  |
| hpa.customMetric.enabled | bool | `false` |  |
| hpa.customMetric.metric | string | `"somecustommetricname"` |  |
| hpa.customMetric.target | int | `30` |  |
| vpa.enabled | bool | `false` |  |
| vpa.updateMode | string | `"Off"` |  |
| pdb.enabled | bool | `true` |  |
| pdb.maxUnavailable | int | `1` |  |
| image.repository | string | `"quay.io/fairwinds/docker-demo"` |  |
| image.tag | string | `"latest"` |  |
| image.pullPolicy | string | `"Always"` |  |
| nameOverride | string | `""` |  |
| fullnameOverride | string | `""` |  |
| service.type | string | `"ClusterIP"` |  |
| service.port | int | `80` |  |
| ingress.enabled | bool | `false` |  |
| ingress.ingressClassName | string | `""` |  |
| ingress.annotations | object | `{}` |  |
| ingress.paths | list | `[]` |  |
| ingress.hosts[0] | string | `"chart-example.local"` |  |
| ingress.tls | list | `[]` |  |
| resources.limits.cpu | string | `"70m"` |  |
| resources.limits.memory | string | `"131072k"` |  |
| resources.requests.cpu | string | `"10m"` |  |
| resources.requests.memory | string | `"131072k"` |  |
| nodeSelector | object | `{}` |  |
| tolerations | list | `[]` |  |
| affinity | object | `{}` |  |
| linkerd.serviceProfile | bool | `false` |  |
| linkerd.enableRetry | bool | `true` |  |
