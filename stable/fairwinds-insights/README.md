# Fairwinds Insights

[Fairwinds Insights](https://insights.fairwinds.com) Software to automate, monitor, and enforce Kubernetes best practices.

## Installation
We recommend installing Fairwinds Insights in its own namespace and with a simple release name:

```
helm repo add fairwinds-stable https://charts.fairwinds.com/stable
helm install insights fairwinds-stable/fairwinds-insights --namespace fairwinds-insights
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| image.tag | string | `"main"` | Docker image tag |
| dashboardImage.repository | string | `"quay.io/fairwinds/insights-dashboard"` | Docker image repository for the front end |
| apiImage.repository | string | `"quay.io/fairwinds/insights-api"` | Docker image repository for the API server |
| migrationImage.repository | string | `"quay.io/fairwinds/insights-db-migration"` | Docker image repository for the database migration job |
| cronjobImage.repository | string | `"quay.io/fairwinds/insights-cronjob"` | Docker image repository for maintenance CronJobs. |
| options.agentChartTargetVersion | string | `"1.9.2"` | Which version of the Insights Agent is supported by this version of Fairwinds Insights |
| options.insightsSAASHost | string | `"https://insights.fairwinds.com"` | Do not change, this is the hostname that Fairwinds Insights will reach out to for license verification. |
| options.allowHTTPCookies | bool | `false` | Allow cookies to work over HTTP instead of requiring HTTPS. This generally should not be changed. |
| additionalEnvironmentVariables | string | `nil` | Additional Environment Variables to set on the Fairwinds Insights pods. |
| dashboard.pdb.enabled | bool | `false` | Create a pod disruption budget for the front end pods. |
| dashboard.pdb.minReplicas | int | `1` | How many replicas should always exist for the front end pods. |
| dashboard.hpa.enabled | bool | `false` | Create a horizontal pod autoscaler for the front end pods. |
| dashboard.hpa.min | int | `2` | Minimum number of replicas for the front end pods. |
| dashboard.hpa.max | int | `4` | Maximum number of replicas for the front end pods. |
| dashboard.hpa.cpuTarget | int | `50` | Target CPU utilization for the front end pods. |
| dashboard.resources | object | `{"limits":{"cpu":"1000m","memory":"1024Mi"},"requests":{"cpu":"250m","memory":"256Mi"}}` | Resources for the front end pods. |
| dashboard.nodeSelector | object | `{}` | Node Selector for the front end pods. |
| dashboard.tolerations | list | `[]` | Tolerations for the front end pods. |
| api.port | int | `8080` | Port for the API server to listen on. |
| api.pdb.enabled | bool | `false` | Create a pod disruption budget for the API server. |
| api.hpa.enabled | bool | `false` | Create a horizontal pod autoscaler for the API server. |
| api.hpa.min | int | `2` | Minimum number of replicas for the API server. |
| api.hpa.max | int | `4` | Maximum number of replicas for the API server. |
| api.hpa.cpuTarget | int | `50` | Target CPU utilization for the API server. |
| api.resources | object | `{"limits":{"cpu":"1000m","memory":"1024Mi"},"requests":{"cpu":"250m","memory":"256Mi"}}` | Resources for the API server. |
| api.nodeSelector | object | `{}` | Node Selector for the API server. |
| api.tolerations | list | `[]` | Tolerations for the API server. |
| dbMigration.resources | object | `{"limits":{"cpu":1,"memory":"1024Mi"},"requests":{"cpu":"80m","memory":"128Mi"}}` | Resources for the database migration job. |
| alertsCronjob.resources | object | `{"limits":{"cpu":"500m","memory":"1024Mi"},"requests":{"cpu":"80m","memory":"128Mi"}}` | Resources for the Slack/Datadog integrations |
| alertsCronjob.schedules | list | `[{"cron":"5/10 * * * *","interval":"10m","name":"realtime"},{"cron":"0 16 * * *","interval":"24h","name":"digest"}]` | CRON schedules for the Slack/Datadog integrations |
| aggregateCronjob.resources | object | `{"limits":{"cpu":"250m","memory":"512Mi"},"requests":{"cpu":"40m","memory":"32Mi"}}` | Resources for the Workload Metrics aggregation job. |
| aggregateCronjob.schedules | list | `[{"cron":"5 0/2 * * *","interval":"120m","name":"bi-hourly"}]` | CRON schedules for the Workload Metrics aggregation job. |
| emailCronjob.resources | object | `{"limits":{"cpu":"500m","memory":"1024Mi"},"requests":{"cpu":"80m","memory":"128Mi"}}` | Resources for the Action Items email job. |
| emailCronjob.schedules | list | `[{"cron":"0 16 * * 1","interval":"168h","name":"weekly-email"}]` | CRON schedules for the Action Items email job. |
| deleteOldActionItemsCronjob.resources | object | `{"limits":{"cpu":"500m","memory":"1024Mi"},"requests":{"cpu":"80m","memory":"128Mi"}}` | Resources for the delete old Action Items job. |
| deleteOldActionItemsCronjob.schedules | list | `[{"cron":"0 0 * * *","interval":"24h","name":"ai-cleanup"}]` | CRON schedules for the delete old Action Items job. |
| service.port | int | `80` | Port to be used for the API and Dashboard services. |
| sanitizedBranch | string | `nil` | Prefix to use on hostname. Generally not needed. |
| ingressApi.annotations | list | `[]` | Annotations to add to the API ingress. |
| ingress.enabled | bool | `false` | Install Ingress objects. |
| ingress.tls | bool | `true` | Enable TLS |
| ingress.hostedZones | list | `[]` | Hostnames to use for Ingress |
| ingress.annotations | list | `[]` | Annotations to add to the API and Dashboard ingresses. |
| ingressDashboard.annotations | list | `[]` | Annotations to add to the Dashboard ingress. |
| postgresql.ephemeral | bool | `true` | Use the ephemeral postgresql chart by default |
| postgresql.existingSecret | string | `"fwinsights-postgresql"` | Secret name to use for Postgres Password |
| postgresql.postgresqlUsername | string | `"postgres"` | Username to connect to Postgres with |
| postgresql.postgresqlDatabase | string | `"fairwinds_insights"` | Name of the Postgres Database |
| postgresql.randomReadOnlyPassword | bool | `true` | Create a read only user with a random password. |
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
