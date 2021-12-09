# Fairwinds Custom Metrics

A controller for a collection of non-standard metrics.
## A Note on Chart Version 0.4.0+

Due to the [future deprecation](https://kubernetes.io/blog/2019/07/18/api-deprecations-in-1-16/) of various `extensions/v1beta1` API's, the 0.4.0 version of this chart will only work on kubernetes 1.14.0+

## Disabling certain metrics

As of chart version 0.6.0 you can disable metrics by using environment variables.

If you set any of the following pod env variables to `"false"` then the metric will be disabled. By default they are all enabled:
- ISTIO_ROOT_CA_EXPIRATION_DAYS_ENABLED
- EPOCH_TIME_ENABLED
- TERMINATING_PODS_ENABLED

For example, to disable the terminating pods metric, set the following in your values:
```
controller:
  env:
    TERMINATING_PODS_ENABLED: "false"
```

Also, if you don't need the istio root CA expire check and want to limit the RBAC permissions so that secrets are not visible to this workload, you can set `controller.istio.enabled` to `false` and the environment variable for that check will automatically get set as well.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| image.repository | string | `"quay.io/fairwinds/custom-metrics"` | Repository for the custom-metrics image |
| image.tag | string | `"v0.6.0"` | The custom-metrics image tag to use |
| image.pullPolicy | string | `"Always"` | imagePullPolicy - Highly recommended to leave this as `Always` |
| nameOverride | string | `""` |  |
| fullnameOverride | string | `""` |  |
| controller.enabled | bool | `true` | Whether or not to install the controller deployment |
| controller.istio.enabled | bool | `true` |  |
| controller.rbac.create | bool | `true` | If set to true, rbac resources will be created for the controller |
| controller.serviceAccount.create | bool | `true` | If true, a service account will be created for the controller. If set to false, you must set `controller.serviceAccount.name` |
| controller.serviceAccount.name | string | `nil` |  |
| controller.datadogAnnotations.enabled | bool | `true` | If set to true, the controller will add datadog annotations to the pods |
| controller.logVerbosity | string | `"2"` | The verbosity of the controller's logs |
| controller.env | object | `{}` | Map of environment var name and value to be set on the controller pods |
| controller.nodeSelector | object | `{}` | Node selector for the controller pod |
| controller.tolerations | list | `[]` | Tolerations for the controller podons - List of tolerations to put on the deployment pods |
| controller.affinity | object | `{}` | Affinity for the controller pods |
| controller.resources | object | `{"limits":{"cpu":"25m","memory":"32Mi"},"requests":{"cpu":"25m","memory":"32Mi"}}` | The resources block for the controller pods |
| controller.service.enabled | bool | `true` | If set to true, the controller will create a service for the controller |
| controller.service.type | string | `"ClusterIP"` | The type of service to create. |
| controller.service.port | int | `10042` | The port to run the dashboard service on |
