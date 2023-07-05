# Fairwinds Insights

[Fairwinds Insights](https://insights.fairwinds.com) - Software to automate, monitor, and enforce Kubernetes best practices.

> The documentation may be incomplete, and it is subject to breaking changes.

See [insights.docs.fairwinds.com](https://insights.docs.fairwinds.com/technical-details/self-hosted/installation/) for complete documentation.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| image.tag | string | `nil` | Docker image tag, defaults to the Chart appVersion |
| installationCode | string | `nil` | Installation code provided by Fairwinds. |
| installationCodeSecret | string | `nil` | Name of secret containing INSTALLATION_CODE |
| deployments | object | `{"additionalLabels":null,"additionalPodLabels":null}` | Deployments additional labels |
| polaris.config | string | `nil` | Configuration for Polaris |
| dashboardImage.repository | string | `"quay.io/fairwinds/insights-dashboard"` | Docker image repository for the front end |
| dashboardImage.tag | string | `nil` | Overrides tag for the dashboard, defaults to image.tag |
| apiImage.repository | string | `"quay.io/fairwinds/insights-api"` | Docker image repository for the API server |
| apiImage.tag | string | `nil` | Overrides tag for the API server, defaults to image.tag |
| migrationImage.repository | string | `"quay.io/fairwinds/insights-db-migration"` | Docker image repository for the database migration job |
| migrationImage.tag | string | `nil` | Overrides tag for the migration image, defaults to image.tag |
| cronjobImage.repository | string | `"quay.io/fairwinds/insights-cronjob"` | Docker image repository for maintenance CronJobs. |
| cronjobImage.tag | string | `nil` | Overrides tag for the cronjob image, defaults to image.tag |
| openApiImage.repository | string | `"swaggerapi/swagger-ui"` | Docker image repository for the Open API server |
| openApiImage.tag | string | `"v4.1.3"` | Overrides tag for the Open API server, defaults to image.tag |
| options.agentChartTargetVersion | string | `"2.21.3"` | Which version of the Insights Agent is supported by this version of Fairwinds Insights |
| options.insightsSAASHost | string | `"https://insights.fairwinds.com"` | Do not change, this is the hostname that Fairwinds Insights will reach out to for license verification. |
| options.allowHTTPCookies | bool | `false` | Allow cookies to work over HTTP instead of requiring HTTPS. This generally should not be changed. |
| options.dashboardConfig | string | `"config.self.js"` | Configuration file to use for the front-end. This generally should not be changed. |
| options.adminEmail | string | `nil` | An email address for the first admin user. This account will get created automatically but without a known password. You must initiate a password reset in order to login to this account. |
| options.organizationName | string | `nil` | The name of your organization. This will pre-populate Insights with an organization. |
| options.autogenerateKeys | bool | `false` | Autogenerate keys for session tracking. For testing/demo purposes only |
| options.migrateHealthScore | bool | `false` | Run the job to migrate health scores to a new format |
| options.secretName | string | `"fwinsights-secrets"` | Name of the secret where session keys and other secrets are stored |
| options.overprovisioning.enabled | bool | `false` |  |
| options.overprovisioning.cpu | string | `"1000m"` |  |
| options.overprovisioning.memory | string | `"1Gi"` |  |
| hubspotCronjob.resources.limits.cpu | string | `"500m"` |  |
| hubspotCronjob.resources.limits.memory | string | `"1024Mi"` |  |
| hubspotCronjob.resources.requests.cpu | string | `"80m"` |  |
| hubspotCronjob.resources.requests.memory | string | `"128Mi"` |  |
| hubspotCronjob.schedules | list | `[]` |  |
| benchmarkCronjob.resources.limits.cpu | string | `"500m"` |  |
| benchmarkCronjob.resources.limits.memory | string | `"1024Mi"` |  |
| benchmarkCronjob.resources.requests.cpu | string | `"80m"` |  |
| benchmarkCronjob.resources.requests.memory | string | `"128Mi"` |  |
| benchmarkCronjob.schedules | list | `[]` |  |
| selfHostedSecret | string | `nil` |  |
| additionalEnvironmentVariables | object | `{}` | Additional Environment Variables to set on the Fairwinds Insights pods. |
| rbac.serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| dashboard.pdb.enabled | bool | `false` | Create a pod disruption budget for the front end pods. |
| dashboard.pdb.minReplicas | int | `1` | How many replicas should always exist for the front end pods. |
| dashboard.hpa.enabled | bool | `false` | Create a horizontal pod autoscaler for the front end pods. |
| dashboard.hpa.min | int | `2` | Minimum number of replicas for the front end pods. |
| dashboard.hpa.max | int | `4` | Maximum number of replicas for the front end pods. |
| dashboard.hpa.metrics | list | `[{"resource":{"name":"cpu","target":{"averageUtilization":75,"type":"Utilization"}},"type":"Resource"},{"resource":{"name":"memory","target":{"averageUtilization":75,"type":"Utilization"}},"type":"Resource"}]` | Scaling metrics |
| dashboard.resources | object | `{"limits":{"cpu":"1000m","memory":"1024Mi"},"requests":{"cpu":"250m","memory":"256Mi"}}` | Resources for the front end pods. |
| dashboard.nodeSelector | object | `{}` | Node Selector for the front end pods. |
| dashboard.tolerations | list | `[]` | Tolerations for the front end pods. |
| dashboard.securityContext.runAsUser | int | `101` | The user ID to run the Dashboard under. comes from https://github.com/nginxinc/docker-nginx-unprivileged/blob/main/stable/alpine/Dockerfile |
| api.port | int | `8080` | Port for the API server to listen on. |
| api.pdb.enabled | bool | `false` | Create a pod disruption budget for the API server. |
| api.pdb.minReplicas | int | `1` | How many replicas should always exist for the API server. |
| api.hpa.enabled | bool | `false` | Create a horizontal pod autoscaler for the API server. |
| api.hpa.min | int | `2` | Minimum number of replicas for the API server. |
| api.hpa.max | int | `4` | Maximum number of replicas for the API server. |
| api.hpa.metrics | list | `[{"resource":{"name":"cpu","target":{"averageUtilization":75,"type":"Utilization"}},"type":"Resource"},{"resource":{"name":"memory","target":{"averageUtilization":75,"type":"Utilization"}},"type":"Resource"}]` | Scaling metrics |
| api.resources | object | `{"limits":{"cpu":"1000m","memory":"1024Mi"},"requests":{"cpu":"250m","memory":"256Mi"}}` | Resources for the API server. |
| api.nodeSelector | object | `{}` | Node Selector for the API server. |
| api.tolerations | list | `[]` | Tolerations for the API server. |
| api.securityContext.runAsUser | int | `10324` | The user ID to run the API server under. |
| api.ingress.enabled | bool | `true` | Enable the Open API ingress |
| api.service.type | string | `nil` | Service type for Open API server |
| openApi.port | int | `8080` | Port for the Open API server to listen on. |
| openApi.pdb.enabled | bool | `false` | Create a pod disruption budget for the Open API server. |
| openApi.pdb.minReplicas | int | `1` | How many replicas should always exist for the Open API server. |
| openApi.hpa.enabled | bool | `false` | Create a horizontal pod autoscaler for the Open API server. |
| openApi.hpa.min | int | `2` | Minimum number of replicas for the Open API server. |
| openApi.hpa.max | int | `3` | Maximum number of replicas for the Open API server. |
| openApi.hpa.metrics | list | `[{"resource":{"name":"cpu","target":{"averageUtilization":75,"type":"Utilization"}},"type":"Resource"},{"resource":{"name":"memory","target":{"averageUtilization":75,"type":"Utilization"}},"type":"Resource"}]` | Scaling metrics |
| openApi.resources | object | `{"limits":{"cpu":"256m","memory":"256Mi"},"requests":{"cpu":"100m","memory":"100Mi"}}` | Resources for the Open API server. |
| openApi.nodeSelector | object | `{}` | Node Selector for the Open API server. |
| openApi.tolerations | list | `[]` | Tolerations for the Open API server. |
| openApi.ingress.enabled | bool | `true` | Enable the Open API ingress |
| openApi.service.type | string | `nil` | Service type for Open API server |
| dbMigration.resources | object | `{"limits":{"cpu":1,"memory":"1024Mi"},"requests":{"cpu":"80m","memory":"128Mi"}}` | Resources for the database migration job. |
| dbMigration.securityContext.runAsUser | int | `10324` | The user ID to run the database migration job under. |
| samlCronjob.resources | object | `{"limits":{"cpu":"500m","memory":"1024Mi"},"requests":{"cpu":"80m","memory":"128Mi"}}` | Resources for the SAML sync job. |
| samlCronjob.schedules | list | `[{"cron":"0 * * * *","interval":"60m","name":"hourly"}]` | CRON schedules for the SAML sync job |
| alertsCronjob.resources | object | `{"limits":{"cpu":"500m","memory":"1024Mi"},"requests":{"cpu":"80m","memory":"128Mi"}}` | Resources for the Slack/Datadog integrations |
| alertsCronjob.schedules | list | `[{"cron":"5/10 * * * *","interval":"10m","name":"realtime"},{"cron":"0 16 * * *","interval":"24h","name":"digest"}]` | CRON schedules for the Slack/Datadog integrations |
| alertsCronjob.securityContext.runAsUser | int | `10324` | The user ID to run the alerts job under. |
| emailCronjob.resources | object | `{"limits":{"cpu":"500m","memory":"1024Mi"},"requests":{"cpu":"80m","memory":"128Mi"}}` | Resources for the Action Items email job. |
| emailCronjob.schedules | list | `[]` | CRON schedules for the Action Items email job. |
| emailCronjob.securityContext.runAsUser | int | `10324` | The user ID to run the email job under. |
| databaseCleanupCronjob.enabled | bool | `true` | Enable database cleanup true by default |
| databaseCleanupCronjob.resources | object | `{"limits":{"cpu":"500m","memory":"1024Mi"},"requests":{"cpu":"80m","memory":"128Mi"}}` | Resources for the database cleanup job. |
| databaseCleanupCronjob.schedules | list | `[{"cron":"0 0 * * *","interval":"24h","name":"database-cleanup"}]` | CRON schedules for the database cleanup job. |
| databaseCleanupCronjob.securityContext.runAsUser | int | `10324` | The user ID to run the database cleanup job under. |
| resourcesRecommendationsCronjob.enabled | bool | `true` | Enable resources recommendations true by default |
| resourcesRecommendationsCronjob.resources | object | `{"limits":{"cpu":1,"memory":"3Gi"},"requests":{"cpu":1,"memory":"3Gi"}}` | Resources for the resources recommendations job. |
| resourcesRecommendationsCronjob.schedules | list | `[{"cron":"0 2 * * *","interval":"24h","name":"resources-recommendations"}]` | CRON schedules for the resources recommendations job. |
| resourcesRecommendationsCronjob.securityContext.runAsUser | int | `10324` | The user ID to run the resources recommendations job under. |
| closeTicketsCronjob.enabled | bool | `true` | Close tickets enabled by default |
| closeTicketsCronjob.resources | object | `{"limits":{"cpu":"500m","memory":"2Gi"},"requests":{"cpu":"500m","memory":"1.5Gi"}}` | Resources for the close tickets job. |
| closeTicketsCronjob.schedules | list | `[{"cron":"0/15 * * * *","name":"close-tickets"}]` | CRON schedules for the close tickets job. |
| closeTicketsCronjob.securityContext.runAsUser | int | `10324` | The user ID to run the close tickets job under. |
| cloudCostsUpdateCronjob.enabled | bool | `true` | Cloud costs update enabled by default |
| cloudCostsUpdateCronjob.resources | object | `{"limits":{"cpu":"500m","memory":"2Gi"},"requests":{"cpu":"500m","memory":"2Gi"}}` | Resources for the cloud costs update job. |
| cloudCostsUpdateCronjob.schedules | list | `[{"cron":"15 */3 * * *","name":"costs-update"}]` | CRON schedules for the cloud costs update job |
| cloudCostsUpdateCronjob.securityContext.runAsUser | int | `10324` | The user ID to run the cloud costs update job under. |
| actionItemsFiltersRefresherCronJob.resources | object | `{"limits":{"cpu":"250m","memory":"512Mi"},"requests":{"cpu":"250m","memory":"512Mi"}}` | Resources for the action-items filters refresher job. |
| actionItemsFiltersRefresherCronJob.schedules | list | `[{"cron":"0/15 * * * *","name":"every-15-min"}]` | CRON schedules for the action-items filters refresher job. |
| actionItemsFiltersRefresherCronJob.securityContext.runAsUser | int | `10324` | The user ID to run the action-items filters refresher job under. |
| service.port | int | `80` | Port to be used for the API and Dashboard services. |
| service.type | string | `"ClusterIP"` | Service type for the API and Dashboard services |
| service.annotations | string | `nil` | Annotations for the services |
| sanitizedBranch | string | `nil` | Prefix to use on hostname. Generally not needed. |
| ingress.enabled | bool | `false` | Enable Ingress |
| ingress.tls | bool | `true` | Enable TLS |
| ingress.hostedZones | list | `[]` | Hostnames to use for Ingress |
| ingress.annotations | object | `{}` | Annotations to add to the API and Dashboard ingresses. |
| ingress.starPaths | bool | `true` | Certain ingress controllers do pattern matches, others use prefixes. If `/*` doesn't work for your ingress, try setting this to false. |
| ingress.separate | bool | `false` | Create different Ingress objects for the API and dashboard - this allows them to have different annotations |
| ingress.extraPaths | object | `{}` | Adds additional path ie. Redirect path for ALB |
| postgresql.postMigrate | bool | `false` | Set to `true` to run migrations after the upgrade |
| postgresql.image.tag | string | `"14.2.0-debian-10-r94"` |  |
| postgresql.ephemeral | bool | `true` | Use the ephemeral postgresql chart by default |
| postgresql.sslMode | string | `"require"` | SSL mode for connecting to the database |
| postgresql.tls | object | `{"certFilename":"tls.crt","certKeyFilename":"tls.key","certificatesSecret":"fwinsights-postgresql-ca","enabled":true}` | TLS mode for connecting to the database |
| postgresql.auth.username | string | `"postgres"` |  |
| postgresql.auth.database | string | `"fairwinds_insights"` |  |
| postgresql.auth.existingSecret | string | `"fwinsights-postgresql"` |  |
| postgresql.auth.secretKeys.adminPasswordKey | string | `"postgresql-password"` |  |
| postgresql.primary.service.port | int | `5432` | Port of the Postgres Database |
| postgresql.primary.persistence.enabled | bool | `true` | Create Persistent Volume with Postgres |
| postgresql.primary.resources | object | `{"limits":{"cpu":1,"memory":"1Gi"},"requests":{"cpu":"75m","memory":"256Mi"}}` | Resources section for Postgres |
| postgresql.readReplica | object | `{"database":null,"host":null,"port":null,"sslMode":null,"username":null}` | Optional read replica configuration. Currently in use by [`hubspot-cronjob`] |
| encryption.aes.cypherKey | string | `nil` |  |
| timescale.fullnameOverride | string | `"timescale"` |  |
| timescale.replicaCount | int | `1` |  |
| timescale.clusterName | string | `"timescale"` |  |
| timescale.ephemeral | bool | `true` | Use the ephemeral Timescale chart by default |
| timescale.pdb.enabled | bool | `true` | Use pdb enabled by default |
| timescale.pdb.minReplicas | int | `1` | Min timescale pdb replicas |
| timescale.sslMode | string | `"require"` | SSL mode for connecting to the database |
| timescale.postgresqlHost | string | `"timescale"` | Host for timescale |
| timescale.postgresqlUsername | string | `"postgres"` | Username to connect to Timescale with |
| timescale.postgresqlDatabase | string | `"postgres"` | Name of the Postgres Database |
| timescale.password | string | `"postgres"` | Password for the Postgres Database |
| timescale.secrets.certificateSecretName | string | `"fwinsights-timescale-ca"` |  |
| timescale.secrets.credentialsSecretName | string | `"fwinsights-timescale"` |  |
| timescale.service.primary | object | `{"port":5433}` | Port of the Timescale Database |
| timescale.loadBalancer.enabled | bool | `false` |  |
| timescale.timescaledbTune | object | `{"enabled":false}` | Database tuning for timescale |
| timescale.patroni | object | `{"log":{"level":"DEBUG"},"postgresql":{"create_replica_methods":[],"pgbackrest":{}}}` | Timescale patroni options |
| timescale.resources | object | `{"limits":{"cpu":1,"memory":"1Gi"},"requests":{"cpu":"75m","memory":"256Mi"}}` | Resources section for Timescale |
| email.strategy | string | `"memory"` | How to send emails, valid values include memory, ses, and smtp |
| email.sender | string | `nil` | Email address that emails will come from |
| email.recipient | string | `nil` | Email address to send notifications of new user signups. |
| email.smtpHost | string | `nil` | Host for SMTP strategy |
| email.smtpUsername | string | `nil` | Username for SMTP strategy |
| email.smtpPort | string | `nil` | Port for SMTP strategy |
| email.awsRegion | string | `nil` | Region for SES strategy, AWS_ACCESS_KEY_ID, and AWS_SECRET_ACCESS_KEY will need to be provided in the fwinsights-secrets secret. |
| reportStorage.strategy | string | `"minio"` | How to store report files, valid values include minio, s3, and local |
| reportStorage.bucket | string | `"reports"` | Name of the bucket to use for minio or s3 |
| reportStorage.region | string | `"us-east-1"` | AWS region to use for S3 |
| reportStorage.minioHost | string | `nil` | Hostname to use for Minio |
| reportStorage.fixturesDir | string | `nil` | Directory to store files in for local. |
| minio.install | bool | `true` | Install Minio |
| minio.buckets | list | `[{"name":"reports","policy":"none","purge":false}]` | Create the following buckets for the newly installed Minio |
| minio.resources | object | `{"requests":{"cpu":"50m","memory":"256Mi"}}` | Resources for Minio |
| minio.nameOverride | string | `"fw-minio"` | nameOverride to shorten names of Minio resources |
| minio.persistence.enabled | bool | `true` | Create a persistent volume for Minio |
| minio.replicas | int | `1` |  |
| minio.mode | string | `"standalone"` |  |
| migrateHealthScoreJob.resources.limits.cpu | string | `"500m"` |  |
| migrateHealthScoreJob.resources.limits.memory | string | `"1024Mi"` |  |
| migrateHealthScoreJob.resources.requests.cpu | string | `"80m"` |  |
| migrateHealthScoreJob.resources.requests.memory | string | `"128Mi"` |  |
| cronjobExecutor.image.repository | string | `"bitnami/kubectl"` |  |
| cronjobExecutor.image.tag | string | `"1.22.8"` |  |
| cronjobExecutor.resources.limits.cpu | string | `"100m"` |  |
| cronjobExecutor.resources.limits.memory | string | `"64Mi"` |  |
| cronjobExecutor.resources.requests.cpu | string | `"1m"` |  |
| cronjobExecutor.resources.requests.memory | string | `"3Mi"` |  |
| reportjob.enabled | bool | `true` |  |
| reportjob.pdb.enabled | bool | `true` |  |
| reportjob.pdb.minReplicas | int | `1` |  |
| reportjob.hpa.enabled | bool | `true` |  |
| reportjob.hpa.min | int | `2` |  |
| reportjob.hpa.max | int | `6` |  |
| reportjob.hpa.metrics[0].type | string | `"Resource"` |  |
| reportjob.hpa.metrics[0].resource.name | string | `"cpu"` |  |
| reportjob.hpa.metrics[0].resource.target.type | string | `"Utilization"` |  |
| reportjob.hpa.metrics[0].resource.target.averageUtilization | int | `75` |  |
| reportjob.hpa.metrics[1].type | string | `"Resource"` |  |
| reportjob.hpa.metrics[1].resource.name | string | `"memory"` |  |
| reportjob.hpa.metrics[1].resource.target.type | string | `"Utilization"` |  |
| reportjob.hpa.metrics[1].resource.target.averageUtilization | int | `75` |  |
| reportjob.resources.limits.cpu | string | `"500m"` |  |
| reportjob.resources.limits.memory | string | `"1024Mi"` |  |
| reportjob.resources.requests.cpu | string | `"80m"` |  |
| reportjob.resources.requests.memory | string | `"128Mi"` |  |
| reportjob.nodeSelector | object | `{}` |  |
| reportjob.tolerations | list | `[]` |  |
| automatedPullRequestJob.enabled | bool | `true` |  |
| automatedPullRequestJob.hpa.enabled | bool | `true` |  |
| automatedPullRequestJob.hpa.min | int | `2` |  |
| automatedPullRequestJob.hpa.max | int | `4` |  |
| automatedPullRequestJob.hpa.metrics[0].type | string | `"Resource"` |  |
| automatedPullRequestJob.hpa.metrics[0].resource.name | string | `"cpu"` |  |
| automatedPullRequestJob.hpa.metrics[0].resource.target.type | string | `"Utilization"` |  |
| automatedPullRequestJob.hpa.metrics[0].resource.target.averageUtilization | int | `80` |  |
| automatedPullRequestJob.hpa.metrics[1].type | string | `"Resource"` |  |
| automatedPullRequestJob.hpa.metrics[1].resource.name | string | `"memory"` |  |
| automatedPullRequestJob.hpa.metrics[1].resource.target.type | string | `"Utilization"` |  |
| automatedPullRequestJob.hpa.metrics[1].resource.target.averageUtilization | int | `80` |  |
| automatedPullRequestJob.resources.limits.cpu | string | `"500m"` |  |
| automatedPullRequestJob.resources.limits.memory | string | `"1024Mi"` |  |
| automatedPullRequestJob.resources.requests.cpu | string | `"80m"` |  |
| automatedPullRequestJob.resources.requests.memory | string | `"128Mi"` |  |
| automatedPullRequestJob.nodeSelector | object | `{}` |  |
| automatedPullRequestJob.tolerations | list | `[]` |  |
| repoScanJob.enabled | bool | `false` |  |
| repoScanJob.insightsCIVersion | string | `"5.1"` |  |
| repoScanJob.hpa.enabled | bool | `true` |  |
| repoScanJob.hpa.min | int | `2` |  |
| repoScanJob.hpa.max | int | `6` |  |
| repoScanJob.hpa.metrics[0].type | string | `"Resource"` |  |
| repoScanJob.hpa.metrics[0].resource.name | string | `"cpu"` |  |
| repoScanJob.hpa.metrics[0].resource.target.type | string | `"Utilization"` |  |
| repoScanJob.hpa.metrics[0].resource.target.averageUtilization | int | `75` |  |
| repoScanJob.hpa.metrics[1].type | string | `"Resource"` |  |
| repoScanJob.hpa.metrics[1].resource.name | string | `"memory"` |  |
| repoScanJob.hpa.metrics[1].resource.target.type | string | `"Utilization"` |  |
| repoScanJob.hpa.metrics[1].resource.target.averageUtilization | int | `75` |  |
| repoScanJob.resources.limits.cpu | string | `"500m"` |  |
| repoScanJob.resources.limits.memory | string | `"1024Mi"` |  |
| repoScanJob.resources.requests.cpu | string | `"80m"` |  |
| repoScanJob.resources.requests.memory | string | `"128Mi"` |  |
| repoScanJob.nodeSelector | object | `{}` |  |
| repoScanJob.tolerations | list | `[]` |  |
