<div align="center">
<a href="https://github.com/FairwindsOps/goldilocks"><img src="logo.svg" height="150" alt="Goldilocks" style="padding-bottom: 20px" /></a>
<br>
</div>

## Intro

This is a Helm chart for the Fairwinds [Goldilocks project](https://github.com/FairwindsOps/goldilocks). It provides an easy way to install the controller and the dashboard for viewing resource recommendations in your Kubernetes cluster. Please see the [Goldilocks README](https://github.com/FairwindsOps/goldilocks) for more information.

## Requirements

This has a hard requirement on VPA being installed. Please see the [Goldilocks README](https://github.com/FairwindsOps/goldilocks)

## installVPA Flag

VPA CRDs and the recommender can be installed using a pre-install hook if `installVPA` is set to true in the values. This also acts as a pre-upgrade hook that will update to the latest version of the VPA that is currently supported.

NOTE: This *only* installs the necessary CRDs, RBAC, and the recommender. It does not include the other parts of VPA. If you are intending to install VPA for other reasons, we recommend you maintain the installation of the controller separate from this chart.

## *WARNING* Upgrading to chart v2.0.0

If using `installVPA=true` when updating from v1.x.x to v2.x.x of this chart, there are some considerations. v2.x.x of the chart started only installing the recommender and the necessary CRDs and RBAC from the VPA installation. This is due to the volatile and risky nature of running a beta mutatingadmissionwebhook in your cluster. If you have previously used the `installVPA=true` flag to install the VPA, we recommend that you completely uninstall and re-install the VPA as part of the upgrade. We have provided a new hook to do this that will run before the install hook.

If upgrading from v1.x.x to v2.x.x we recommend upgrading like so:

```
helm upgrade goldilocks fairwinds-stable/goldilocks --set installVPA=true --set uninstallVPA=true
```

This will completely remove the VPA and then re-install it using the new method.

## Usage

| Parameter                              | Description                                                                                                                      | Default                        |
|----------------------------------------|----------------------------------------------------------------------------------------------------------------------------------|--------------------------------|
| `installVPA`                           | Whether or not to install the VPA controller from the vpa repository. Only installs the recommender. If enabled on upgrades, it will also upgrade the VPA to the version specified. | `False` |
| `image.pullPolicy`                     | imagePullPolicy - Highly recommended to leave this as `Always`                                                                   | `Always`                       |
| `image.repository`                     | Repository for the goldilocks image                                                                                              | `quay.io/fairwinds/goldilocks` |
| `image.tag`                            | The goldilocks image tag to use                                                                                                  | `v1.3.0`                       |
| `controller.enabled`                   | Whether or not to install the controller deployment                                                                              | `True`                         |
| `controller.affinity`                  | Affinity for the controller pod                                                                                                  | `{}`                           |
| `controller.nodeSelector`              | Node selector for the controller pod                                                                                             | `{}`                           |
| `controller.rbac.create`               | If set to true, rbac resources will be created for the controller                                                                | `True`                         |
| `controller.resources.limits.cpu`      | Controller cpu limit                                                                                                             | `25m`                          |
| `controller.resources.limits.memory`   | Controller memory limit                                                                                                          | `32Mi`                         |
| `controller.resources.requests.cpu`    | Controller CPU request                                                                                                           | `25m`                          |
| `controller.resources.requests.memory` | Controller memory request                                                                                                        | `32Mi`                         |
| `controller.serviceAccount.create`     | If true, a service account will be created for the controller. If set to false, you must set `controller.serviceAccount.name`    | `True`                         |
| `controller.serviceAccount.name`       | The name of an existing service account to use for the controller                                                                |                                |
| `controller.tolerations`               | Tolerations for the controller pod                                                                                               | `[]`                           |
| `controller.flags`                     | A map of additional flags to pass to the controller                                                                              | `{}`                           |
| `dashboard.enabled`                    | If true, the dashboard component will be installed.                                                                              | `True`                         |
| `dashboard.affinity`                   | Affinity for the dashbaord pods.                                                                                                 | `{}`                           |
| `dashboard.excludeContainer`           | A comma-separated list of container names to ignore in the dashboard globally.                                                   | `linkderd-proxy,istio-proxy`   |
| `dashboard.basePath`                   | Customize the basePath passed as `--base-path` to the dashboard container (useful for instance if using an ingress path)         |                                |
| `dashboard.ingress.enabled`            | If true, an ingress object will be created. Further configuration is necessary. See [values.yaml](values.yaml) for an example.   | `False`                        |
| `dashboard.ingress.annotations`        | Annotations on the ingress object.                                                                                               | `{}`                           |
| `dashboard.ingress.hosts.0.host`       | Ingress host. See [values.yaml](values.yaml) for an example.                                                                     | `chart-example.local`          |
| `dashboard.ingress.hosts.0.paths`      | Ingress path. See [values.yaml](values.yaml) for an example.                                                                     | `[]`                           |
| `dashboard.ingress.tls`                | Ingress TLS block. See [values.yaml](values.yaml) for an example.                                                                | `[]`                           |
| `dashboard.logVerbosity`               | Dashboard log verbosity. Can be set from 1-10 with 10 being the most verbose                                                     | `2`                            |
| `dashboard.nodeSelector`               | Node selector for dashboard pods                                                                                                 | `{}`                           |
| `dashboard.rbac.create`                | If true, rbac resources will be created for the dashboard service account                                                        | `True`                         |
| `dashboard.replicaCount`               | Number of dashboard pods to run                                                                                                  | `2`                            |
| `dashboard.resources.limits.cpu`       | Dashboard CPU limit                                                                                                              | `25m`                          |
| `dashboard.resources.limits.memory`    | Dashboard memory limits                                                                                                          | `32Mi`                         |
| `dashboard.resources.requests.cpu`     | Dashboard CPU request                                                                                                            | `25m`                          |
| `dashboard.resources.requests.memory`  | Dashboard memory request                                                                                                         | `32Mi`                         |
| `dashboard.service.port`               | Dashboard service port.                                                                                                          | `80`                           |
| `dashboard.service.type`               | Servvice type for the dashboard service.                                                                                         | `ClusterIP`                    |
| `dashboard.serviceAccount.create`      | If true, a service account will be created for the dashboard. If set to false, then you must set `dashboard.serviceAccount.name` | `True`                         |
| `dashboard.serviceAccount.name`        | The name of an existing service account to use for the dashboard.                                                                |                                |
| `dashboard.tolerations`                | Tolerations for the dashboard pod                                                                                                | `[]`                           |
| `fullnameOverride`                     | Override the fullName in the chart                                                                                               |                                |
| `nameOverride`                         | Override the name field in the chart                                                                                             |                                |
| `uninstallVPA`                         | Used to upgrade to v2.x.x of the chart. See the upgrade section above.                                                           | `false`                        |
