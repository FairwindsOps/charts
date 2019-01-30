# Fluentd

Deploys fluentd daemonset with defaults for various backends.

## Backend images

Switching backends requires using a matching image.

### Elasticsearch

| `es.enabled` |  `true` |
| `image.repository` | `quay.io/reactiveops/fluentd-kubernetes-aws-es` |
| `image.tag` | `latest` |

### Papertrail

| `image.repository` | `fluent/fluentd-kubernetes-daemonset` |
| `image.tag` | `v0.12.33-papertrail` |
| `papertrail.enabled` | `true` |
| `papertrail.host` | `logs3.papertrailapp.com` |
| `papertrail.port` | `12785` |
| `papertrail.cluster_name` | `something` |
| `papertrail.verify_ssl` | `true` |

### Loggly

| `image.repository` | `garland/kubernetes-fluentd-loggly` |
| `image.tag` | `1.0` |
| `loggly.enabled` | `true` |
| `loggly.logglyUrl` | `U29tZSBsb2dnbHkgdXJsIGJhc2U2NCBlbmNvZGVkIGhlcmU=` (Base64 encoded loggly URL) |

## Other Values

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `image.pullPolicy` | Pull policy | `Always` |
| `resources` | Resource requests/limits | `{limits: {cpu: 100m, memory: 500Mi}, requests: {cpu: 100m, memory: 200Mi}` |
| `rbac.create` | Create RBAC resources | `true` |
| `serviceAccount.create` | Create a service account | `true` |
| `serviceAccount.name` | Create a service account | `${fluentd.fullname}` |
| `annotations` | Misc annotations | `{}` |
| `tolerations` | Misc tolerations | `[{key: node-role.kubernetes.io/master, operator: Exists, effect: NoSchedule}]` |
| `log_level` | Log level | `error` |
