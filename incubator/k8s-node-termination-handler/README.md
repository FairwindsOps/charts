# Polaris

[k8s-termination-handler](https://github.com/GoogleCloudPlatform/k8s-node-termination-handler)
is a tool for gracefully draining preemptible nodes before Google automatically shuts them down.

## Installation
We recommend installing k8s-termination-handler in its own namespace.

## Configuration
Parameter | Description | Default
--------- | ----------- | -------
`image.repository` | Image repo | k8s.gcr.io/gke-node-termination-handler@sha256
`image.tag` | Image tag | aca12d17b222dfed755e28a44d92721e477915fb73211d0a0f8925a1fa847cca
`image.pullPolicy` | Image pull policy | IfNotPresent
`daemonset.updateStrategy.type` | Daemonset update strategy type | RollingUpdate
`resources.limits.cpu` | Daemonset CPU limit | 150m
`resources.limits.memory` | Daemonset memory limit | 30Mi
`resources.requests.cpu` | Daemonset CPU request | 150m
`resources.requests.memory` | Daemonset memory limit | 30Mi
