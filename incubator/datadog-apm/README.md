<div align="center">
<a href="https://github.com/FairwindsOps/goldilocks"><img src="logo.svg" height="150" alt="Goldilocks" style="padding-bottom: 20px" /></a>
<br>
</div>

# datadog-apm

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 7.55.2](https://img.shields.io/badge/AppVersion-7.55.2-informational?style=flat-square)

A modified chart that only installs the datadog-apm agent

## Maintainers

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| sudermanjr |  |  |
| Azahorscak |  |  |

## Values

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| nameOverride | string | `""` |  |
| fullnameOverride | string | `""` |  |
| targetSystem | string | `"linux"` |  |
| remoteConfiguration.enabled | bool | `false` |  |
| datadog.apiKey | string | `nil` |  |
| datadog.apiKeyExistingSecret | string | `nil` |  |
| datadog.appKey | string | `nil` |  |
| datadog.appKeySecretName | string | `nil` |  |
| datadog.logLevel | string | `"INFO"` |  |
| datadog.site | string | `"datadoghq.com"` |  |
| clusterAgent.image.repository | string | `"datadog/agent"` |  |
| clusterAgent.image.pullPolicy | string | `"Always"` |  |
| clusterAgent.image.tag | string | `""` | Overrides the image tag whose default is {{ .Chart.AppVersion }} |
| clusterAgent.command[0] | string | `"trace-agent"` |  |
| clusterAgent.command[1] | string | `"--config=/etc/datadog-agent/datadog-cluster.yaml"` |  |
| clusterAgent.enabled | bool | `true` |  |
| clusterAgent.token | string | `nil` |  |
| clusterAgent.apm.enabled | bool | `true` |  |
| clusterAgent.apm.nonLocalTraffic | bool | `true` |  |
| clusterAgent.apm.receiverPort | int | `8126` |  |
| clusterAgent.additionalEnvVars | object | `{}` |  |
| clusterAgent.metricsProvider.enabled | bool | `true` |  |
| clusterAgent.metricsProvider.port | int | `8126` |  |
| clusterAgent.metricsProvider.service.type | string | `"ClusterIP"` |  |
| clusterAgent.metricsProvider.service.port | int | `8126` |  |
| clusterAgent.metricsProvider.aggregator | string | `"avg"` |  |
| clusterAgent.metricsProvider.wpaController | bool | `false` |  |
| clusterAgent.metricsProvider.useDatadogMetrics | bool | `false` |  |
| clusterAgent.priorityClassName | string | `nil` |  |
| clusterAgent.serviceAccount.create | bool | `true` |  |
| clusterAgent.serviceAccount.name | string | `"datadog-apm"` |  |
| clusterAgent.healthPort | int | `5555` |  |
| clusterAgent.livenessProbe.failureThreshold | int | `6` |  |
| clusterAgent.livenessProbe.initialDelaySeconds | int | `15` |  |
| clusterAgent.livenessProbe.periodSeconds | int | `15` |  |
| clusterAgent.livenessProbe.successThreshold | int | `1` |  |
| clusterAgent.livenessProbe.tcpSocket.port | int | `8126` |  |
| clusterAgent.livenessProbe.timeoutSeconds | int | `5` |  |
| clusterAgent.readinessProbe.failureThreshold | int | `6` |  |
| clusterAgent.readinessProbe.initialDelaySeconds | int | `15` |  |
| clusterAgent.readinessProbe.periodSeconds | int | `15` |  |
| clusterAgent.readinessProbe.successThreshold | int | `1` |  |
| clusterAgent.readinessProbe.tcpSocket.port | int | `8126` |  |
| clusterAgent.readinessProbe.timeoutSeconds | int | `5` |  |
| clusterAgent.resources.limits.cpu | string | `"50m"` |  |
| clusterAgent.resources.limits.memory | string | `"150Mi"` |  |
| clusterAgent.resources.requests.cpu | string | `"50m"` |  |
| clusterAgent.resources.requests.memory | string | `"150Mi"` |  |
| clusterAgent.hpa.enabled | bool | `true` |  |
| clusterAgent.hpa.minReplicas | int | `2` |  |
| clusterAgent.hpa.maxReplicas | int | `6` |  |
| clusterAgent.hpa.averageMemoryUtilization | int | `75` |  |
| clusterAgent.createPodDisruptionBudget | bool | `true` |  |
| podAnnotations | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| securityContext | object | `{}` |  |
| nodeSelector | object | `{}` |  |
| tolerations | list | `[]` |  |
