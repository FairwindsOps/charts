# Yelb

A demo app created by https://github.com/mreferre/yelb

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| oci://registry-1.docker.io/bitnamicharts | postgresql | 15.5.29 |
| oci://registry-1.docker.io/bitnamicharts | valkey | 0.3.16 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| appserver.replicaCount | int | `1` |  |
| appserver.image.repository | string | `"quay.io/fairwinds/yelb-appserver"` |  |
| appserver.image.pullPolicy | string | `"Always"` |  |
| appserver.image.tag | string | `"v0.6.0"` |  |
| appserver.imagePullSecrets | list | `[]` |  |
| appserver.nameOverride | string | `""` |  |
| appserver.fullnameOverride | string | `""` |  |
| appserver.serviceAccount.create | bool | `true` |  |
| appserver.serviceAccount.automount | bool | `false` |  |
| appserver.serviceAccount.annotations | object | `{}` |  |
| appserver.serviceAccount.name | string | `""` |  |
| appserver.podAnnotations | object | `{}` |  |
| appserver.podLabels | object | `{}` |  |
| appserver.podSecurityContext | object | `{}` |  |
| appserver.securityContext | object | `{}` |  |
| appserver.service.type | string | `"ClusterIP"` |  |
| appserver.service.port | int | `4567` |  |
| appserver.resources.requests.cpu | string | `"100m"` |  |
| appserver.resources.requests.memory | string | `"128Mi"` |  |
| appserver.livenessProbe.httpGet.path | string | `"/api/hostname"` |  |
| appserver.livenessProbe.httpGet.port | string | `"http"` |  |
| appserver.readinessProbe.httpGet.path | string | `"/api/getstats"` |  |
| appserver.readinessProbe.httpGet.port | string | `"http"` |  |
| appserver.autoscaling.enabled | bool | `true` |  |
| appserver.autoscaling.minReplicas | int | `2` |  |
| appserver.autoscaling.maxReplicas | int | `100` |  |
| appserver.autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| appserver.volumes | list | `[]` |  |
| appserver.volumeMounts | list | `[]` |  |
| appserver.nodeSelector | object | `{}` |  |
| appserver.tolerations | list | `[]` |  |
| appserver.affinity | object | `{}` |  |
| ui.replicaCount | int | `1` |  |
| ui.image.repository | string | `"quay.io/fairwinds/yelb-ui"` |  |
| ui.image.pullPolicy | string | `"Always"` |  |
| ui.image.tag | string | `"v0.1.0"` |  |
| ui.imagePullSecrets | list | `[]` |  |
| ui.nameOverride | string | `""` |  |
| ui.fullnameOverride | string | `""` |  |
| ui.serviceAccount.create | bool | `true` |  |
| ui.serviceAccount.automount | bool | `false` |  |
| ui.serviceAccount.annotations | object | `{}` |  |
| ui.serviceAccount.name | string | `""` |  |
| ui.podAnnotations | object | `{}` |  |
| ui.podLabels | object | `{}` |  |
| ui.podSecurityContext | object | `{}` |  |
| ui.securityContext | object | `{}` |  |
| ui.service.type | string | `"ClusterIP"` |  |
| ui.service.port | int | `80` |  |
| ui.resources.limits.cpu | string | `"100m"` |  |
| ui.resources.limits.memory | string | `"128Mi"` |  |
| ui.resources.requests.cpu | string | `"100m"` |  |
| ui.resources.requests.memory | string | `"128Mi"` |  |
| ui.livenessProbe.httpGet.path | string | `"/"` |  |
| ui.livenessProbe.httpGet.port | string | `"http"` |  |
| ui.readinessProbe.httpGet.path | string | `"/"` |  |
| ui.readinessProbe.httpGet.port | string | `"http"` |  |
| ui.autoscaling.enabled | bool | `true` |  |
| ui.autoscaling.minReplicas | int | `2` |  |
| ui.autoscaling.maxReplicas | int | `100` |  |
| ui.autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| ui.volumes | list | `[]` |  |
| ui.volumeMounts | list | `[]` |  |
| ui.nodeSelector | object | `{}` |  |
| ui.tolerations | list | `[]` |  |
| ui.affinity | object | `{}` |  |
| ingress.enabled | bool | `true` |  |
| ingress.className | string | `"nginx-ingress"` |  |
| ingress.hostName | string | `"yelb.sandbox.hillghost.com"` |  |
| ingress.annotations."cert-manager.io/cluster-issuer" | string | `"letsencrypt-prod"` |  |
| postgresql.enabled | bool | `true` |  |
| postgresql.primary.extraVolumes[0].name | string | `"init"` |  |
| postgresql.primary.extraVolumes[0].secret.secretName | string | `"yelb-db-init"` |  |
| postgresql.primary.extraVolumeMounts[0].name | string | `"init"` |  |
| postgresql.primary.extraVolumeMounts[0].readOnly | bool | `true` |  |
| postgresql.primary.extraVolumeMounts[0].mountPath | string | `"/init/"` |  |
| postgresql.global.postgresql.auth.username | string | `"yelb"` |  |
| postgresql.global.postgresql.auth.password | string | `"yelb"` |  |
| postgresql.global.postgresql.auth.database | string | `"yelbdatabase"` |  |
| valkey.enabled | bool | `true` |  |
| valkey.auth.enabled | bool | `false` |  |
| valkey.auth.password | string | `"foobar"` |  |
