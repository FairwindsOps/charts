# goldilocks

A chart for [goldilocks](https://github.com/FairwindsOps/goldilocks)

## Requirements

This has a hard requirement on VPA being installed. Please see the [Goldilocks README](https://github.com/fairwindsops/goldilocks)

## Usage

| Parameter | Description | Default | Required |
| --------- | ----------- | ------- | -------- |
| `installVPA` | Whether or not to install the VPA controller from the vpa repository | false | no |
| `controller.affinity` |  | `{}` | |
| `controller.enabled` |  | `True` | |
| `controller.nodeSelector` |  | `{}` | |
| `controller.rbac.create` |  | `True` | |
| `controller.resources.limits.cpu` |  | `25m` | |
| `controller.resources.limits.memory` |  | `32Mi` | |
| `controller.resources.requests.cpu` |  | `25m` | |
| `controller.resources.requests.memory` |  | `32Mi` | |
| `controller.serviceAccount.create` |  | `True` | |
| `controller.tolerations` |  | `[]` | |
| `dashboard.affinity` |  | `{}` | |
| `dashboard.enabled` |  | `True` | |
| `dashboard.excludeContainer` |  | `linkderd-proxy,istio-proxy` | |
| `dashboard.ingress.annotations` |  | `{}` | |
| `dashboard.ingress.enabled` |  | `False` | |
| `dashboard.ingress.hosts.0.host` |  | `chart-example.local` | |
| `dashboard.ingress.hosts.0.paths` |  | `[]` | |
| `dashboard.ingress.tls` |  | `[]` | |
| `dashboard.logVerbosity` |  | `2` | |
| `dashboard.nodeSelector` |  | `{}` | |
| `dashboard.rbac.create` |  | `True` | |
| `dashboard.replicaCount` |  | `2` | |
| `dashboard.resources.limits.cpu` |  | `25m` | |
| `dashboard.resources.limits.memory` |  | `32Mi` | |
| `dashboard.resources.requests.cpu` |  | `25m` | |
| `dashboard.resources.requests.memory` |  | `32Mi` | |
| `dashboard.service.port` |  | `80` | |
| `dashboard.service.type` |  | `ClusterIP` | |
| `dashboard.serviceAccount.create` |  | `True` | |
| `dashboard.tolerations` |  | `[]` | |
| `fullnameOverride` |  | `` | |
| `image.pullPolicy` |  | `Always` | |
| `image.repository` |  | `quay.io/fairwinds/goldilocks` | |
| `image.tag` |  | `v1.2.2` | |
| `nameOverride` |  | `` | |
