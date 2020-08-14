# ClamAV

A Helm chart to install ClamAV on a cluster. This chart will run a single deployment
as the clamd server with a configurable number of replicas. Then, a daemonset that
mounts the host file system scans using clamdscan and the remote server.


## Chart Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| fullnameOverride | string | `""` |  |
| imagePullSecrets | list | `[]` | A list of image pull secrets to use in both the server and scanner |
| nameOverride | string | `""` |  |
| scanner.image.pullPolicy | string | `"Always"` |  |
| scanner.image.repository | string | `"quay.io/fairwinds/clamav"` |  |
| scanner.resources | object | `{"limits":{"cpu":"100m","memory":"50Mi"},"requests":{"cpu":"100m","memory":"50Mi"}}` | The resources block for the scanner daemonset pods |
| scanner.serviceAccount.annotations | object | `{}` | Annotations to add to the service account if it is created |
| scanner.serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| scanner.serviceAccount.name | string | `nil` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| scanner.tolerations | list | `[{"effect":"NoSchedule","key":"node-role.kubernetes.io/master"}]` | A list of tolerations for the scanner daemonset pods. |
| server.affinity | object | `{}` |  |
| server.image.pullPolicy | string | `"Always"` | The imagePullPolicy for the server image |
| server.image.repository | string | `"quay.io/fairwinds/clamav"` | The image repository to use for the server deployment. Version will be the application version in Chart.yaml |
| server.nodeSelector | object | `{}` | A nodeSelector block for the server pods. |
| server.podSecurityContext | object | `{}` |  |
| server.replicaCount | int | `2` | The number of replicas to run in the server deployment |
| server.resources | object | `{"limits":{"cpu":"1000m","memory":"2Gi"},"requests":{"cpu":"1000m","memory":"2Gi"}}` | The resources block for the server deployment pods |
| server.securityContext | object | `{}` |  |
| server.service.port | int | `3310` | The port number to expose the service on |
| server.service.type | string | `"ClusterIP"` | The type of service to run for the deployment |
| server.serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| server.serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| server.serviceAccount.name | string | `nil` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| server.tolerations | list | `[]` |  |
