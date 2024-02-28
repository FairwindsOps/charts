## Intro

This is a Helm chart for the Fairwinds Insights Right-sizer

## Installation
```bash
helm repo add fairwinds-stable https://charts.fairwinds.com/stable
helm install right-sizer fairwinds-stable/right-sizer --namespace right-sizer
```

## Requirements

This has a hard requirement on VPA being installed. Insights Right-sizer uses a custom version of the VPA recommender in order to provide recommendations from Insights directly.

## vpa subchart

Fairwinds has published a chart for installing VPA [in our stable repo](https://github.com/FairwindsOps/charts/tree/master/stable/vpa). It can be enabled as a sub-chart by setting `vpa.enabled==true`. When installed via the provided sub-chart, the custom recommender image (quay.io/fairwinds/vpa-recommender) will be selected and configured. In order to retrieve recommendations from insights, there must be a secret that populates `INSIGHTS_TOKEN` with your credentials.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| createSecret | bool | `false` |  |
| uninstallVPA | bool | `false` | Enabling this flag will remove a vpa installation that was previously managed with this chart. It is considered deprecated and will be removed in a later release. |
| vpa.enabled | bool | `true` |  |
| vpa.recommender.image.repository | string | `"quay.io/fairwinds/vpa-recommender"` |  |
| vpa.recommender.image.tag | string | `"master"` |  |
| vpa.recommender.extraArgs.use-insights-recommender | string | `"true"` |  |
| vpa.recommender.extraArgs.recommender-interval | string | `"1h"` |  |
| vpa.recommender.envFromSecret | string | `"insights-agent-token"` |  |
| vpa.recommender.securityContext.allowPrivilegeEscalation | bool | `false` |  |
| vpa.recommender.securityContext.readOnlyRootFilesystem | bool | `true` |  |
| vpa.recommender.securityContext.runAsUser | int | `65534` |  |
| vpa.recommender.securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| metrics-server.enabled | bool | `false` | If true, the metrics-server will be installed as a sub-chart |
| metrics-server.apiService.create | bool | `true` |  |
| image.repository | string | `"quay.io/fairwinds/right-sizer"` |  |
| image.tag | string | `"v0.0.2-dev"` |  |
| image.pullPolicy | string | `"Always"` | imagePullPolicy - Highly recommended to leave this as `Always` |
| imagePullSecrets | list | `[]` | A list of image pull secret names to use |
| nameOverride | string | `""` |  |
| fullnameOverride | string | `""` |  |
| controller.enabled | bool | `true` | Whether or not to install the controller deployment |
| controller.revisionHistoryLimit | int | `10` | Number of old replicasets to retain, default is 10, 0 will garbage-collect old replicasets |
| controller.rbac.create | bool | `true` | If set to true, rbac resources will be created for the controller |
| controller.rbac.enableArgoproj | bool | `true` | If set to true, the clusterrole will give access to argoproj.io resources |
| controller.rbac.extraRules | list | `[]` | Extra rbac rules for the controller clusterrole |
| controller.rbac.extraClusterRoleBindings | list | `["view"]` | A list of ClusterRoles for which ClusterRoleBindings will be created for the ServiceAccount, if enabled |
| controller.serviceAccount.create | bool | `true` | If true, a service account will be created for the controller. If set to false, you must set `controller.serviceAccount.name` |
| controller.serviceAccount.name | string | `nil` | The name of an existing service account to use for the controller. Combined with `controller.serviceAccount.create` |
| controller.flags | object | `{"on-by-default":false}` | A map of additional flags to pass to the controller |
| controller.logVerbosity | string | `"2"` | Controller log verbosity. Can be set from 1-10 with 10 being extremely verbose |
| controller.nodeSelector | object | `{}` | Node selector for the controller pod |
| controller.tolerations | list | `[]` | Tolerations for the controller pod |
| controller.affinity | object | `{}` | Affinity for the controller pods |
| controller.topologySpreadConstraints | list | `[]` | Topology spread constraints for the controller pods |
| controller.resources | object | `{"limits":{},"requests":{"cpu":"25m","memory":"256Mi"}}` | The resources block for the controller pods |
| controller.podSecurityContext | object | `{"seccompProfile":{"type":"RuntimeDefault"}}` | Defines the podSecurityContext for the controller pod |
| controller.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsNonRoot":true,"runAsUser":10324}` | The container securityContext for the controller container |
| controller.deployment.extraVolumeMounts | list | `[]` | Extra volume mounts for the controller container |
| controller.deployment.extraVolumes | list | `[]` | Extra volumes for the controller pod |
| controller.deployment.annotations | object | `{}` | Extra annotations for the controller deployment |
| controller.deployment.additionalLabels | object | `{}` | Extra labels for the controller deployment |
| controller.deployment.podAnnotations | object | `{}` | Extra annotations for the controller pod |
| config | string | `nil` | The [right-sizer configuration]() Optional |
