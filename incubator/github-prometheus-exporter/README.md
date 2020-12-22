# Github Prometheus Exporter

A chart for https://github.com/infinityworks/github-exporter

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| replicaCount | int | `1` |  |
| config.githubToken | string | `""` | A github token to be kept in environment |
| config.repos | string | `""` | Env REPOS. If supplied, The repos you wish to monitor, expected in the format "user/repo1, user/repo2". Can be across different Github users/orgs. |
| config.users | string | `""` | Env USERS. If supplied, the exporter will enumerate all repositories for that users. Expected in the format "user1, user2" |
| config.orgs | string | `""` | Env ORGS. If supplied, the exporter will enumerate all repositories for that organization. Expected in the format "org1, org2". |
| config.apiURL | string | `"https://api.github.com"` | Github API URL, shouldn't need to change this. |
| config.logLevel | string | `"debug"` | The level of logging the exporter will run with |
| image.repository | string | `"infinityworks/github-exporter"` | Where to find the docker image |
| image.pullPolicy | string | `"Always"` | The image pull policy. Strongly recommend not changing this |
| image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion |
| imagePullSecrets | list | `[]` |  |
| nameOverride | string | `""` |  |
| fullnameOverride | string | `""` |  |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| podAnnotations | object | `{}` | A map of annotations to add to the pod |
| podSecurityContext | object | `{}` | A pod security context to add |
| securityContext | object | `{}` |  |
| service.type | string | `"ClusterIP"` | The type of service to expose |
| service.port | int | `9171` | The port that the service will listen on |
| ingress.enabled | bool | `false` |  |
| ingress.annotations | object | `{}` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths | list | `[]` |  |
| ingress.tls | list | `[]` |  |
| resources | object | `{}` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| nodeSelector | object | `{}` |  |
| tolerations | list | `[]` |  |
| affinity | object | `{}` |  |
