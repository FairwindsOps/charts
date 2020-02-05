# Polaris

[Polaris](https://github.com/FairwindsOps/polaris)
is a tool for auditing and enforcing best practices in Kubernetes.

## Installation
We recommend installing polaris in its own namespace.

### Dashboard
```
helm repo add fairwinds-stable https://charts.fairwinds.com/stable
helm install fairwinds-stable/polaris --name polaris --namespace polaris
```

### Webhook
```
helm repo add fairwinds-stable https://charts.fairwinds.com/stable
helm install fairwinds-stable/polaris --name polaris --namespace polaris --set webhook.enable=true --set dashboard.enable=false
```

## A Note on Chart Version 0.10.0+

Due to the [future deprecation](https://kubernetes.io/blog/2019/07/18/api-deprecations-in-1-16/) of various `extensions/v1beta1` API's, the 0.10.0 version of this chart will only work on kubernetes 1.14.0+

## Configuration
Parameter | Description | Default
--------- | ----------- | -------
`config`  | The [polaris configuration](https://github.com/FairwindsOps/polaris#configuration) | see values.yaml
`dashboard.enable` | Whether to run the dashboard | true
`dashboard.replicas` | Number of replicas | 1
`dashboard.service.type` | Service type | ClusterIP
`dashboard.service.annotatotions` | Service annotations | {}
`dashboard.image.repository` | Image repo | quay.io/fairwinds/polaris
`dashboard.image.tag` | Image tag | 0.6
`dashboard.image.pullPolicy` | Image pull policy | Always
`dashboard.image.imagePullSecrets` | Image pull secrets | []
`dashboard.nodeSelector` | Dashboard pod nodeSelector | {}
`dashboard.tolerations` | Dashboard pod tolerations | []
`webhook.enable` | Whether to run the dashboard | false
`webhook.replicas` | Number of replicas | 1
`webhook.service.type` | Service type | ClusterIP
`webhook.image.repository` | Image repo | quay.io/fairwinds/polaris
`webhook.image.tag` | Image tag | 0.6
`webhook.image.pullPolicy` | Image pull policy | Always
`webhook.image.imagePullSecrets` | Image pull secrets | []
`webhook.nodeSelector` | Webhook pod nodeSelector | {}
`webhook.tolerations` | Webhook pod tolerations | []
`audit.enable` | Runs a one-time audit. This is used internally at Fairwinds, and may not be useful for others | false
`audit.outputURL` | A URL which will receive a POST request with audit results | ""
`audit.cleanup` | Whether to delete the namespace once the audit is finished | false
`audit.image.repository` | Image repo | quay.io/fairwinds/polaris
`audit.image.tag` | Image tag | 0.6
`audit.image.pullPolicy` | Image pull policy | Always
`audit.image.imagePullSecrets` | Image pull secrets | []
`rbac.create` | Whether to create RBAC | true
`templateOnly` | | false
`ingress.enabled` | Whether to enable ingress to the dashboard | false
`ingress.hosts` | Web ingress hostnames | []
`ingress.tls` | ingress tls configuration |
`ingress.annotations` | Web ingress annotations | {}
