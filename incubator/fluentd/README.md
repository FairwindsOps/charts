# Chart - fluentd

This chart configured Fluentd with support for multiple endpoints including:

* Elasticsearch
* Loggly
* Papertrail

## Configuration

The following table lists the configurable parameters of the chart and their default values.

| Parameter | Description | Default | Required |
| --------- | ----------- | ------- | -------- |
| `es.enabled` | Enable Elasticsearch endpoint | `True` | yes |
| `image.pullPolicy` | Image pull policy | `Always` | no |
| `image.repository` | Image repository | `quay.io/reactiveops/fluentd-kubernetes-aws-es` | no |
| `image.tag` | Image tag | `latest` | no |
| `log_level` | Fluentd log level setting | `error` | no |
| `loggly.enabled` | Enable Loggly endpoint | `False` | no |
| `loggly.logglyUrl` | Loggly URL, base64 encoded | `U29tZSBsb2dnbHkgdXJsIGJhc2U2NCBlbmNvZGVkIGhlcmU=` | yes |
| `papertrail.cluster_name` | Cluster name for Papertrail | `None` | no |
| `papertrail.enabled` | Enable Papertrail endpoint | `False` | no |
| `papertrail.host` | Papertrail host url | `logs3.papertrailapp.com` | no |
| `papertrail.port` | Papertrail port | `12785` | no |
| `papertrail.verify_ssl` | Papertrail verify ssl setting | `True` | no |
| `rbac.create` | Create rbac ClusterRole and RoleBinding | `True` | no |
| `resources.limits.cpu` | Resource limits: CPU | `100m` | no |
| `resources.limits.memory` | Resource limits: memory | `500Mi` | no |
| `resources.requests.cpu` | Resource requests: CPU | `100m` | no |
| `resources.requests.memory` | Resource requests: memory | `200Mi` | no |
| `serviceAccount.create` | Create service account | `True` | no |
| `serviceAccount.name` |Service account name | `None` | no |
| `tolerations` | Daemonset tolerations | `[{ key: node-role.kubernetes.io/master, operator: Exists, effect: NoSchedule }]` | no |
