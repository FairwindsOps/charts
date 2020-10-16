# ClamAV

A Helm chart to install ClamAV on a cluster. This chart will run a single deployment
as the clamd server with a configurable number of replicas. Then, a daemonset that
mounts the host file system scans using clamdscan and the remote server.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| imagePullSecrets | list | `[]` | A list of image pull secrets to use in both the server and scanner |
| nameOverride | string | `""` |  |
| fullnameOverride | string | `""` |  |
| server.replicaCount | int | `2` | The number of replicas to run in the server deployment |
| server.image.repository | string | `"quay.io/fairwinds/clamav"` | The image repository to use for the server deployment. Version will be the application version in Chart.yaml |
| server.image.pullPolicy | string | `"Always"` | The imagePullPolicy for the server image |
| server.serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| server.serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| server.serviceAccount.name | string | `nil` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| server.podSecurityContext | object | `{}` |  |
| server.securityContext | object | `{}` |  |
| server.service.type | string | `"ClusterIP"` | The type of service to run for the deployment |
| server.service.port | int | `3310` | The port number to expose the service on |
| server.resources | object | `{"limits":{"cpu":"1000m","memory":"2Gi"},"requests":{"cpu":"1000m","memory":"2Gi"}}` | The resources block for the server deployment pods |
| server.nodeSelector | object | `{}` | A nodeSelector block for the server pods. |
| server.tolerations | list | `[]` |  |
| server.affinity | object | `{}` |  |
| scanner.tolerations | list | `[{"effect":"NoSchedule","key":"node-role.kubernetes.io/master"}]` | A list of tolerations for the scanner daemonset pods. |
| scanner.resources | object | `{"limits":{"cpu":"100m","memory":"50Mi"},"requests":{"cpu":"100m","memory":"50Mi"}}` | The resources block for the scanner daemonset pods |
| scanner.image.repository | string | `"quay.io/fairwinds/clamav"` |  |
| scanner.image.pullPolicy | string | `"Always"` |  |
| scanner.serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| scanner.serviceAccount.annotations | object | `{}` | Annotations to add to the service account if it is created |
| scanner.serviceAccount.name | string | `nil` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
