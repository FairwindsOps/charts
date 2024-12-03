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
| config | string | `nil` | The [polaris configuration](https://github.com/FairwindsOps/polaris#configuration). If not provided then the [default](https://github.com/FairwindsOps/polaris/blob/master/examples/config.yaml) config from Polaris is used. |
| configUrl | string | `nil` | Use a config from an accessible URL source.  NOTE: `config` & `configUrl` are mutually exclusive.  Setting `configURL` will take precedence over `config`.  Only one may be used. configUrl: https://example.com/config.yaml |
| additionalExemptions | string | `nil` | List of additional exemptions to append to the exemptions given in `config` |
| mergeConfig | bool | `false` | If the config should be merged with the default config. See https://github.com/FairwindsOps/polaris/pull/1075 |
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
| dashboard.replicas | int | `2` | Number of replicas to run. |
| dashboard.logLevel | string | `"Info"` | Set the logging level for the Dashboard command |
| dashboard.podAdditionalLabels | object | `{}` | Custom additional labels on dashboard pods. |
| dashboard.deploymentAnnotations | object | `{}` | Custom additional annotations on dashboard Deployment. |
| dashboard.resources | object | `{"limits":{},"requests":{"cpu":"100m","memory":"128Mi"}}` | Requests and limits for the dashboard |
| dashboard.extraContainers | list | `[]` | allows injecting additional containers. |
| dashboard.service.type | string | `"ClusterIP"` | Service Type |
| dashboard.service.annotations | object | `{}` | Service annotations |
| dashboard.service.targetPort | string | `nil` | Service targetport, defaults to dashboard.port |
| dashboard.service.loadBalancerSourceRanges | list | `[]` | List of allowed CIDR values |
| dashboard.nodeSelector | object | `{}` | Dashboard pod nodeSelector |
| dashboard.tolerations | list | `[]` | Dashboard pod tolerations |
| dashboard.affinity | object | `{}` | Dashboard pods affinity |
| dashboard.topologySpreadConstraints | list | `[{"labelSelector":{"matchLabels":{"component":"dashboard"}},"maxSkew":1,"topologyKey":"topology.kubernetes.io/zone","whenUnsatisfiable":"ScheduleAnyway"},{"labelSelector":{"matchLabels":{"component":"dashboard"}},"maxSkew":1,"topologyKey":"kubernetes.io/hostname","whenUnsatisfiable":"ScheduleAnyway"}]` | Dashboard pods topologySpreadConstraints |
| dashboard.ingress.enabled | bool | `false` | Whether to enable ingress to the dashboard |
| dashboard.ingress.ingressClassName | string | `nil` | From Kubernetes 1.18+ this field is supported in case your ingress controller supports it. When set, you do not need to add the ingress class as annotation. |
| dashboard.ingress.hosts | list | `[]` | Web ingress hostnames |
| dashboard.ingress.annotations | object | `{}` | Web ingress annotations |
| dashboard.ingress.tls | list | `[]` | Ingress TLS configuration |
| dashboard.ingress.defaultBackendEnabled | bool | `false` | DefaultBackend is required by GKE container native load balancer, set to true for this use case |
| dashboard.priorityClassName | string | `nil` | Priority Class name to be used in deployment if provided. |
| dashboard.disallowExemptions | bool | `false` | Disallow any exemption |
| dashboard.disallowConfigExemptions | bool | `false` | Disallow exemptions that are configured in the config file |
| dashboard.disallowAnnotationExemptions | bool | `false` | Disallow exemptions that are configured via annotations |
| dashboard.containerSecurityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"privileged":false,"readOnlyRootFilesystem":true,"runAsNonRoot":true}` | securityContext to apply to the dashboard container |
| dashboard.pdb.enable | bool | `true` | If true, enables a PDB for the dashboard |
| webhook.enable | bool | `false` | Whether to run the webhook |
| webhook.validate | bool | `true` | Enables the Validating Webhook, to reject resources with issues |
| webhook.mutate | bool | `false` | Enables the Mutating Webhook, to modify resources with issues |
| webhook.replicas | int | `2` | Number of replicas |
| webhook.logLevel | string | `"info"` | Set the logging level for the Webhook command |
| webhook.nodeSelector | object | `{}` | Webhook pod nodeSelector |
| webhook.tolerations | list | `[]` | Webhook pod tolerations |
| webhook.affinity | object | `{}` | Webhook pods affinity |
| webhook.topologySpreadConstraints | list | `[{"labelSelector":{"matchLabels":{"component":"webhook"}},"maxSkew":1,"topologyKey":"topology.kubernetes.io/zone","whenUnsatisfiable":"ScheduleAnyway"},{"labelSelector":{"matchLabels":{"component":"webhook"}},"maxSkew":1,"topologyKey":"kubernetes.io/hostname","whenUnsatisfiable":"ScheduleAnyway"}]` | Webhook pods topologySpreadConstraints |
| webhook.certManager.apiVersion | string | `""` | Allows overriding .Capabilities.APIVersions with a specified version. Useful for GitOps. |
| webhook.caBundle | string | `nil` | CA Bundle to use for Validating Webhook instead of cert-manager |
| webhook.secretName | string | `nil` | Name of the secret containing a TLS certificate to use if cert-manager is not used. |
| webhook.failurePolicy | string | `"Fail"` | failurePolicy for the ValidatingWebhookConfiguration |
| webhook.matchPolicy | string | `"Exact"` | matchPolicy for the ValidatingWebhookConfiguration |
| webhook.namespaceSelector | object | `{"matchExpressions":[{"key":"control-plane","operator":"DoesNotExist"}]}` | namespaceSelector for the ValidatingWebhookConfiguration |
| webhook.objectSelector | object | `{}` | objectSelector for the ValidatingWebhookConfiguration |
| webhook.rules | list | `[]` | An array of additional rules for the ValidatingWebhookConfiguration. Each requires a set of apiGroups, apiVersions, operations, resources, and a scope. |
| webhook.mutatingRules | list | `[]` | An array of additional rules for the MutatingWebhookConfiguration. Each requires a set of apiGroups, apiVersions, operations, resources, and a scope. |
| webhook.defaultRules | list | `[{"apiGroups":["apps"],"apiVersions":["v1","v1beta1","v1beta2"],"operations":["CREATE","UPDATE"],"resources":["daemonsets","deployments","statefulsets"],"scope":"Namespaced"},{"apiGroups":["batch"],"apiVersions":["v1","v1beta1"],"operations":["CREATE","UPDATE"],"resources":["jobs","cronjobs"],"scope":"Namespaced"},{"apiGroups":[""],"apiVersions":["v1"],"operations":["CREATE","UPDATE"],"resources":["pods","replicationcontrollers"],"scope":"Namespaced"}]` | An array of rules for common types for the ValidatingWebhookConfiguration |
| webhook.podAdditionalLabels | object | `{}` | Custom additional labels on webhook pods. |
| webhook.deploymentAnnotations | object | `{}` | Custom additional annotations on webhook Deployment. |
| webhook.resources | object | `{"limits":{},"requests":{"cpu":"100m","memory":"128Mi"}}` | Requests and limits for the webhook. |
| webhook.priorityClassName | string | `nil` | Priority Class name to be used in deployment if provided. |
| webhook.disallowExemptions | bool | `false` | Disallow any exemption |
| webhook.disallowConfigExemptions | bool | `false` | Disallow exemptions that are configured in the config file |
| webhook.disallowAnnotationExemptions | bool | `false` | Disallow exemptions that are configured via annotations |
| webhook.mutatingConfigurationAnnotations | object | `{}` |  |
| webhook.validatingConfigurationAnnotations | object | `{}` |  |
| webhook.pdb.enable | bool | `true` | If true, enables a PDB for the webhook |
| audit.enable | bool | `false` | Runs a one-time audit. This is used internally at Fairwinds, and may not be useful for others. |
| audit.cleanup | bool | `false` | Whether to delete the namespace once the audit is finished. |
| audit.outputURL | string | `""` | A URL which will receive a POST request with audit results. |
