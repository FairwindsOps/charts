![Version: 2.2.0](https://img.shields.io/badge/Version-2.2.0-informational?style=flat-square)

# Vault Token Injector Chart

A Helm chart for Fairwinds vault-token-injector

This will inject vault tokens and address variables into circle builds on a schedule

## Upgrading

### v2.0.0

Chart version 2.0.0 introduced a metrics endpoint by default.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| replicaCount | int | `1` | We currently only support a single instance |
| circleToken | string | `"replaceme"` | A token for interacting with CircleCI |
| tfCloudToken | string | `"replaceme"` | A token for interacting with TFCloud |
| existingSecret | string | `""` | An existing secret that contains the environment variables CIRCLEC_CI_TOKEN and TFCLOUD_TOKEN |
| vaultAddress | string | `"https://vault.example.com"` | The vault address to get tokens from |
| vaultTokenFile | string | `""` | A file containing a vault token. Optional. |
| config | object | `{"circleci":[{"env_variable":"VAULT_TOKEN","name":"FairwindsOps/example","vault_role":"some-vault-role"}],"vaultAddress":"https://vault.example.com"}` | The configuration of the vault-token-injector |
| metrics.enabled | bool | `true` | If true, a prometheus endpoint will be enabled on port 4329 |
| metrics.service.enabled | bool | `true` |  |
| metrics.serviceMonitor.enabled | bool | `false` |  |
| metrics.serviceMonitor.interval | string | `"60s"` |  |
| metrics.serviceMonitor.scrapeTimeout | string | `"30s"` |  |
| metrics.serviceMonitor.labels | object | `{}` |  |
| logLevel | int | `1` | The klog log level (1-10). WARNING: Log level 10 will print secrets to logs |
| image.repository | string | `"quay.io/fairwinds/vault-token-injector"` | The image repository to pullt he vault-token-injector image from |
| image.pullPolicy | string | `"Always"` | This is recommended to be set as Always |
| image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion. |
| imagePullSecrets | list | `[]` | A list of imagePullSecrets to use |
| nameOverride | string | `""` | Overrides the name in the main template |
| fullnameOverride | string | `""` | Overrides the fullname in the main template |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| podAnnotations | object | `{}` | Annotations to add to the pod |
| podSecurityContext | object | `{}` | a podSecurityContext to apply |
| securityContext | object | `{"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsNonRoot":true,"runAsUser":10000}` | securityContext for the containers |
| resources | object | `{"limits":{"cpu":"20m","memory":"128Mi"},"requests":{"cpu":"20m","memory":"128Mi"}}` | resources block for the pod |
| nodeSelector | object | `{}` | A nodeSelector block for the pod |
| tolerations | list | `[]` | tolerations block for the pod |
| affinity | object | `{}` | affinity block for the pod |
