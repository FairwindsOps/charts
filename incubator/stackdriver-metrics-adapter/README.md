stackdriver-metrics-adapter
===========================
This chart installs a stackdriver metrics adapter which exposes stackdriver external metrics in your cluster for HPAs to use for scaling.  More information is available in the [GCP Documentation](https://cloud.google.com/kubernetes-engine/docs/tutorials/external-metrics-autoscaling).


## Chart Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"gcr.io/gke-release/custom-metrics-stackdriver-adapter"` |  |
| image.tag | string | `"v0.12.0-gke.0"` |  |
| replicaCount | int | `1` | Number of replicas the deployment should run. |
| resources.limits.cpu | string | `"250m"` |  |
| resources.limits.memory | string | `"200Mi"` |  |
| resources.requests.cpu | string | `"250m"` |  |
| resources.requests.memory | string | `"200Mi"` |  |
| serviceAccount.annotations | map | None | Give a set of key:value pairs to annotate the serviceAccount |
| service.port | int | `443` |  |
| service.protocol | string | `"TCP"` |  |
| service.targetPort | int | `443` |  |
| service.type | string | `"ClusterIP"` |  |
| container.useNewResourceModel | bool | false | [Documentation](https://github.com/GoogleCloudPlatform/k8s-stackdriver/tree/master/custom-metrics-stackdriver-adapter#configure-cluster) (look for terms "legacy model" vs "new model" )  |