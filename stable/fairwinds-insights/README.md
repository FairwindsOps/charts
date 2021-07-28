# Fairwinds Insights

[Fairwinds Insights](https://insights.fairwinds.com) - Software to automate, monitor, and enforce Kubernetes best practices.

> The self-hosted version of Fairwinds Insights is currently in alpha.
> The documentation is incomplete, and it is subject to breaking changes.

See [insights.docs.fairwinds.com](https://insights.docs.fairwinds.com/self-hosted/installation/) for complete documentation.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| image.tag | string | `nil` | Docker image tag, defaults to the Chart appVersion |
| installationCode | string | `nil` | Installation code provided by Fairwinds. |
| installationCodeSecret | string | `nil` | Name of secret containing INSTALLATION_CODE |
| polaris.config | string | `nil` | Configuration for Polaris |
| dashboardImage.repository | string | `"quay.io/fairwinds/insights-dashboard"` | Docker image repository for the front end |
| dashboardImage.tag | string | `nil` | Docker tag for the dashboard |
| apiImage.repository | string | `"quay.io/fairwinds/insights-api"` | Docker image repository for the API server |
| apiImage.tag | string | `nil` | Docker tag for the API server |
| migrationImage.repository | string | `"quay.io/fairwinds/insights-db-migration"` | Docker image repository for the database migration job |
| migrationImage.tag | string | `nil` | Docker tag for the migration image |
| cronjobImage.repository | string | `"quay.io/fairwinds/insights-cronjob"` | Docker image repository for maintenance CronJobs. |
| cronjobImage.tag | string | `nil` | Docker tag for the cronjob image |
| options.agentChartTargetVersion | string | `"1.14.0"` | Which version of the Insights Agent is supported by this version of Fairwinds Insights |
| options.insightsSAASHost | string | `"https://insights.fairwinds.com"` | Do not change, this is the hostname that Fairwinds Insights will reach out to for license verification. |
| options.allowHTTPCookies | bool | `false` | Allow cookies to work over HTTP instead of requiring HTTPS. This generally should not be changed. |
| options.dashboardConfig | string | `"config.self.js"` | Configuration file to use for the front-end. This generally should not be changed. |
| options.adminEmail | string | `nil` | An email address for the first admin user. This account will get created automatically but without a known password. You must initiate a password reset in order to login to this account. |
| options.organizationName | string | `nil` | The name of your organization. This will pre-populate Insights with an organization. |
| options.autogenerateKeys | bool | `false` | Autogenerate keys for session tracking. For testing/demo purposes only |
| options.migrateHealthScore | bool | `true` | Run the job to migrate health scores to a new format |
| options.secretName | string | `"fwinsights-secrets"` | Name of the secret where session keys and other secrets are stored |
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
| dbMigration.resources | object | `{"limits":{"cpu":1,"memory":"1024Mi"},"requests":{"cpu":"80m","memory":"128Mi"}}` | Resources for the database migration job. |
| dbMigration.securityContext.runAsUser | int | `10324` | The user ID to run the database migration job under. |
| alertsCronjob.resources | object | `{"limits":{"cpu":"500m","memory":"1024Mi"},"requests":{"cpu":"80m","memory":"128Mi"}}` | Resources for the Slack/Datadog integrations |
| alertsCronjob.schedules | list | `[{"cron":"5/10 * * * *","interval":"10m","name":"realtime"},{"cron":"0 16 * * *","interval":"24h","name":"digest"}]` | CRON schedules for the Slack/Datadog integrations |
| alertsCronjob.securityContext.runAsUser | int | `10324` | The user ID to run the alerts job under. |
| aggregateCronjob.resources | object | `{"limits":{"cpu":"250m","memory":"512Mi"},"requests":{"cpu":"40m","memory":"32Mi"}}` | Resources for the Workload Metrics aggregation job. |
| aggregateCronjob.schedules | list | `[{"cron":"5 0/2 * * *","interval":"120m","name":"bi-hourly"}]` | CRON schedules for the Workload Metrics aggregation job. |
| aggregateCronjob.securityContext.runAsUser | int | `10324` | The user ID to run the Workload Metrics aggregation job under. |
| emailCronjob.resources | object | `{"limits":{"cpu":"500m","memory":"1024Mi"},"requests":{"cpu":"80m","memory":"128Mi"}}` | Resources for the Action Items email job. |
| emailCronjob.schedules | list | `[{"cron":"0 16 * * 1","interval":"168h","name":"weekly-email"}]` | CRON schedules for the Action Items email job. |
| emailCronjob.securityContext.runAsUser | int | `10324` | The user ID to run the email job under. |
| deleteOldActionItemsCronjob.resources | object | `{"limits":{"cpu":"500m","memory":"1024Mi"},"requests":{"cpu":"80m","memory":"128Mi"}}` | Resources for the delete old Action Items job. |
| deleteOldActionItemsCronjob.schedules | list | `[{"cron":"0 0 * * *","interval":"24h","name":"ai-cleanup"}]` | CRON schedules for the delete old Action Items job. |
| deleteOldActionItemsCronjob.securityContext.runAsUser | int | `10324` | The user ID to run the delete Action Items job under. |
| service.port | int | `80` | Port to be used for the API and Dashboard services. |
| service.type | string | `"ClusterIP"` | Service type for the API and Dashboard services |
| sanitizedBranch | string | `nil` | Prefix to use on hostname. Generally not needed. |
| ingress.enabled | bool | `false` | Enable Ingress |
| ingress.tls | bool | `true` | Enable TLS |
| ingress.hostedZones | list | `[]` | Hostnames to use for Ingress |
| ingress.annotations | object | `{}` | Annotations to add to the API and Dashboard ingresses. |
| ingress.starPaths | bool | `true` | Certain ingress controllers do pattern matches, others use prefixes. If `/*` doesn't work for your ingress, try setting this to false. |
| postgresql.ephemeral | bool | `true` | Use the ephemeral postgresql chart by default |
| postgresql.sslMode | string | `"require"` | SSL mode for connecting to the database |
| postgresql.existingSecret | string | `"fwinsights-postgresql"` | Secret name to use for Postgres Password |
| postgresql.postgresqlUsername | string | `"postgres"` | Username to connect to Postgres with |
| postgresql.postgresqlDatabase | string | `"fairwinds_insights"` | Name of the Postgres Database |
| postgresql.service.port | int | `5432` | Port of the Postgres Database |
| postgresql.persistence.enabled | bool | `true` | Create Persistent Volume with Postgres |
| postgresql.replication.enabled | bool | `false` | Replicate Postgres data |
| postgresql.resources | object | `{"limits":{"cpu":1,"memory":"1Gi"},"requests":{"cpu":"75m","memory":"256Mi"}}` | Resources section for Postgres |
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
| minio.buckets | list | `[{"name":"reports","policy":"none"}]` | Create the following buckets for the newly installed Minio |
| minio.resources | object | `{"requests":{"cpu":"50m","memory":"256Mi"}}` | Resources for Minio |
| minio.nameOverride | string | `"fw-minio"` | nameOverride to shorten names of Minio resources |
| minio.persistence.enabled | bool | `true` | Create a persistent volume for Minio |
| migrateHealthScoreJob.resources.limits.cpu | string | `"500m"` |  |
| migrateHealthScoreJob.resources.limits.memory | string | `"1024Mi"` |  |
| migrateHealthScoreJob.resources.requests.cpu | string | `"80m"` |  |
| migrateHealthScoreJob.resources.requests.memory | string | `"128Mi"` |  |
| cronjobExecutor.image.repository | string | `"quay.io/fairwinds/kubectl"` |  |
| cronjobExecutor.image.tag | string | `"0.19"` |  |
| cronjobExecutor.resources.limits.cpu | string | `"100m"` |  |
| cronjobExecutor.resources.limits.memory | string | `"64Mi"` |  |
| cronjobExecutor.resources.requests.cpu | string | `"1m"` |  |
| cronjobExecutor.resources.requests.memory | string | `"3Mi"` |  |
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
