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
