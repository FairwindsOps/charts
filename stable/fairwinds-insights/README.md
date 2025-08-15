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
| openApiImage.tag | string | `"v5.27.0"` | Overrides tag for the Open API server, defaults to image.tag |
| options.agentChartTargetVersion | string | `"4.7.0"` | Which version of the Insights Agent is supported by this version of Fairwinds Insights |
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
| options.ssoRequiredForAdminAPI | bool | `false` | Whether to require SSO for the admin API |
| cronjobOptions.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"privileged":false,"readOnlyRootFilesystem":true,"runAsNonRoot":true,"runAsUser":10324}` | Default security context for cronjobs |
| cronjobOptions.resources | object | `{"limits":{"cpu":"250m","memory":"512Mi"},"requests":{"cpu":"250m","memory":"512Mi"}}` | Default resources for cronjobs |
| cronjobs.action-item-filters-refresh | object | `{"command":"action_items_filters_refresher","schedule":"0/15 * * * *"}` | Options for the action-items filters refresher job. |
| cronjobs.action-items-statistics | object | `{"command":"action_items_statistics","schedule":"15 * * * *"}` | Options for the action item stats job |
| cronjobs.alerts-realtime | object | `{"command":"notifications_digest","interval":"10m","schedule":"5/10 * * * *"}` | Options for the realtime alerts job |
| cronjobs.benchmark | object | `{"command":"benchmark","schedule":""}` | Options for the benchmark job |
| cronjobs.update-tickets | object | `{"command":"update_tickets","includeGitHubSecret":true,"resources":{"limits":{"cpu":"500m","memory":"2Gi"},"requests":{"cpu":"500m","memory":"2Gi"}},"schedule":"0 * * * *"}` | Options for the update tickets job. |
| cronjobs.costs-update | object | `{"command":"cloud_costs_update","includeGitHubSecret":true,"resources":{"limits":{"cpu":"500m","memory":"2Gi"},"requests":{"cpu":"500m","memory":"2Gi"}},"schedule":"15 */3 * * *"}` | Options for the cloud costs update job |
| cronjobs.database-cleanup | object | `{"command":"database_cleanup","schedule":"0 0 * * *"}` | Options for the database cleanup job. |
| cronjobs.email | object | `{"command":"email_digest","schedule":""}` | Options for the email digest job. |
| cronjobs.hubspot | object | `{"command":"hubspot_sync","schedule":"","useReadReplica":true}` | Options for the hubspot job. |
| cronjobs.notifications-digest | object | `{"command":"notifications_digest","interval":"24h","schedule":"0 16 * * *"}` | Options for digest notifications job |
| cronjobs.resources-recommendations | object | `{"command":"resources_recommendations","resources":{"limits":{"cpu":1,"memory":"3Gi"},"requests":{"cpu":1,"memory":"3Gi"}},"schedule":"0 2 * * *"}` | Options for the resources recommendations job |
| cronjobs.saml | object | `{"command":"refresh_saml_metadata","schedule":"0 * * * *"}` | Options for the SAML sync job |
| cronjobs.slack-channels | object | `{"command":"slack_channels_local_refresher","schedule":"0/15 * * * *"}` | Options for the slack channels job. |
| cronjobs.trial-end | object | `{"command":"trial_end_downgrade","schedule":""}` | Options for the trial-end job. |
| cronjobs.move-health-scores-to-ts | object | `{"command":"move_resource_health_scores_to_ts","schedule":"*/30 * * * *"}` | Options for the move-health-scores-to-ts job. |
| cronjobs.image-vulns-refresh | object | `{"command":"image_vulnerabilities_refresher","schedule":"*/30 * * * *"}` | Options for the image-vulns-refresh job. |
| cronjobs.img-vulns-on-demand-refresh | object | `{"command":"image_vulnerabilities_on_demand_refresher","schedule":"*/2 * * * *"}` | Options for the image-vulnerabilities-on-demand-refresher |
| cronjobs.sync-action-items-iac-files | object | `{"command":"sync_action_items_iac_files","schedule":"0 * * * *"}` | Options for the sync-action-items-iac-files cronjob. |
| cronjobs.app-groups-cves-statistics | object | `{"command":"app_groups_cves_statistics","schedule":"0 9,21 * * *"}` | Options for the app_groups_cves_statistics cronjob. |
| cronjobs.cve-reports-email-sender | object | `{"command":"cve_reports_email_sender","schedule":"0 5 1 * *"}` | Options for the cve_reports_email_sender cronjob. |
| cronjobs.cluster-deletion | object | `{"command":"cluster_deletion","schedule":"*/15 * * * *"}` | Options for the cluster_deletion cronjob |
| cronjobs.refresh-jira-webhooks | object | `{"command":"refresh_jira_webhooks","schedule":"0 0 1,15 * *"}` | Options for the refresh_jira_webhooks cronjob |
| cronjobs.utmstack-integration | object | `{"command":"utmstack_integration","schedule":"*/5 * * * *"}` | Options for the utmstack_integration cronjob |
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
| dashboard.topologySpreadConstraints[0].maxSkew | int | `1` |  |
| dashboard.topologySpreadConstraints[0].topologyKey | string | `"topology.kubernetes.io/zone"` |  |
| dashboard.topologySpreadConstraints[0].whenUnsatisfiable | string | `"ScheduleAnyway"` |  |
| dashboard.topologySpreadConstraints[0].labelSelector.matchLabels."app.kubernetes.io/component" | string | `"dashboard"` |  |
| dashboard.topologySpreadConstraints[0].labelSelector.matchLabels."app.kubernetes.io/name" | string | `"fairwinds-insights"` |  |
| dashboard.topologySpreadConstraints[1].maxSkew | int | `1` |  |
| dashboard.topologySpreadConstraints[1].topologyKey | string | `"kubernetes.io/hostname"` |  |
| dashboard.topologySpreadConstraints[1].whenUnsatisfiable | string | `"ScheduleAnyway"` |  |
| dashboard.topologySpreadConstraints[1].labelSelector.matchLabels."app.kubernetes.io/component" | string | `"dashboard"` |  |
| dashboard.topologySpreadConstraints[1].labelSelector.matchLabels."app.kubernetes.io/name" | string | `"fairwinds-insights"` |  |
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
| api.topologySpreadConstraints[0].maxSkew | int | `1` |  |
| api.topologySpreadConstraints[0].topologyKey | string | `"topology.kubernetes.io/zone"` |  |
| api.topologySpreadConstraints[0].whenUnsatisfiable | string | `"ScheduleAnyway"` |  |
| api.topologySpreadConstraints[0].labelSelector.matchLabels."app.kubernetes.io/component" | string | `"api"` |  |
| api.topologySpreadConstraints[0].labelSelector.matchLabels."app.kubernetes.io/name" | string | `"fairwinds-insights"` |  |
| api.topologySpreadConstraints[1].maxSkew | int | `1` |  |
| api.topologySpreadConstraints[1].topologyKey | string | `"kubernetes.io/hostname"` |  |
| api.topologySpreadConstraints[1].whenUnsatisfiable | string | `"ScheduleAnyway"` |  |
| api.topologySpreadConstraints[1].labelSelector.matchLabels."app.kubernetes.io/component" | string | `"api"` |  |
| api.topologySpreadConstraints[1].labelSelector.matchLabels."app.kubernetes.io/name" | string | `"fairwinds-insights"` |  |
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
| openApi.topologySpreadConstraints[0].maxSkew | int | `1` |  |
| openApi.topologySpreadConstraints[0].topologyKey | string | `"topology.kubernetes.io/zone"` |  |
| openApi.topologySpreadConstraints[0].whenUnsatisfiable | string | `"ScheduleAnyway"` |  |
| openApi.topologySpreadConstraints[0].labelSelector.matchLabels."app.kubernetes.io/component" | string | `"open-api"` |  |
| openApi.topologySpreadConstraints[0].labelSelector.matchLabels."app.kubernetes.io/name" | string | `"fairwinds-insights"` |  |
| openApi.topologySpreadConstraints[1].maxSkew | int | `1` |  |
| openApi.topologySpreadConstraints[1].topologyKey | string | `"kubernetes.io/hostname"` |  |
| openApi.topologySpreadConstraints[1].whenUnsatisfiable | string | `"ScheduleAnyway"` |  |
| openApi.topologySpreadConstraints[1].labelSelector.matchLabels."app.kubernetes.io/component" | string | `"open-api"` |  |
| openApi.topologySpreadConstraints[1].labelSelector.matchLabels."app.kubernetes.io/name" | string | `"fairwinds-insights"` |  |
| openApi.ingress.enabled | bool | `true` | Enable the Open API ingress |
| openApi.service.type | string | `nil` | Service type for Open API server |
| dbMigration.resources | object | `{"limits":{"cpu":1,"memory":"1024Mi"},"requests":{"cpu":"80m","memory":"128Mi"}}` | Resources for the database migration job. |
| dbMigration.securityContext.runAsUser | int | `10324` | The user ID to run the database migration job under. |
| service.port | int | `80` | Port to be used for the API and Dashboard services. |
| service.type | string | `"ClusterIP"` | Service type for the API and Dashboard services |
| service.annotations | string | `nil` | Annotations for the services |
| sanitizedBranch | string | `nil` | Prefix to use on hostname. Generally not needed. |
| sanitizedPrefixMaxLength | int | `12` | Maximum length for hostname prefix. |
| ingress.enabled | bool | `false` | Enable Ingress |
| ingress.tls | bool | `true` | Enable TLS |
| ingress.hostedZones | list | `[]` | Hostnames to use for Ingress |
| ingress.annotations | object | `{}` | Annotations to add to the API and Dashboard ingresses. |
| ingress.starPaths | bool | `true` | Certain ingress controllers do pattern matches, others use prefixes. If `/*` doesn't work for your ingress, try setting this to false. |
| ingress.separate | bool | `false` | Create different Ingress objects for the API and dashboard - this allows them to have different annotations |
| ingress.extraPaths | object | `{}` | Adds additional path ie. Redirect path for ALB |
| postgresql.fullnameOverride | string | `"insights-postgresql"` |  |
| postgresql.postMigrate | bool | `false` | Set to `true` to run migrations after the upgrade |
| postgresql.image.registry | string | `"quay.io"` |  |
| postgresql.image.repository | string | `"fairwinds/postgres-partman"` |  |
| postgresql.image.tag | string | `"16.0"` |  |
| postgresql.ephemeral | bool | `true` | Use the ephemeral postgresql chart by default |
| postgresql.sslMode | string | `"require"` | SSL mode for connecting to the database |
| postgresql.tls | object | `{"certFilename":"tls.crt","certKeyFilename":"tls.key","certificatesSecret":"fwinsights-postgresql-ca","enabled":true}` | TLS mode for connecting to the database |
| postgresql.postgresqlHost | string | `"insights-postgresql"` |  |
| postgresql.auth.username | string | `"postgres"` |  |
| postgresql.auth.database | string | `"fairwinds_insights"` |  |
| postgresql.auth.existingSecret | string | `"fwinsights-postgresql"` |  |
| postgresql.auth.secretKeys.adminPasswordKey | string | `"postgresql-password"` |  |
| postgresql.primary.service.port | int | `5432` | Port of the Postgres Database |
| postgresql.primary.persistence.enabled | bool | `true` | Create Persistent Volume with Postgres |
| postgresql.primary.resources | object | `{"limits":{"cpu":1,"memory":"1Gi"},"requests":{"cpu":"75m","memory":"256Mi"}}` | Resources section for Postgres |
| postgresql.readReplica | object | `{"database":null,"host":null,"port":null,"sslMode":null,"username":null}` | Optional read replica configuration. Set cronjob `options.useReadReplica` to `true` to enable it |
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
| reportjob.topologySpreadConstraints[0].maxSkew | int | `1` |  |
| reportjob.topologySpreadConstraints[0].topologyKey | string | `"topology.kubernetes.io/zone"` |  |
| reportjob.topologySpreadConstraints[0].whenUnsatisfiable | string | `"ScheduleAnyway"` |  |
| reportjob.topologySpreadConstraints[0].labelSelector.matchLabels."app.kubernetes.io/component" | string | `"reportjob"` |  |
| reportjob.topologySpreadConstraints[0].labelSelector.matchLabels."app.kubernetes.io/name" | string | `"fairwinds-insights"` |  |
| reportjob.topologySpreadConstraints[1].maxSkew | int | `1` |  |
| reportjob.topologySpreadConstraints[1].topologyKey | string | `"kubernetes.io/hostname"` |  |
| reportjob.topologySpreadConstraints[1].whenUnsatisfiable | string | `"ScheduleAnyway"` |  |
| reportjob.topologySpreadConstraints[1].labelSelector.matchLabels."app.kubernetes.io/component" | string | `"reportjob"` |  |
| reportjob.topologySpreadConstraints[1].labelSelector.matchLabels."app.kubernetes.io/name" | string | `"fairwinds-insights"` |  |
| reportjob.terminationGracePeriodSeconds | int | `600` |  |
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
| automatedPullRequestJob.topologySpreadConstraints[0].maxSkew | int | `1` |  |
| automatedPullRequestJob.topologySpreadConstraints[0].topologyKey | string | `"topology.kubernetes.io/zone"` |  |
| automatedPullRequestJob.topologySpreadConstraints[0].whenUnsatisfiable | string | `"ScheduleAnyway"` |  |
| automatedPullRequestJob.topologySpreadConstraints[0].labelSelector.matchLabels."app.kubernetes.io/component" | string | `"automated-pr-job"` |  |
| automatedPullRequestJob.topologySpreadConstraints[0].labelSelector.matchLabels."app.kubernetes.io/name" | string | `"fairwinds-insights"` |  |
| automatedPullRequestJob.topologySpreadConstraints[1].maxSkew | int | `1` |  |
| automatedPullRequestJob.topologySpreadConstraints[1].topologyKey | string | `"kubernetes.io/hostname"` |  |
| automatedPullRequestJob.topologySpreadConstraints[1].whenUnsatisfiable | string | `"ScheduleAnyway"` |  |
| automatedPullRequestJob.topologySpreadConstraints[1].labelSelector.matchLabels."app.kubernetes.io/component" | string | `"automated-pr-job"` |  |
| automatedPullRequestJob.topologySpreadConstraints[1].labelSelector.matchLabels."app.kubernetes.io/name" | string | `"fairwinds-insights"` |  |
| repoScanJob.enabled | bool | `false` |  |
| repoScanJob.insightsCIVersion | string | `"5.9"` |  |
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
| repoScanJob.topologySpreadConstraints[0].maxSkew | int | `1` |  |
| repoScanJob.topologySpreadConstraints[0].topologyKey | string | `"topology.kubernetes.io/zone"` |  |
| repoScanJob.topologySpreadConstraints[0].whenUnsatisfiable | string | `"ScheduleAnyway"` |  |
| repoScanJob.topologySpreadConstraints[0].labelSelector.matchLabels."app.kubernetes.io/component" | string | `"repo-scan-job"` |  |
| repoScanJob.topologySpreadConstraints[0].labelSelector.matchLabels."app.kubernetes.io/name" | string | `"fairwinds-insights"` |  |
| repoScanJob.topologySpreadConstraints[1].maxSkew | int | `1` |  |
| repoScanJob.topologySpreadConstraints[1].topologyKey | string | `"kubernetes.io/hostname"` |  |
| repoScanJob.topologySpreadConstraints[1].whenUnsatisfiable | string | `"ScheduleAnyway"` |  |
| repoScanJob.topologySpreadConstraints[1].labelSelector.matchLabels."app.kubernetes.io/component" | string | `"repo-scan-job"` |  |
| repoScanJob.topologySpreadConstraints[1].labelSelector.matchLabels."app.kubernetes.io/name" | string | `"fairwinds-insights"` |  |
| temporal.enabled | bool | `false` |  |
| temporal.fullnameOverride | string | `"insights-temporal"` |  |
| temporal.cassandra.enabled | bool | `false` |  |
| temporal.prometheus.enabled | bool | `false` |  |
| temporal.elasticsearch.enabled | bool | `false` |  |
| temporal.grafana.enabled | bool | `false` |  |
| temporal.mysql.enabled | bool | `false` |  |
| temporal.postgresql.enabled | bool | `true` |  |
| temporal.server.replicaCount | int | `1` |  |
| temporal.server.config.logLevel | string | `"debug"` |  |
| temporal.server.config.namespaces.create | bool | `true` |  |
| temporal.server.config.namespaces.namespace[0].name | string | `"fwinsights"` |  |
| temporal.server.config.namespaces.namespace[0].retention | string | `"3d"` |  |
| temporal.server.config.persistence.default.driver | string | `"sql"` |  |
| temporal.server.config.persistence.default.sql.driver | string | `"postgres12"` |  |
| temporal.server.config.persistence.default.sql.database | string | `"temporal"` |  |
| temporal.server.config.persistence.default.sql.host | string | `"insights-postgresql"` |  |
| temporal.server.config.persistence.default.sql.port | int | `5432` |  |
| temporal.server.config.persistence.default.sql.user | string | `"postgres"` |  |
| temporal.server.config.persistence.default.sql.existingSecret | string | `"fwinsights-postgresql"` |  |
| temporal.server.config.persistence.default.sql.maxConns | int | `20` |  |
| temporal.server.config.persistence.default.sql.maxIdleConns | int | `20` |  |
| temporal.server.config.persistence.default.sql.maxConnLifetime | string | `"1h"` |  |
| temporal.server.config.persistence.default.sql.tls.enabled | bool | `true` |  |
| temporal.server.config.persistence.default.sql.tls.enableHostVerification | bool | `false` |  |
| temporal.server.config.persistence.default.sql.tls.certFile | string | `"/etc/temporal/tls/tls.crt"` |  |
| temporal.server.config.persistence.default.sql.tls.keyFile | string | `"/etc/temporal/tls/tls.key"` |  |
| temporal.server.config.persistence.visibility.driver | string | `"sql"` |  |
| temporal.server.config.persistence.visibility.sql.driver | string | `"postgres12"` |  |
| temporal.server.config.persistence.visibility.sql.database | string | `"temporal_visibility"` |  |
| temporal.server.config.persistence.visibility.sql.host | string | `"insights-postgresql"` |  |
| temporal.server.config.persistence.visibility.sql.port | int | `5432` |  |
| temporal.server.config.persistence.visibility.sql.user | string | `"postgres"` |  |
| temporal.server.config.persistence.visibility.sql.existingSecret | string | `"fwinsights-postgresql"` |  |
| temporal.server.config.persistence.visibility.sql.maxConns | int | `20` |  |
| temporal.server.config.persistence.visibility.sql.maxIdleConns | int | `20` |  |
| temporal.server.config.persistence.visibility.sql.maxConnLifetime | string | `"1h"` |  |
| temporal.server.config.persistence.visibility.sql.tls.enabled | bool | `true` |  |
| temporal.server.config.persistence.visibility.sql.tls.enableHostVerification | bool | `false` |  |
| temporal.server.config.persistence.visibility.sql.tls.certFile | string | `"/etc/temporal/tls/tls.crt"` |  |
| temporal.server.config.persistence.visibility.sql.tls.keyFile | string | `"/etc/temporal/tls/tls.key"` |  |
| temporal.server.additionalVolumes[0].name | string | `"secret-with-certs"` |  |
| temporal.server.additionalVolumes[0].secret.secretName | string | `"fwinsights-postgresql-ca"` |  |
| temporal.server.additionalVolumes[0].secret.defaultMode | int | `384` |  |
| temporal.server.additionalVolumeMounts[0].name | string | `"secret-with-certs"` |  |
| temporal.server.additionalVolumeMounts[0].mountPath | string | `"/etc/temporal/tls"` |  |
| temporal.server.additionalVolumeMounts[0].readOnly | bool | `true` |  |
