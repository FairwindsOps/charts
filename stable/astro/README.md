<div align="center">
<a href="https://github.com/FairwindsOps/astro"><img src="logo.svg" height="150" alt="Astro" style="padding-bottom: 20px" /></a>
<br>
</div>

# Astro
Astro was designed to simplify datadog monitor administration. This is an operator that emits datadog monitors based on kubernetes state. The operator responds to changes of resources in your kubernetes cluster and will manage datadog monitors based on the configured state.

More information about astro is available on [GitHub](https://github.com/FairwindsOps/astro).

## Installation
We recommend installing astro in its own namespace and with a simple release name:

```
helm repo add fairwinds-stable https://charts.fairwinds.com/stable
helm install astro fairwinds-stable/astro --namespace astro
```
## Changes to chart values in 1.0.0+
When upgrading from a chart version below 1.0.0 to 1.0.0+ take into account the following changes in values:

< 1.0.0 Value | 1.0.0+ Value
--- | ---
`controller.rbac.create` | `rbac.create`
`controller.serviceAccount.create` | `deployment.serviceAccount.create`
`controller.serviceAccount.name` | `deployment.serviceAccount.name`

New values that were previously not available:
- `deployment.replicas`

## Prerequisites
Kubernetes 1.11+, Helm 2.13+

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Deployment affinity |
| custom_config.data | string | "" | An astro configuration file. See the [Astro repo readme](https://github.com/fairwindsops/astro) for more details. |
| custom_config.enabled | bool | `false` | If true a custom configuration must be specified in `custom_config.data`. |
| datadog.apiKey | string | `""` | Datadog API key |
| datadog.appKey | string | `""` | Datadog app key |
| definitionsPath | string | `"conf.yml"` | The path to the monitor definitions configuration. This can be a local path or a URL. |
| deployment.replicas | int | `2` | The number of replicas to use. |
| deployment.serviceAccount.create | bool | `true` | If true, a service account will be created. If false, you must set `deployment.serviceAccount.name`. |
| deployment.serviceAccount.name | string | `nil` | The name of an existing service account to use. |
| dryRun | bool | `false` | When set to true monitors will not be managed in datadog. |
| image.pullPolicy | string | `"IfNotPresent"` | Docker image pull policy |
| image.repository | string | `"quay.io/fairwinds/astro"` | Docker image repo |
| image.tag | string | `"v1.5.3"` | Docker image tag |
| nodeSelector | object | `{}` | Deployment ndoeSelector |
| owner | string | `"astro"` | A unique name to designate as teh owner. This will be applied as a tag to identified managed monitors. |
| rbac.create | bool | `true` | If true, RBAC resources will be created. |
| resources | object | `{"limits":{"cpu":"100m","memory":"128Mi"},"requests":{"cpu":"100m","memory":"128Mi"}}` | The resources block for the deployment. |
| secret.create | bool | `true` | If true, a secret with API credentials will be created. If false, you must set `secret.name` |
| secret.name | string | `nil` | The name of an existing secret to mount to the container. |
| tolerations | list | `[]` | Deployment tolerations |
