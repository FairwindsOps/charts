# gke-node-termination-handler

[gke-node-termination-handler](https://github.com/GoogleCloudPlatform/k8s-node-termination-handler)
is a tool for gracefully draining preemptible GCP nodes before Google automatically shuts them down.

## Installation
We recommend installing gke-node-termination-handler in its own namespace.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| image.repository | string | `"k8s.gcr.io/gke-node-termination-handler@sha256"` | The image repository to pull from |
| image.tag | string | `"aca12d17b222dfed755e28a44d92721e477915fb73211d0a0f8925a1fa847cca"` | The image tag to use |
| image.pullPolicy | string | `"Always"` | The image pull policy. We recommend not changing this |
| nameOverride | string | `""` | A template override for name |
| fullnameOverride | string | `""` | A template override for fullname |
| daemonset.updateStrategy.type | string | `"RollingUpdate"` | The daemonset update strategy |
| resources | object | `{"limits":{"cpu":"150m","memory":"30Mi"},"requests":{"cpu":"150m","memory":"30Mi"}}` | A resource limit and requess block for the daemonset |
| args | list | `["-v=10","--logtostderr","--exclude-pods=$(POD_NAME):$(POD_NAMESPACE)","--taint=cloud.google.com/impending-node-termination::NoSchedule"]` | Command arguments. Usually you don't need to override them. |
| extraArgs | list | `[]` | Extra arguments for command. For example, "--system-pod-grace-period=14s" to wait for 14s for regular pods to terminate. |
| env | object | `{"SLACK_WEBHOOK_URL":""}` | Extra environment variables. For example "SLACK_WEBHOOK_URL" |
