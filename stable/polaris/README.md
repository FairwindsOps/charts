# Polaris

[Polaris](https://github.com/reactiveops/polaris)
is a tool for auditing and enforcing best practices in Kubernetes.

## Installation
We recommend installing polaris in its own namespace.

### Dashboard
```
helm repo add reactiveops-stable https://charts.reactiveops.com/stable
helm install reactiveops-stable/polaris --name polaris --namespace polaris
```

### Webhook
```
helm repo add reactiveops-stable https://charts.reactiveops.com/stable
helm install reactiveops-stable/polaris --name polaris --namespace polaris --set webhook.enable=true --set dashboard.enable=false
```


## Configuration
Parameter | Description | Default
--------- | ----------- | -------
`config`  | The [polaris configuration](https://github.com/reactiveops/polaris#configuration) | see values.yaml
`dashboard.enable` | Whether to run the dashboard | true
`dashboard.replicas` | Number of replicas | 1
`dashboard.service.type` | Service type | ClusterIP
`dashboard.image.repository` | Image repo | quay.io/reactiveops/polaris
`dashboard.image.tag` | Image tag | 0.1.5
`dashboard.image.pullPolicy` | Image pull policy | Always
`webhook.enable` | Whether to run the dashboard | true
`webhook.replicas` | Number of replicas | 1
`webhook.service.type` | Service type | ClusterIP
`webhook.image.repository` | Image repo | quay.io/reactiveops/polaris
`webhook.image.tag` | Image tag | 0.1.5
`webhook.image.pullPolicy` | Image pull policy | Always
`rbac.create` | Whether to create RBAC | true
`templateOnly` | | false
