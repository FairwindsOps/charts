# Fluentd

Deploys fluentd daemonset with defaults for various backends.

## Backend images

Switching backends requires using a matching image as well as some backend-specific options.

### Elasticsearch

| Parameter | Default |
| --------- | ------- |
| `image.repository` | `fluent/fluentd-kubernetes-daemonset` |
| `image.tag` | `v1.3.3-debian-elasticsearch-1.5` |
| `elasticsearch.enabled` |  `true` |
| `elasticsearch.host` | `instance-name.region.es.amazonaws.com` |
| `elasticsearch.port` | `443` |
| `elasticsearch.scheme` | `https` |
| `elasticsearch.customConf` | `""` |


### Papertrail

| Parameter | Default |
| --------- | ------- |
| `image.repository` | `fluent/fluentd-kubernetes-daemonset` |
| `image.tag` | `v0.12.33-papertrail` |
| `papertrail.enabled` | `true` |
| `papertrail.host` | `logs3.papertrailapp.com` |
| `papertrail.port` | `12785` |
| `papertrail.cluster_name` | `something` |
| `papertrail.extraArgs` | Empty string |

### Loggly

| Parameter | Default |
| --------- | ------- |
| `image.repository` | `garland/kubernetes-fluentd-loggly` |
| `image.tag` | `1.0` |
| `loggly.enabled` | `true` |
| `loggly.logglyUrl` | `U29tZSBsb2dnbHkgdXJsIGJhc2U2NCBlbmNvZGVkIGhlcmU=` (Base64 encoded loggly URL) |

## Other Values

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `verify_ssl` | Enable/disable TLS validation of Kubernetes API | `true` |
| `image.pullPolicy` | Pull policy | `Always` |
| `resources` | Resource requests/limits | `{limits: {cpu: 100m, memory: 500Mi}, requests: {cpu: 100m, memory: 200Mi}` |
| `rbac.create` | Create RBAC resources | `true` |
| `serviceAccount.create` | Create a service account | `true` |
| `serviceAccount.name` | Create a service account | `${fluentd.fullname}` |
| `annotations` | Misc annotations | `{}` |
| `tolerations` | Misc tolerations | `[{key: node-role.kubernetes.io/master, operator: Exists, effect: NoSchedule}]` |
| `log_level` | Log level | `error` |
| `updateStrategy` | DaemonSet updateStrategy | `{type: RollingUpdate, rollingUpdate: {maxUnavailable: 10}}` |
