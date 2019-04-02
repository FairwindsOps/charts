# Fluentd

Deploys fluentd daemonset with defaults for various backends.

## Backend images

Switching backends requires using a matching image as well as some backend-specific options.

### Elasticsearch

| Parameter | Default |
| --------- | ------- |
| `image.repository` | `fluent/fluentd-kubernetes-daemonset` |
| `image.tag` | `v0.12.43-debian-elasticsearch` |
| `elasticsearch.enabled` |  `true` |
| `elasticsearch.host` | `instance-name.region.es.amazonaws.com` |
| `elasticsearch.port` | `443` |
| `elasticsearch.scheme` | `https` |
| `papertrail.extraArgs` | [] |


### Papertrail

| Parameter | Default |
| --------- | ------- |
| `image.repository` | `fluent/fluentd-kubernetes-daemonset` |
| `image.tag` | `v0.12.43-debian-papertrail` |
| `papertrail.enabled` | `true` |
| `papertrail.host` | `logs3.papertrailapp.com` |
| `papertrail.port` | `12785` |
| `papertrail.cluster_name` | `something` |
| `papertrail.extraArgs` | [] |

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
| `additional_filters_and_sources` | Custom additional fluentd configuration | `""` |
| `updateStrategy` | DaemonSet updateStrategy | `{type: RollingUpdate, rollingUpdate: {maxUnavailable: 10}}` |
