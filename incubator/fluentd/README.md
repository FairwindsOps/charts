# Fluentd

Deploys fluentd daemonset with defaults for various backends. Note that you need to specifically choose to enable Elasticsearch or Papertrail plugins via `elasticsearch.enabled` or `papertrail.enabled`. See options below for details.

## Backend images

Switching backends requires using a matching image as well as some backend-specific options.

### Elasticsearch

| Parameter | Default |
| --------- | ------- |
| `image.repository` | `fluent/fluentd-kubernetes-daemonset` |
| `image.tag` | `v1.4.2-debian-elasticsearch-1.1` |
| `elasticsearch.enabled` |  `false` |
| `elasticsearch.host` | `instance-name.region.es.amazonaws.com` |
| `elasticsearch.port` | `443` |
| `elasticsearch.scheme` | `https` |
| `elasticsearch.chunk_limit_size` | `5m` |
| `elasticsearch.chunk_limit_records` | `100` |
| `elasticsearch.overflow_action` | `throw_exception` |
| `elasticsearch.retry_timeout` | `20s` |
| `elasticsearch.flush_interval` | `5s` |
| `elasticsearch.flush_thread_count` | `4` |


### Papertrail

| Parameter | Default |
| --------- | ------- |
| `image.repository` | `fluent/fluentd-kubernetes-daemonset` |
| `image.tag` | `v1.4.2-debian-papertrail-1.1` |
| `papertrail.enabled` | `false` |
| `papertrail.host` | `logs3.papertrailapp.com` |
| `papertrail.port` | `12785` |
| `papertrail.flush_thread_count` | `4` |

## Other Values

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `cluster_name` | **Required** Name of the kubernetes_cluster | `""` |
| `verify_ssl` | Enable/disable TLS validation of Kubernetes API | `true` |
| `image.pullPolicy` | Pull policy | `Always` |
| `resources` | Resource requests/limits | `{limits: {cpu: 100m, memory: 500Mi}, requests: {cpu: 100m, memory: 500Mi}` |
| `rbac.create` | Create RBAC resources | `true` |
| `serviceAccount.create` | Create a service account | `true` |
| `serviceAccount.name` | Create a service account | `${fluentd.fullname}` |
| `annotations` | Misc annotations | `{}` |
| `tolerations` | Misc tolerations | `[{key: node-role.kubernetes.io/master, operator: Exists, effect: NoSchedule}]` |
| `log_level` | Log level | `error` |
| `additional_filters_and_sources` | Custom additional fluentd configuration | `""` |
| `updateStrategy` | DaemonSet updateStrategy | `{type: RollingUpdate, rollingUpdate: {maxUnavailable: 10}}` |
| `pluginExtraArgs` | [] | Extra arguments to be added to the container|