<div align="center">
<a href="https://github.com/FairwindsOps/goldilocks"><img src="logo.svg" height="150" alt="Goldilocks" style="padding-bottom: 20px" /></a>
<br>
</div>

## Intro

This is a Helm chart for the Fairwinds [Goldilocks project](https://github.com/FairwindsOps/goldilocks). It provides an easy way to install the controller and the dashboard for viewing resource recommendations in your Kubernetes cluster. Please see the [Goldilocks README](https://github.com/FairwindsOps/goldilocks) for more information.

## Installation
```bash
helm repo add fairwinds-stable https://charts.fairwinds.com/stable
helm install goldilocks fairwinds-stable/goldilocks --namespace goldilocks
```

## Requirements

This has a hard requirement on VPA being installed. Please see the [Goldilocks README](https://github.com/FairwindsOps/goldilocks)

## vpa subchart

Fairwinds has published a chart for installing VPA [in our stable repo](https://github.com/FairwindsOps/charts/tree/master/stable/vpa). It can be enabled as a sub-chart by setting `vpa.enabled==true`. We recommend just installing the chart and managing it separately.

## Major Version Upgrade Notes

## *BREAKING* Upgrading from v2.x.x to v3.x.x

In this change, the `installVPA` value and corresponding hooks have been removed in favor of the sub-chart. The recommended path forward is to remove the hook-installed resources and manage the VPA installation with the [Fairwinds VPA Chart](https://github.com/FairwindsOps/charts/tree/master/stable/vpa)

We have kept the `uninstallVPA` flag in place, which will remove a vpa installation that was previously managed by this chart. This flag will be deprecated in a later release.

## *BREAKING* Upgrading to chart v2.x.x from v1.x.x

If using `installVPA=true` when updating from v1.x.x to v2.x.x of this chart, there are some considerations. v2.x.x of the chart started only installing the recommender and the necessary CRDs and RBAC from the VPA installation. This is due to the volatile and risky nature of running a beta mutatingadmissionwebhook in your cluster. If you have previously used the `installVPA=true` flag to install the VPA, we recommend that you completely uninstall and re-install the VPA as part of the upgrade. We have provided a new hook to do this that will run before the install hook.

If upgrading from v1.x.x to v2.x.x we recommend upgrading like so:

```
helm upgrade goldilocks fairwinds-stable/goldilocks --set reinstallVPA=true
```

This will completely remove the VPA and then re-install it using the new method.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| uninstallVPA | bool | `false` | Enabling this flag will remove a vpa installation that was previously managed with this chart. It is considered deprecated and will be removed in a later release. |
| vpa.enabled | bool | `false` | If true, the vpa will be installed as a sub-chart |
| metrics-server.enabled | bool | `false` | If true, the metrics-server will be installed as a sub-chart |
| metrics-server.apiService.create | bool | `true` |  |
| image.repository | string | `"quay.io/fairwinds/goldilocks"` | Repository for the goldilocks image |
| image.tag | string | `"v3.1.0"` | The goldilocks image tag to use |
| image.pullPolicy | string | `"Always"` | imagePullPolicy - Highly recommended to leave this as `Always` |
| nameOverride | string | `""` |  |
| fullnameOverride | string | `""` |  |
| controller.enabled | bool | `true` | Whether or not to install the controller deployment |
| controller.rbac.create | bool | `true` | If set to true, rbac resources will be created for the controller |
| controller.serviceAccount.create | bool | `true` | If true, a service account will be created for the controller. If set to false, you must set `controller.serviceAccount.name` |
| controller.serviceAccount.name | string | `nil` | The name of an existing service account to use for the controller. Combined with `controller.serviceAccount.create` |
| controller.flags | object | `{}` | A map of additional flags to pass to the controller |
| controller.logVerbosity | string | `"2"` | Controller log verbosity. Can be set from 1-10 with 10 being extremely verbose |
| controller.nodeSelector | object | `{}` | Node selector for the controller pod |
| controller.tolerations | list | `[]` | Tolerations for the controller pod |
| controller.affinity | object | `{}` | Affinity for the controller pods |
| controller.resources | object | `{"limits":{"cpu":"25m","memory":"32Mi"},"requests":{"cpu":"25m","memory":"32Mi"}}` | The resources block for the controller pods |
| dashboard.enabled | bool | `true` | If true, the dashboard component will be installed |
| dashboard.replicaCount | int | `2` | Number of dashboard pods to run |
| dashboard.service.type | string | `"ClusterIP"` | The type of the dashboard service |
| dashboard.service.port | int | `80` | The port to run the dashboard service on |
| dashboard.logVerbosity | string | `"2"` | Dashboard log verbosity. Can be set from 1-10 with 10 being extremely verbose |
| dashboard.excludeContainers | string | `"linkerd-proxy,istio-proxy"` | Container names to exclude from displaying in the Goldilocks dashboard |
| dashboard.rbac.create | bool | `true` | If set to true, rbac resources will be created for the dashboard |
| dashboard.serviceAccount.create | bool | `true` | If true, a service account will be created for the dashboard. If set to false, you must set `dashboard.serviceAccount.name` |
| dashboard.serviceAccount.name | string | `nil` | The name of an existing service account to use for the controller. Combined with `dashboard.serviceAccount.create` |
| dashboard.ingress.enabled | bool | `false` | Enables an ingress object for the dashboard. |
| dashboard.ingress.annotations | object | `{}` |  |
| dashboard.ingress.hosts[0].host | string | `"chart-example.local"` |  |
| dashboard.ingress.hosts[0].paths | list | `[]` |  |
| dashboard.ingress.tls | list | `[]` |  |
| dashboard.resources | object | `{"limits":{"cpu":"25m","memory":"32Mi"},"requests":{"cpu":"25m","memory":"32Mi"}}` | A resources block for the dashboard. |
| dashboard.nodeSelector | object | `{}` |  |
| dashboard.tolerations | list | `[]` |  |
| dashboard.affinity | object | `{}` |  |
