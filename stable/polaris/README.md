# Polaris

[Polaris](https://github.com/FairwindsOps/polaris)
is a tool for auditing and enforcing best practices in Kubernetes.

## Installation
We recommend installing polaris in its own namespace.

### Dashboard
```
helm repo add fairwinds-stable https://charts.fairwinds.com/stable
helm install polaris fairwinds-stable/polaris --namespace polaris
```

### Webhook
```
helm repo add fairwinds-stable https://charts.fairwinds.com/stable
helm install polaris fairwinds-stable/polaris --namespace polaris --set webhook.enable=true --set dashboard.enable=false
```

## A Note on Chart Version 0.10.0+

Due to the [deprecation](https://kubernetes.io/blog/2019/07/18/api-deprecations-in-1-16/) of various `extensions/v1beta1` API's,
the 0.10.0 version of this chart will only work on kubernetes 1.14.0+

## Configuration
Parameter | Description | Default
--------- | ----------- | -------
`config`  | The [polaris configuration](https://github.com/FairwindsOps/polaris#configuration) | [taken from Polaris](https://github.com/FairwindsOps/polaris/blob/master/examples/config.yaml)
`image.repository` | Image repo | quay.io/fairwinds/polaris
`image.tag` | Image tag | 1.2
`image.pullPolicy` | Image pull policy | Always
`image.pullSecrets` | Image pull secrets | []
`rbac.enabled` | Whether RBAC resources (ClusterRole, ClusterRolebinding) should be created | true
`serviceAccount.create` | Specifies whether a service account should be created | true
`serviceAccount.name` | The name of the service account to use | polaris.fullname
`templateOnly` | | false
`dashboard.basePath` | Path on which the dashboard is served. | /
`dashboard.enable` | Whether to run the dashboard | true
`dashboard.resources` | Requests and limits for the dashboard | (see values.yaml)
`dashboard.replicas` | Number of replicas | 1
`dashboard.service.type` | Service type | ClusterIP
`dashboard.service.annotatotions` | Service annotations | {}
`dashboard.nodeSelector` | Dashboard pod nodeSelector | {}
`dashboard.tolerations` | Dashboard pod tolerations | []
`dashboard.ingress.enabled` | Whether to enable ingress to the dashboard | false
`dashboard.ingress.hosts` | Web ingress hostnames | []
`dashboard.ingress.tls` | ingress tls configuration |
`dashboard.ingress.annotations` | Web ingress annotations | {}
`dashboard.priorityClassName` | Priority Class Name |
`webhook.enable` | Whether to run the dashboard | false
`webhook.resources` | Requests and limits for the webhook | (see values.yaml)
`webhook.replicas` | Number of replicas | 1
`webhook.service.type` | Service type | ClusterIP
`webhook.nodeSelector` | Webhook pod nodeSelector | {}
`webhook.tolerations` | Webhook pod tolerations | []
`webhook.priorityClassName` | Priority Class Name |
`audit.enable` | Runs a one-time audit. This is used internally at Fairwinds, and may not be useful for others | false
`audit.outputURL` | A URL which will receive a POST request with audit results | ""
`audit.cleanup` | Whether to delete the namespace once the audit is finished | false
