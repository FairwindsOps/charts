# Chart - node-problem-detector

This chart installs [node-problem-detector](https://github.com/kubernetes/node-problem-detector) as a daemeonset.

## Configuration

The following table lists the configurable parameters of the chart and their default values.

| Parameter | Description | Default | Required |
| --------- | ----------- | ------- | -------- |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` | no |
| `image.repository` | Image repository | `k8s.gcr.io/node-problem-detector` | no |
| `image.tag` | Image tag | `v0.5.0` | no |
