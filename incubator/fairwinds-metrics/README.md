# Fairwinds Custom Metrics

A controller for a collection of non-standard metrics.

## A Note on Chart Version 0.4.0+

Due to the [future deprecation](https://kubernetes.io/blog/2019/07/18/api-deprecations-in-1-16/) of various `extensions/v1beta1` API's, the 0.4.0 version of this chart will only work on kubernetes 1.14.0+

## Chart Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| controller.affinity | object | `{}` |  |
| controller.datadogAnnotations.enabled | bool | `true` | If true, annotations will be added to the pod which will enable datadog scraping of the endpoint |
| controller.enabledMetrics | string | `""` | The list of metrics to run. If blank, defaults to all available. |
| controller.interval | int | `60` | The interval to run the controller loop on. |
| controller.logVerbosity | string | `"2"` | The klog verbosity to use for the controller pod |
| controller.nodeSelector | object | `{}` |  |
| controller.rbac.create | bool | `true` | If true, rbac resources will be created |
| controller.resources | object | `{"limits":{"cpu":"25m","memory":"32Mi"},"requests":{"cpu":"25m","memory":"32Mi"}}` | A resources block for the controller pod |
| controller.service.enabled | bool | `true` | If true, a service will be created connected to the metrics port |
| controller.service.port | int | `2112` | The port that the service will expose |
| controller.service.type | string | `"ClusterIP"` | The type of service to create |
| controller.serviceAccount.create | bool | `true` | If true, a service acount will be created |
| controller.serviceAccount.name | string | `""` | If controller.serviceAccount.create is false, you must set this to an existing serviceAccountName |
| controller.tolerations | list | `[]` |  |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"Always"` | The pullPolicy for the container. Recommend not changing this |
| image.repository | string | `"quay.io/fairwinds/custom-metrics"` | The repository to pull the image from |
| image.tag | string | `"2afe3bde6404002dca156aa97de4fe5bbc09c088"` | The image tag to use |
| nameOverride | string | `""` | A template override for name |
