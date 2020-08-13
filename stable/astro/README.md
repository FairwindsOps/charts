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

## Configuration
Parameter | Description | Default
--- | --- | ---
`image.repository` | Docker image repo  | `quay.io/fairwinds/astro`
`image.tag` | Docker image tag  | `v1.5.3`
`image.pullPolicy` | Docker image pull policy  | `IfNotPresent`
`resources.requests.cpu` | CPU resource request | `100m`
`resources.requests.memory` | Memory resource request | `128Mi`
`resources.limits.cpu` | CPU resource limit | `100m`
`resources.limits.memory` | Memory resource limit | `128Mi`
`nodeSelector` | Deployment nodeSelector | `{}`
`tolerations` | Deployment tolerations | `[]`
`affinity` | Deployment affinity | `{}`
`datadog.apiKey` | Datadog api key | `""`
`datadog.appKey` | Datadog app key | `""`
`rbac.create` | if true, rbac resources will be created. | `true`
`deployment.serviceAccount.create` | if true, a service account will be created.  If false, you must set `deployment.serviceAccount.name`. | `true`
`deployment.serviceAccount.name` | The name of an existing service account to use. | `''`
`deployment.replicas` | The number of replicas to use | `2`
`secret.create` | if true, a secret with api credentials will be created.  If false, you must set `secret.name` | `true`
`secret.name` | The name of an existing secret to mount to the container. | `""`
`definitionsPath` | The path to the monitor definitions configuration. This can be a local path or a URL. | `""`
`owner` | A unique name to designate as the owner. This will be applied as a tag to identified managed monitors. | `astro`
`dryRun` | when set to true monitors will not be managed in datadog. | `false`
`custom_config.enabled` | if true a custom configuration must be specified in `custom_config.data`. | `false`
`custom_config.data` | An astro configuration file.  See the [Astro repo readme](https://github.com/fairwindsops/astro) for more details. |
