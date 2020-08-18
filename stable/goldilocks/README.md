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

## installVPA Flag

VPA CRDs and the recommender can be installed using a pre-install hook if `installVPA` is set to true in the values. This also acts as a pre-upgrade hook that will update to the latest version of the VPA that is currently supported.

NOTE: This *only* installs the necessary CRDs, RBAC, and the recommender. It does not include the other parts of VPA. If you are intending to install VPA for other reasons, we recommend you maintain the installation of the controller separate from this chart.

## *WARNING* Upgrading to chart v2.0.0

If using `installVPA=true` when updating from v1.x.x to v2.x.x of this chart, there are some considerations. v2.x.x of the chart started only installing the recommender and the necessary CRDs and RBAC from the VPA installation. This is due to the volatile and risky nature of running a beta mutatingadmissionwebhook in your cluster. If you have previously used the `installVPA=true` flag to install the VPA, we recommend that you completely uninstall and re-install the VPA as part of the upgrade. We have provided a new hook to do this that will run before the install hook.

If upgrading from v1.x.x to v2.x.x we recommend upgrading like so:

```
helm upgrade goldilocks fairwinds-stable/goldilocks --set reinstallVPA=true
```

This will completely remove the VPA and then re-install it using the new method.

## Chart Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| controller.affinity | object | `{}` | Affinity for the controller pods |
| controller.enabled | bool | `true` | Whether or not to install the controller deployment |
| controller.flags | object | `{}` | A map of additional flags to pass to the controller |
| controller.logVerbosity | string | `"2"` | Controller log verbosity. Can be set from 1-10 with 10 being extremely verbose |
| controller.nodeSelector | object | `{}` | Node selector for the controller pod |
| controller.rbac.create | bool | `true` | If set to true, rbac resources will be created for the controller |
| controller.resources | object | `{"limits":{"cpu":"25m","memory":"32Mi"},"requests":{"cpu":"25m","memory":"32Mi"}}` | The resources block for the controller pods |
| controller.serviceAccount.create | bool | `true` | If true, a service account will be created for the controller. If set to false, you must set `controller.serviceAccount.name` |
| controller.serviceAccount.name | string | `nil` | The name of an existing service account to use for the controller. Combined with `controller.serviceAccount.create` |
| controller.tolerations | list | `[]` | Tolerations for the controller pod |
| dashboard.affinity | object | `{}` |  |
| dashboard.basePath | string | `nil` | Sets the web app's basePath/base href |
| dashboard.enabled | bool | `true` | If true, the dashboard component will be installed |
| dashboard.excludeContainers | string | `"linkerd-proxy,istio-proxy"` | Container names to exclude from displaying in the Goldilocks dashboard |
| dashboard.ingress.annotations | object | `{}` |  |
| dashboard.ingress.enabled | bool | `false` | Enables an ingress object for the dashboard. |
| dashboard.ingress.hosts[0].host | string | `"chart-example.local"` |  |
| dashboard.ingress.hosts[0].paths | list | `[]` |  |
| dashboard.ingress.tls | list | `[]` |  |
| dashboard.logVerbosity | string | `"2"` | Dashboard log verbosity. Can be set from 1-10 with 10 being extremely verbose |
| dashboard.nodeSelector | object | `{}` |  |
| dashboard.rbac.create | bool | `true` | If set to true, rbac resources will be created for the dashboard |
| dashboard.replicaCount | int | `2` | Number of dashboard pods to run |
| dashboard.resources | object | `{"limits":{"cpu":"25m","memory":"32Mi"},"requests":{"cpu":"25m","memory":"32Mi"}}` | A resources block for the dashboard. |
| dashboard.service.port | int | `80` | The port to run the dashboard service on |
| dashboard.service.type | string | `"ClusterIP"` | The type of the dashboard service |
| dashboard.serviceAccount.create | bool | `true` | If true, a service account will be created for the dashboard. If set to false, you must set `dashboard.serviceAccount.name` |
| dashboard.serviceAccount.name | string | `nil` | The name of an existing service account to use for the controller. Combined with `dashboard.serviceAccount.create` |
| dashboard.tolerations | list | `[]` |  |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"Always"` | imagePullPolicy - Highly recommended to leave this as `Always` |
| image.repository | string | `"quay.io/fairwinds/goldilocks"` | Repository for the goldilocks image |
| image.tag | string | `"v2.2.0"` | The goldilocks image tag to use |
| installVPA | bool | `false` | Whether or not to install the VPA controller from the vpa repository. Only installs the recommender. If enabled on upgrades, it will also upgrade the VPA to the version specified. |
| nameOverride | string | `""` |  |
| reinstallVPA | bool | `false` | Used to upgrade or reinstall the VPA. Enables both the uninstall and install hooks. |
| uninstallVPA | bool | `false` | Used to uninstall the vpa controller. |
| vpaVersion | string | `"e16a0adef6c7d79a23d57f9bbbef26fc9da59378"` | The git ref to install VPA from. |
