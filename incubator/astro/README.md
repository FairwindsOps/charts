# Astro
Astro was designed to simplify datadog monitor administration. This is an operator that emits datadog monitors based on kubernetes state. The operator responds to changes of resources in your kubernetes cluster and will manage datadog monitors based on the configured state.

More information about astro is available on [GitHub](https://github.com/FairwindsOps/astro).

## Installation
We recommend installing astro in its own namespace and with a simple release name:

```
helm install incubator/astro --name astro --namespace astro
```

## Prerequisites
Kubernetes 1.11+, Helm 2.13+

## Configuration
Parameter | Description | Default
--- | --- | ---
`image.repository` | Docker image repo  | `quay.io/fairwinds/astro`
`image.tag` | Docker image tag  | `v1.2.0`
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
`controller.rbac.create` | if true, rbac resources will be created. | `true`
`controller.serviceAccount.create` | if true, a service account will be created.  If false, you must set `controller.serviceAccount.name`. | `true`
`controller.serviceAccount.name` | The name of an existing service account to use. | `''`
`secret.create` | if true, a secret with api credentials will be created.  If false, you must set `secret.name` | `true`
`secret.name` | The name of an existing secret to mount to the container. | `""` 
`definitionsPath` | The path to the monitor definitions configuration. This can be a local path or a URL. | `""`
`owner` | A unique name to designate as the owner. This will be applied as a tag to identified managed monitors. | `astro`
`dryRun` | when set to true monitors will not be managed in datadog. | `false`
`custom_config.enabled` | if true a custom configuration must be specified in `custom_config.data`. | `false`
`custom_config.data` | An astro configuration file.  See the [Astro repo readme](https://github.com/fairwindsops/astro) for more details. |

