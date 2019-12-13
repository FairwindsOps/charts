# Fairwinds Custom Metrics

A controller for a collection of non-standard metrics.

## Usage

| Parameter | Description | Default | Required |
| --------- | ----------- | ------- | -------- |
| `controller.affinity` |  | `{}` | |
| `controller.datadogAnnotations.enabled` |  | `True` | |
| `controller.enabled` |  | `True` | |
| `controller.logVerbosity` |  | `2` | |
| `controller.nodeSelector` |  | `{}` | |
| `controller.rbac.create` |  | `True` | |
| `controller.resources.limits.cpu` |  | `25m` | |
| `controller.resources.limits.memory` |  | `32Mi` | |
| `controller.resources.requests.cpu` |  | `25m` | |
| `controller.resources.requests.memory` |  | `32Mi` | |
| `controller.service.enabled` |  | `True` | |
| `controller.service.port` |  | `10042` | |
| `controller.service.type` |  | `ClusterIP` | |
| `controller.serviceAccount.create` |  | `True` | |
| `controller.tolerations` |  | `[]` | |
| `fullnameOverride` |  | `` | |
| `image.pullPolicy` |  | `Always` | |
| `image.repository` |  | `quay.io/fairwinds/custom-metrics` | |
| `image.tag` |  | `master` | |
| `nameOverride` |  | `` | |
| `listener.enabled` | When set to true, enables a listener you can post datadog webhooks to. | `false` | |
| `listener.port` | port for the webhook listener to run on. | `2113` | |
| `listener.username` | listener username | `` | |
| `listener.password` | listener password | `` | |
| `listener.maxJobAge` | max age in minutes before an old job gets removed | `` | |
| `listener.ingress.enabled ` | when enabled, creates an ingress object for the listener | `false` | |
| `listener.ingress.annotations` | | `{}` | |
| `listener.ingress.hosts` | listener ingress hosts | | |
| `listener.ingress.tls` | listener ingress tls config | | |
| `listener.service.type` | | `ClusterIP` | | |
| `listener.service.port` | | | | |
