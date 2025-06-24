# Fairwinds Insights Admission Controller

## Intro

This is an Admission Controller to reject deployment of objects into your Kubernetes cluster that woudld create dangerous action items in [Fairwinds Insights](https://insights.fairwinds.com)

## Installation

A valid TLS certificate is required for this admission controller to work. If you have cert-manager installed then everything should work out of the box. If you don't use cert-manager and don't want to install it then you can supply a CA Bundle with the `caBundle` parameter and create a TLS secret and pass the name of that secret as `secretName`.

```bash
helm repo add fairwinds-stable https://charts.fairwinds.com/stable
helm install insights-admission fairwinds-stable/insights-admission \
  --namespace insights-admission \
  --set insights.organization=acme-co \
  --set insights.cluster=staging \
  --set insights.base64token="dG9rZW4="
```

If you have an additional type of object to monitor with this admission controller then you can add a values file that looks like this.

```
rules:
- apiGroups:
  - custom
  apiVersions:
  - v1
  operations:
  - CREATE
  - UPDATE
  resources:
  - customResource
  scope: Namespaced
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| global.proxy.http | string | `nil` | Annotations used to access the proxy servers(http). |
| global.proxy.https | string | `nil` | Annotations used to access the proxy servers(https). |
| global.proxy.ftp | string | `nil` | Annotations used to access the proxy servers(ftp). |
| global.proxy.no_proxy | string | `nil` | Annotations to provides a way to exclude traffic destined to certain hosts from using the proxy. |
| global.sslCertFileSecretName | string | `nil` | The name of an existing Secret containing an SSL certificate file to be used when communicating with a self-hosted Insights API. |
| global.sslCertFileSecretKey | string | `nil` | The key, within global.sslCertFileSecretName, containing an SSL certificate file to be used when communicating with a self-hosted Insights API. |
| insights.organization | string | `""` | The name of your Organization from Fairwinds Insights |
| insights.cluster | string | `""` | The name of your cluster from Fairwinds Insights |
| insights.host | string | `"https://insights.fairwinds.com"` | Override the hostname for Fairwinds Insights |
| insights.base64token | string | `""` | The token for your cluster from the Cluster Settings page in Fairwinds Insights. This should already be base64 encoded. |
| insights.secret.create | bool | `true` | Create a secret containing the base64 encoded token. |
| insights.secret.nameOverride | string | `nil` | The name of the secret to use. |
| insights.secret.suffix | string | `"token"` | The suffix to add onto the relase name to get the secret that contains the base64 token |
| insights.configmap.create | bool | `true` | Create a config map with Insights configuration |
| insights.configmap.nameOverride | string | `nil` | The name of the configmap to use. |
| insights.configmap.suffix | string | `"configmap"` | The suffix to add onto the release name to get the configmap that contains the host/organization/cluster |
| webhookConfig.failurePolicy | string | `"Ignore"` | failurePolicy for the ValidatingWebhookConfiguration and MutatingWebhookConfiguration. This also informs whether the admission controller blocks validation requests on errors, such as while executing OPA policies. |
| webhookConfig.matchPolicy | string | `"Exact"` | matchPolicy for the ValidatingWebhookConfiguration and MutatingWebhookConfiguration |
| webhookConfig.timeoutSeconds | int | `30` | number of seconds to wait before failing the admission request (max is 30) |
| webhookConfig.namespaceSelector | object | `{"matchExpressions":[{"key":"control-plane","operator":"DoesNotExist"}]}` | namespaceSelector for the ValidatingWebhookConfiguration and MutatingWebhookConfiguration |
| webhookConfig.annotations | object | `{}` | Annotations to add to the ValidatingWebhookConfiguration and MutatingWebhookConfiguration |
| webhookConfig.objectSelector | object | `{}` | objectSelector for the ValidatingWebhookConfiguration and MutatingWebhookConfiguration |
| webhookConfig.rules | list | `[]` | An array of additional rules for the ValidatingWebhookConfiguration and MutatingWebhookConfiguration. Each requires a set of apiGroups, apiVersions, operations, resources, and a scope. Rules specified here may also be granted to the Insights OPA plugin, see also the insights-agent chart values for opa. |
| webhookConfig.defaultRules | list | `[{"apiGroups":["apps"],"apiVersions":["v1","v1beta1","v1beta2"],"operations":["CREATE","UPDATE"],"resources":["daemonsets","deployments","statefulsets"],"scope":"Namespaced"},{"apiGroups":["batch"],"apiVersions":["v1","v1beta1"],"operations":["CREATE","UPDATE"],"resources":["jobs","cronjobs"],"scope":"Namespaced"},{"apiGroups":[""],"apiVersions":["v1"],"operations":["CREATE","UPDATE"],"resources":["pods","replicationcontrollers"],"scope":"Namespaced"}]` | An array of rules for commons types for the ValidatingWebhookConfiguration and MutatingWebhookConfiguration |
| webhookConfig.rulesAutoRBAC | bool | `true` | Automatically add RBAC rules allowing get and list operations for the APIGroups and Resources supplied in rules. This *does not* impact RBAC rules added for `defaultRules`. |
| webhookConfig.mutating.enable | bool | `false` | Enable the mutating webhook, which uses settings defined in webhookConfig values. |
| pluto.targetVersions | string | `""` | Pluto target versions specified as key=value[,key=value...]. These supersede all defaults in Pluto version files. If unset, the `k8s` component will use the current Kubernetes cluster version. For example: k8s=v1.20.0,cert-manager=v1.8.0 |
| resources | object | `{"limits":{"cpu":1,"memory":"2Gi"},"requests":{"cpu":"100m","memory":"128Mi"}}` | A resources block for the controller. |
| image.repository | string | `"quay.io/fairwinds/insights-admission-controller"` | Repository for the Insights Admission Controller image |
| image.pullPolicy | string | `"Always"` | imagePullPolicy - Highly recommended to leave this as 'Always' |
| image.tag | string | `""` | The Insights admission controller tag to use. Defaults to the Chart's AppVersion |
| imagePullSecrets | list | `[]` | Secrets to use when pulling this image. |
| replicaCount | int | `2` | The number of pods to run for the admission contrller. |
| autoscaling.enabled | bool | `false` | Autoscale instead of a static number of pods running. |
| autoscaling.minReplicas | int | `2` | Minimum number of pods to run. |
| autoscaling.maxReplicas | int | `5` | Maximum number of pods to run. |
| autoscaling.targetCPUUtilizationPercentage | int | `80` | Target CPU to scale towards. |
| autoscaling.targetMemoryUtilizationPercentage | string | `nil` | Target memory to scale towards. |
| pdb.enabled | bool | `true` | Create a Pod Disruption Budget (PDB). This also requires `autoscaling.minReplicas` > 1 or `replicaCount` > 1 |
| pdb.minAvailable | int | `1` | The minimum number of admission controller pods that must still be available after an eviction, expressed as an absolute number or a percentage. |
| nameOverride | string | `""` | Overrides the name of the release. |
| fullnameOverride | string | `""` | Long name of the release to override. |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| serviceAccount.rbac.viewSecrets | bool | `false` | Grant the admission controller access to view secrets |
| serviceAccount.rbac.grantRole | string | `nil` | Grant the admission controller access to a given role (such as view) |
| serviceAccount.rbac.additionalAccess | string | `nil` | Grant the admission controller access to additional objects. This should contain an array of objects with each having an array of apiGroups, an array of resources, and an array of verbs. Just like a Role. |
| podAnnotations | object | `{}` | Annotations to add to each pod. |
| podSecurityContext | object | `{}` | Security Context for the entire pod. |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsNonRoot":true,"runAsUser":15000}` | Security Context for the container. |
| service.type | string | `"ClusterIP"` | Type of service to create. |
| service.port | int | `443` | Port to use for the service. |
| service.usePod443 | bool | `false` | Force binding to port 443 on pods. This is useful for GKE private clusters. Requires running as root |
| ignoreRequestUsernames | string | `"system:addon-manager"` | Specify a comma-separated list of usernames whos admission-requests will be ignored. This is useful for automation that regularly updates in-cluster resources. |
| nodeSelector | object | `{}` | nodSelector to add to the controller. |
| tolerations | list | `[]` | Toleratations to add to the controller. |
| topologySpreadConstraints | list | `[{"labelSelector":{"matchLabels":{"component":"controller"}},"maxSkew":1,"topologyKey":"topology.kubernetes.io/zone","whenUnsatisfiable":"ScheduleAnyway"},{"labelSelector":{"matchLabels":{"component":"controller"}},"maxSkew":1,"topologyKey":"kubernetes.io/hostname","whenUnsatisfiable":"ScheduleAnyway"}]` | TopologySpreadConstraints to add to the controller. |
| affinity | object | `{}` | Pod affinity/anti-affinity rules |
| caBundle | string | `""` | If you are providing your own certificate then this is the Certificate Authority for that certificate |
| secretName | string | `""` | If you are providing your own certificate then this is the name of the secret holding the certificate. |
| clusterDomain | string | `"cluster.local"` | The base domain to use for cluster DNS |
| certManagerApiVersion | string | `""` | If secretName is empty, we assume that you use cert-manager to provision the admission controller certificates. This allows pinning the apiVersion rather than using helm capabilities detection. Useful for gitops tools such as ArgoCD |
| polaris.config | string | `nil` | Configuration for Polaris |
| test | object | `{"enabled":false,"image":{"repository":"python","tag":"3.10-alpine"}}` | Used for chart CI only - deploys a test deployment |
| extraManifests | list | `[]` | A list of extra manifests to be installed with this chart. This is useful for installing additional resources that are not part of the chart |
