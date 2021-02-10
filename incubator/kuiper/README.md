# kuiper

![Version: 0.0.1](https://img.shields.io/badge/Version-0.0.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v0.0.1](https://img.shields.io/badge/AppVersion-v0.0.1-informational?style=flat-square)

A Helm chart to run Kuiper

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| replicaCount | int | `1` |  |
| image.repository | string | `"quay.io/fairwinds/kuiper"` | The image repository to use |
| image.pullPolicy | string | `"Always"` | Recommend not changing this. |
| image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion. |
| imagePullSecrets | list | `[]` | A list of image pull secrets to authenticate with your registry |
| nameOverride | string | `""` | A template override for name |
| fullnameOverride | string | `""` | A template override for fullname |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| podAnnotations | object | `{}` | Annotations to add to the pod(s) |
| podSecurityContext | object | `{}` | A securityContext for the pod |
| securityContext | object | `{}` | A container security context |
| resources | object | `{}` | A resources block for the controller |
| nodeSelector | object | `{}` | A node selector for the controller pods |
| tolerations | list | `[]` | Tolerations for the controller pods |
| affinity | object | `{}` | Affinity block for the controller pods |
