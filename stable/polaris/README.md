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

A valid TLS certificate is required for the Polaris Validating Webhook. If you have cert-manager installed in your cluster then the helm install below will work.

If you don't use cert-manager, you'll need to:
* Supply a CA Bundle with the `webhook.caBundle`
* Create a TLS secret in your cluster with a valid certificate that uses that CA
* Pass the name of that secret with the `webhook.secretName` parameter.

```
helm repo add fairwinds-stable https://charts.fairwinds.com/stable
helm install polaris fairwinds-stable/polaris --namespace polaris --set webhook.enable=true --set dashboard.enable=false
```

## A Note on Chart Version 0.10.0+

Due to the [deprecation](https://kubernetes.io/blog/2019/07/18/api-deprecations-in-1-16/) of various `extensions/v1beta1` API's,
the 0.10.0 version of this chart will only work on kubernetes 1.14.0+

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| config | string | `nil` | The (polaris configuration)[https://github.com/FairwindsOps/polaris#configuration]. If not provided then the (default)[https://github.com/FairwindsOps/polaris/blob/master/examples/config.yaml] config from Polaris is used. |
| image.repository | string | `"quay.io/fairwinds/polaris"` | Image repo |
| image.tag | string | `""` | The Polaris Image tag to use. Defaults to the Chart's AppVersion |
| image.pullPolicy | string | `"Always"` | Image pull policy |
| image.pullSecrets | list | `[]` | Image pull secrets |
| rbac.enabled | bool | `true` | Whether RBAC resources (ClusterRole, ClusterRolebinding) should be created |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `nil` | The name of the service account to use. |
| templateOnly | bool | `false` | Outputs Namespace names, used with `helm template` |
| dashboard.basePath | string | `nil` | Path on which the dashboard is served. Defaults to `/` |
| dashboard.enable | bool | `true` | Whether to run the dashboard. |
| dashboard.port | int | `8080` | Port that the dashboard will run from. |
| dashboard.listeningAddress | string | `nil` | Dashboard listerning address. |
| dashboard.replicas | int | `1` | Number of replicas to run. |
| dashboard.resources | object | `{"limits":{"cpu":"150m","memory":"512Mi"},"requests":{"cpu":"100m","memory":"128Mi"}}` | Requests and limits for the dashboard |
| dashboard.service.type | string | `"ClusterIP"` | Service Type |
| dashboard.service.annotations | object | `{}` | Service annotations |
| dashboard.nodeSelector | object | `{}` | Dashboard pod nodeSelector |
| dashboard.tolerations | list | `[]` | Dashboard pod tolerations |
| dashboard.affinity | object | `{}` | Dashboard pods affinity |
| dashboard.ingress.enabled | bool | `false` | Whether to enable ingress to the dashboard |
| dashboard.ingress.hosts | list | `[]` | Web ingress hostnames |
| dashboard.ingress.annotations | object | `{}` | Web ingress annotations |
| dashboard.ingress.tls | list | `[]` | Ingress TLS configuration |
| dashboard.priorityClassName | string | `nil` | Priority Class name to be used in deployment if provided. |
| webhook.enable | bool | `false` | Whether to run the Validating Webhook |
| webhook.replicas | int | `1` | Number of replicas |
| webhook.nodeSelector | object | `{}` | Webhook pod nodeSelector |
| webhook.tolerations | list | `[]` | Webhook pod tolerations |
| webhook.affinity | object | `{}` | Webhook pods affinity |
| webhook.caBundle | string | `nil` | CA Bundle to use for Validating Webhook instead of cert-manager |
| webhook.secretName | string | `nil` | Name of the secret containing a TLS certificate to use if cert-manager is not used. |
| webhook.failurePolicy | string | `"Fail"` | failurePolicy for the ValidatingWebhookConfiguration |
| webhook.matchPolicy | string | `"Exact"` | matchPolicy for the ValidatingWebhookConfiguration |
| webhook.namespaceSelector | object | `{"matchExpressions":[{"key":"control-plane","operator":"DoesNotExist"}]}` | namespaceSelector for the ValidatingWebhookConfiguration |
| webhook.objectSelector | object | `{}` | objectSelector for the ValidatingWebhookConfiguration |
| webhook.rules | list | `[]` | An array of additional for the ValidatingWebhookConfiguration. Each requires a set of apiGroups, apiVersions, operations, resources, and a scope. |
| webhook.defaultRules | list | `[{"apiGroups":["apps"],"apiVersions":["v1","v1beta1","v1beta2"],"operations":["CREATE","UPDATE"],"resources":["daemonsets","deployments","statefulsets"],"scope":"Namespaced"},{"apiGroups":["batch"],"apiVersions":["v1","v1beta1"],"operations":["CREATE","UPDATE"],"resources":["jobs","cronjobs"],"scope":"Namespaced"},{"apiGroups":[""],"apiVersions":["v1"],"operations":["CREATE","UPDATE"],"resources":["pods","replicationcontrollers"],"scope":"Namespaced"}]` | An array of rules for common types for the ValidatingWebhookConfiguration |
| webhook.resources | object | `{"limits":{"cpu":"100m","memory":"128Mi"},"requests":{"cpu":"100m","memory":"128Mi"}}` | Requests and limits for the webhook. |
| webhook.priorityClassName | string | `nil` | Priority Class name to be used in deployment if provided. |
| audit.enable | bool | `false` | Runs a one-time audit. This is used internally at Fairwinds, and may not be useful for others. |
| audit.cleanup | bool | `false` | Whether to delete the namespace once the audit is finished. |
| audit.outputURL | string | `""` | A URL which will receive a POST request with audit results. |
