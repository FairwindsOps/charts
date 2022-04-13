# mutillidae

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0.25](https://img.shields.io/badge/AppVersion-1.0.25-informational?style=flat-square)

A Helm chart for Kubernetes

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| nameOverride | string | `""` |  |
| fullnameOverride | string | `""` |  |
| image.repository | string | `"webpwnized/mutillidae"` |  |
| image.pullPolicy | string | `"Always"` |  |
| image.tag | string | `""` |  |
| ldap.replicaCount | int | `1` |  |
| ldap.imagePullSecrets | list | `[]` |  |
| ldap.serviceAccount.create | bool | `true` |  |
| ldap.serviceAccount.annotations | object | `{}` |  |
| ldap.serviceAccount.name | string | `""` |  |
| ldap.podAnnotations | object | `{}` |  |
| ldap.podSecurityContext | object | `{}` |  |
| ldap.securityContext | object | `{}` |  |
| ldap.service.type | string | `"ClusterIP"` |  |
| ldap.resources | object | `{}` |  |
| ldap.autoscaling.enabled | bool | `false` |  |
| ldap.autoscaling.minReplicas | int | `1` |  |
| ldap.autoscaling.maxReplicas | int | `100` |  |
| ldap.autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| ldap.nodeSelector | object | `{}` |  |
| ldap.tolerations | list | `[]` |  |
| ldap.affinity | object | `{}` |  |
| ldapAdmin.replicaCount | int | `1` |  |
| ldapAdmin.imagePullSecrets | list | `[]` |  |
| ldapAdmin.serviceAccount.create | bool | `true` |  |
| ldapAdmin.serviceAccount.annotations | object | `{}` |  |
| ldapAdmin.serviceAccount.name | string | `""` |  |
| ldapAdmin.ingress.enabled | bool | `false` |  |
| ldapAdmin.ingress.className | string | `""` |  |
| ldapAdmin.ingress.annotations."kubernetes.io/ingress.class" | string | `"nginx-ingress"` |  |
| ldapAdmin.ingress.annotations."cert-manager.io/cluster-issuer" | string | `"letsencrypt-prod"` |  |
| ldapAdmin.ingress.hosts[0].host | string | `"mutillidae-ldap.kepler.hillghost.com"` |  |
| ldapAdmin.ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ldapAdmin.ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ldapAdmin.ingress.tls[0].secretName | string | `"mutillidae-ldap-tls"` |  |
| ldapAdmin.ingress.tls[0].hosts[0] | string | `"mutillidae-ldap.kepler.hillghost.com"` |  |
| ldapAdmin.podAnnotations | object | `{}` |  |
| ldapAdmin.podSecurityContext | object | `{}` |  |
| ldapAdmin.securityContext | object | `{}` |  |
| ldapAdmin.service.type | string | `"ClusterIP"` |  |
| ldapAdmin.service.port | int | `80` |  |
| ldapAdmin.resources | object | `{}` |  |
| ldapAdmin.autoscaling.enabled | bool | `false` |  |
| ldapAdmin.autoscaling.minReplicas | int | `1` |  |
| ldapAdmin.autoscaling.maxReplicas | int | `100` |  |
| ldapAdmin.autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| ldapAdmin.nodeSelector | object | `{}` |  |
| ldapAdmin.tolerations | list | `[]` |  |
| ldapAdmin.affinity | object | `{}` |  |
| www.replicaCount | int | `1` |  |
| www.imagePullSecrets | list | `[]` |  |
| www.serviceAccount.create | bool | `true` |  |
| www.serviceAccount.annotations | object | `{}` |  |
| www.serviceAccount.name | string | `""` |  |
| www.podAnnotations | object | `{}` |  |
| www.podSecurityContext | object | `{}` |  |
| www.securityContext | object | `{}` |  |
| www.service.type | string | `"ClusterIP"` |  |
| www.service.port | int | `80` |  |
| www.ingress.enabled | bool | `false` |  |
| www.ingress.className | string | `""` |  |
| www.ingress.annotations."kubernetes.io/ingress.class" | string | `"nginx-ingress"` |  |
| www.ingress.annotations."cert-manager.io/cluster-issuer" | string | `"letsencrypt-prod"` |  |
| www.ingress.hosts[0].host | string | `"mutillidae.kepler.hillghost.com"` |  |
| www.ingress.hosts[0].paths[0].path | string | `"/"` |  |
| www.ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| www.ingress.tls[0].secretName | string | `"mutillidae-tls"` |  |
| www.ingress.tls[0].hosts[0] | string | `"mutillidae.kepler.hillghost.com"` |  |
| www.resources | object | `{}` |  |
| www.autoscaling.enabled | bool | `false` |  |
| www.autoscaling.minReplicas | int | `1` |  |
| www.autoscaling.maxReplicas | int | `100` |  |
| www.autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| www.nodeSelector | object | `{}` |  |
| www.tolerations | list | `[]` |  |
| www.affinity | object | `{}` |  |
| database.replicaCount | int | `1` |  |
| database.imagePullSecrets | list | `[]` |  |
| database.serviceAccount.create | bool | `true` |  |
| database.serviceAccount.annotations | object | `{}` |  |
| database.serviceAccount.name | string | `""` |  |
| database.podAnnotations | object | `{}` |  |
| database.podSecurityContext | object | `{}` |  |
| database.securityContext | object | `{}` |  |
| database.service.type | string | `"ClusterIP"` |  |
| database.resources | object | `{}` |  |
| database.nodeSelector | object | `{}` |  |
| database.tolerations | list | `[]` |  |
| database.affinity | object | `{}` |  |
| databaseAdmin.replicaCount | int | `1` |  |
| databaseAdmin.imagePullSecrets | list | `[]` |  |
| databaseAdmin.serviceAccount.create | bool | `true` |  |
| databaseAdmin.serviceAccount.annotations | object | `{}` |  |
| databaseAdmin.serviceAccount.name | string | `""` |  |
| databaseAdmin.ingress.enabled | bool | `false` |  |
| databaseAdmin.ingress.className | string | `""` |  |
| databaseAdmin.ingress.annotations."kubernetes.io/ingress.class" | string | `"nginx-ingress"` |  |
| databaseAdmin.ingress.annotations."cert-manager.io/cluster-issuer" | string | `"letsencrypt-prod"` |  |
| databaseAdmin.ingress.hosts[0].host | string | `"mutillidae-db.kepler.hillghost.com"` |  |
| databaseAdmin.ingress.hosts[0].paths[0].path | string | `"/"` |  |
| databaseAdmin.ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| databaseAdmin.ingress.tls[0].secretName | string | `"mutillidae-db-tls"` |  |
| databaseAdmin.ingress.tls[0].hosts[0] | string | `"mutillidae-db.kepler.hillghost.com"` |  |
| databaseAdmin.podAnnotations | object | `{}` |  |
| databaseAdmin.podSecurityContext | object | `{}` |  |
| databaseAdmin.securityContext | object | `{}` |  |
| databaseAdmin.service.type | string | `"ClusterIP"` |  |
| databaseAdmin.service.port | int | `80` |  |
| databaseAdmin.resources | object | `{}` |  |
| databaseAdmin.autoscaling.enabled | bool | `false` |  |
| databaseAdmin.autoscaling.minReplicas | int | `1` |  |
| databaseAdmin.autoscaling.maxReplicas | int | `100` |  |
| databaseAdmin.autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| databaseAdmin.nodeSelector | object | `{}` |  |
| databaseAdmin.tolerations | list | `[]` |  |
| databaseAdmin.affinity | object | `{}` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.5.0](https://github.com/norwoodj/helm-docs/releases/v1.5.0)
