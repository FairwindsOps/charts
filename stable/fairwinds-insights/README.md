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
| dashboardImage.repository | string | `"us-docker.pkg.dev/fairwinds-ops/insights/insights-dashboard"` | Docker image repository for the front end |
| dashboardImage.tag | string | `nil` | Overrides tag for the dashboard, defaults to image.tag |
| apiImage.repository | string | `"us-docker.pkg.dev/fairwinds-ops/insights/insights-api"` | Docker image repository for the API server |
| apiImage.tag | string | `nil` | Overrides tag for the API server, defaults to image.tag |
| migrationImage.repository | string | `"us-docker.pkg.dev/fairwinds-ops/insights/insights-db-migration"` | Docker image repository for the database migration job |
| migrationImage.tag | string | `nil` | Overrides tag for the migration image, defaults to image.tag |
| cronjobImage.repository | string | `"us-docker.pkg.dev/fairwinds-ops/insights/insights-cronjob"` | Docker image repository for maintenance CronJobs. |
| cronjobImage.tag | string | `nil` | Overrides tag for the cronjob image, defaults to image.tag |
| openApiImage.repository | string | `"swaggerapi/swagger-ui"` | Docker image repository for the Open API server |
| openApiImage.tag | string | `"v5.32.4"` | Overrides tag for the Open API server, defaults to image.tag |
| options.agentChartTargetVersion | string | `"5.3.0"` | Which version of the Insights Agent is supported by this version of Fairwinds Insights |
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
| cronjobOptions.additionalEnvVars | list | `[{"name":"POSTGRES_MAX_IDLE_CONNS","value":"1"},{"name":"POSTGRES_MAX_OPEN_CONNS","value":"1"}]` | Default additional env vars for all cronjobs (overridden per cronjob by cronjobs.<name>.additionalEnvVars) |
| cronjobs.action-item-filters-refresh | object | `{"command":"action_items_filters_refresher","schedule":"0/15 * * * *"}` | Options for the action-items filters refresher job. |
| cronjobs.action-items-statistics | object | `{"command":"action_items_statistics","schedule":"15 * * * *"}` | Options for the action item stats job |
| cronjobs.benchmark | object | `{"command":"benchmark","schedule":""}` | Options for the benchmark job |
| cronjobs.update-tickets | object | `{"command":"update_tickets","includeGitHubSecret":true,"resources":{"limits":{"cpu":"500m","memory":"2Gi"},"requests":{"cpu":"500m","memory":"2Gi"}},"schedule":"0 * * * *"}` | Options for the update tickets job. |
| cronjobs.costs-update | object | `{"command":"cloud_costs_update","includeGitHubSecret":true,"resources":{"limits":{"cpu":"500m","memory":"2Gi"},"requests":{"cpu":"500m","memory":"2Gi"}},"schedule":"15 */3 * * *"}` | Options for the cloud costs update job |
| cronjobs.database-cleanup | object | `{"command":"database_cleanup","schedule":"0 0 * * *"}` | Options for the database cleanup job. |
| cronjobs.email | object | `{"command":"email_digest","schedule":""}` | Options for the email digest job. |
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
| api.additionalEnvVars[0].name | string | `"POSTGRES_MAX_IDLE_CONNS"` |  |
| api.additionalEnvVars[0].value | string | `"5"` |  |
| api.additionalEnvVars[1].name | string | `"POSTGRES_MAX_OPEN_CONNS"` |  |
| api.additionalEnvVars[1].value | string | `"15"` |  |
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
| mcp | object | `{"additionalEnvVars":[],"affinity":{},"automountServiceAccountToken":false,"deploymentAnnotations":{},"enabled":false,"envFrom":[],"extraVolumeMounts":[],"extraVolumes":[],"fairwindsApiBaseUrl":"","hpa":{"enabled":false,"max":3,"metrics":[{"resource":{"name":"cpu","target":{"averageUtilization":75,"type":"Utilization"}},"type":"Resource"},{"resource":{"name":"memory","target":{"averageUtilization":80,"type":"Utilization"}},"type":"Resource"}],"min":1},"image":{"pullPolicy":"Always","repository":"quay.io/fairwinds/insights-mcp-server","tag":"latest"},"ingress":{"enabled":false},"initContainers":[],"livenessProbe":{"failureThreshold":3,"initialDelaySeconds":15,"periodSeconds":20,"tcpSocket":{"port":"http"},"timeoutSeconds":5},"nodeSelector":{},"pdb":{"enabled":false,"minReplicas":1},"podAnnotations":{},"podLabels":{},"podSecurityContext":{"fsGroup":1001},"port":8080,"priorityClassName":"","readinessProbe":{"failureThreshold":3,"initialDelaySeconds":5,"periodSeconds":10,"tcpSocket":{"port":"http"},"timeoutSeconds":3},"replicas":1,"resources":{"limits":{"cpu":"500m","memory":"512Mi"},"requests":{"cpu":"250m","memory":"256Mi"}},"revisionHistoryLimit":10,"securityContext":{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"privileged":false,"readOnlyRootFilesystem":true,"runAsNonRoot":true,"runAsUser":1001},"serverType":"streamable","service":{"annotations":{},"nodePort":null,"port":null,"type":null},"strategy":{"rollingUpdate":{"maxSurge":1,"maxUnavailable":0},"type":"RollingUpdate"},"tolerations":[],"topologySpreadConstraints":[{"labelSelector":{"matchLabels":{"app.kubernetes.io/component":"mcp","app.kubernetes.io/name":"fairwinds-insights"}},"maxSkew":1,"topologyKey":"topology.kubernetes.io/zone","whenUnsatisfiable":"ScheduleAnyway"},{"labelSelector":{"matchLabels":{"app.kubernetes.io/component":"mcp","app.kubernetes.io/name":"fairwinds-insights"}},"maxSkew":1,"topologyKey":"kubernetes.io/hostname","whenUnsatisfiable":"ScheduleAnyway"}]}` | [Fairwinds Insights MCP server](https://quay.io/repository/fairwinds/insights-mcp-server) — Model Context Protocol bridge to the Insights API. **Disabled by default.**Transport `MCP_SERVER_TYPE` must be `sse` or `streamable` in-cluster (`stdio` is for local clients). Env vars and behavior follow the upstream server; the image defaults include `FAIRWINDS_API_BASE_URL` (override with `mcp.fairwindsApiBaseUrl` or rely on `options.host` / `ingress.hostedZones`). When `ingress.enabled` is true, `/mcp` is routed on the main Ingress to the MCP service. |
| mcp.enabled | bool | `false` | Deploy the Insights MCP server workload |
| mcp.image.repository | string | `"quay.io/fairwinds/insights-mcp-server"` | Container image repository |
| mcp.image.tag | string | `"latest"` | Image tag (`latest` matches the published default; pin a digest or version for production) |
| mcp.image.pullPolicy | string | `"Always"` | Image pull policy |
| mcp.replicas | int | `1` | Pod replica count (ignored at runtime when `hpa.enabled` is true) |
| mcp.serverType | string | `"streamable"` | `MCP_SERVER_TYPE`: `stdio` (local), `sse`, or `streamable` — use `sse` or `streamable` in Kubernetes |
| mcp.port | int | `8080` | `MCP_SERVER_PORT` / container listen port |
| mcp.fairwindsApiBaseUrl | string | `""` | `FAIRWINDS_API_BASE_URL` — Insights API base URL for the MCP server. If empty, uses `options.host`, else the first `ingress.hostedZones` with `https://`, else the SaaS default. |
| mcp.additionalEnvVars | list | `[]` | Extra environment variables for the MCP container (appended after built-in env) |
| mcp.envFrom | list | `[]` | Optional `envFrom` (ConfigMaps / Secrets) for bulk env injection |
| mcp.resources | object | `{"limits":{"cpu":"500m","memory":"512Mi"},"requests":{"cpu":"250m","memory":"256Mi"}}` | Container resources |
| mcp.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"privileged":false,"readOnlyRootFilesystem":true,"runAsNonRoot":true,"runAsUser":1001}` | Container security context (`mcp` image runs as UID 1001) |
| mcp.podSecurityContext | object | `{"fsGroup":1001}` | Pod-level security context |
| mcp.livenessProbe | object | `{"failureThreshold":3,"initialDelaySeconds":15,"periodSeconds":20,"tcpSocket":{"port":"http"},"timeoutSeconds":5}` | Liveness probe (TCP avoids hanging on SSE paths) |
| mcp.readinessProbe | object | `{"failureThreshold":3,"initialDelaySeconds":5,"periodSeconds":10,"tcpSocket":{"port":"http"},"timeoutSeconds":3}` | Readiness probe |
| mcp.extraVolumeMounts | list | `[]` | Mount extra volumes (e.g. custom CA) |
| mcp.initContainers | list | `[]` | Optional init containers |
| mcp.pdb.enabled | bool | `false` | PodDisruptionBudget for the MCP Deployment |
| mcp.pdb.minReplicas | int | `1` | Minimum available pods (map to PDB `minAvailable`) |
| mcp.hpa.enabled | bool | `false` | HorizontalPodAutoscaler for the MCP Deployment |
| mcp.service.type | string | `nil` | Service type (`ClusterIP`, `NodePort`, or `LoadBalancer`) |
| mcp.service.port | string | `nil` | Service port exposed to clients (targets the container `http` port) |
| mcp.service.annotations | object | `{}` | Service annotations (e.g. cloud LB internal annotations) |
| mcp.service.nodePort | string | `nil` | `nodePort` when `type` is `NodePort` |
| mcp.ingress.enabled | bool | `false` | Enable the MCP ingress |
| mcp.nodeSelector | object | `{}` | Node selector for MCP pods |
| mcp.tolerations | list | `[]` | Tolerations for MCP pods |
| mcp.affinity | object | `{}` | Affinity for MCP pods |
| mcp.podAnnotations | object | `{}` | Pod annotations |
| mcp.podLabels | object | `{}` | Extra labels on the pod template |
| mcp.deploymentAnnotations | object | `{}` | Annotations on the Deployment |
| mcp.priorityClassName | string | `""` | Priority class name |
| mcp.automountServiceAccountToken | bool | `false` | Disable service account token mount if the workload does not need the Kubernetes API |
| dbMigration.overrideHook | string | `""` | Override the Helm hook for the database migration job. |
| dbMigration.waitTimeout | int | `600` | Max seconds to wait for PostgreSQL and Timescale to be ready before migration runs before failing. 0 = no timeout. |
| dbMigration.resources | object | `{"limits":{"cpu":1,"memory":"1024Mi"},"requests":{"cpu":"80m","memory":"128Mi"}}` | Resources for the database migration job. |
| dbMigration.securityContext.runAsUser | int | `10324` | The user ID to run the database migration job under. |
| oneTimeMigration.resources | object | `{"limits":{"cpu":"500m","memory":"512Mi"},"requests":{"cpu":"100m","memory":"256Mi"}}` | Resources for the one time migration job. |
| oneTimeMigration.securityContext.runAsUser | int | `10324` | The user ID to run the migration job under. |
| oneTimeMigration.additionalEnv | list | `[{"name":"POSTGRES_MAX_IDLE_CONNS","value":"1"},{"name":"POSTGRES_MAX_OPEN_CONNS","value":"1"}]` | Additional environment variables for the one time migration job. |
| service.port | int | `80` | Port to be used for the API and Dashboard services. |
| service.type | string | `"NodePort"` | Service type for the API and Dashboard services |
| service.annotations | string | `nil` | Annotations for the services |
| sanitizedBranch | string | `nil` | Prefix to use on hostname. Generally not needed. |
| sanitizedPrefixMaxLength | int | `12` | Maximum length for hostname prefix. |
| ingress.enabled | bool | `false` | Enable Ingress |
| ingress.className | string | `""` | Ingress class name (e.g. nginx, traefik). When set, adds spec.ingressClassName to all Ingress resources. |
| ingress.tls | bool | `true` | Enable TLS |
| ingress.hostedZones | list | `[]` | Hostnames to use for Ingress |
| ingress.annotations | object | `{}` | Annotations to add to the API and Dashboard ingresses. |
| ingress.starPaths | bool | `true` | Certain ingress controllers do pattern matches, others use prefixes. If `/*` doesn't work for your ingress, try setting this to false. |
| ingress.separate | bool | `false` | Create different Ingress objects for the API and dashboard - this allows them to have different annotations |
| ingress.extraPaths | object | `{}` | Adds additional path ie. Redirect path for ALB |
| postgresql.postMigrate | bool | `false` | Set to `true` to run migrations after the install, upgrade |
| postgresql.image.registry | string | `"quay.io"` |  |
| postgresql.image.repository | string | `"fairwinds/postgres-partman"` |  |
| postgresql.image.tag | string | `"17.0"` |  |
| postgresql.ephemeral | bool | `true` | Use the ephemeral postgresql cluster by default |
| postgresql.operator | object | `{"clusterReadyTimeoutSeconds":600,"crds":{"create":true},"defaultVersion":"1.28.1","install":true,"version":"1.28.1","webhook":{"mutating":{"create":true},"validating":{"create":true}}}` | Install CloudNativePG operator |
| postgresql.operator.version | string | `"1.28.1"` | CloudNativePG operator version to install |
| postgresql.operator.defaultVersion | string | `"1.28.1"` | Fallback CloudNativePG operator version when version is "latest" but resolution from GitHub fails |
| postgresql.operator.webhook | object | `{"mutating":{"create":true},"validating":{"create":true}}` | CloudNativePG operator configuration |
| postgresql.sslMode | string | `"require"` | SSL mode for connecting to the database |
| postgresql.tls | object | `{"certFilename":"tls.crt","certKeyFilename":"tls.key","certificatesSecret":"fwinsights-postgresql-ca","enabled":true}` | TLS mode for connecting to the database |
| postgresql.postgresqlHost | string | `"insights-postgres-rw"` | Host for postgresql (CloudNativePG cluster name) |
| postgresql.port | int | `5432` |  |
| postgresql.storage | object | `{"size":"10Gi","storageClass":"standard"}` | Storage configuration for the PostgreSQL cluster |
| postgresql.resources | object | `{"limits":{"cpu":1,"memory":"1Gi"},"requests":{"cpu":"75m","memory":"256Mi"}}` | Resource configuration for the PostgreSQL cluster |
| postgresql.auth | object | `{"database":"fairwinds_insights","existingSecret":"fwinsights-postgresql","existingSuperUserSecret":"fwinsights-postgresql-superuser","externalSecret":{"annotations":{},"create":false,"data":[],"name":"fwinsights-postgresql-external","secretStoreRef":{"kind":"ClusterSecretStore","name":"fairwinds-vault-backend"}},"secretKeys":{"adminPasswordKey":"postgresql-password"},"username":"postgres"}` | Authentication configuration |
| postgresql.auth.externalSecret | object | `{"annotations":{},"create":false,"data":[],"name":"fwinsights-postgresql-external","secretStoreRef":{"kind":"ClusterSecretStore","name":"fairwinds-vault-backend"}}` | ExternalSecret configuration for PostgreSQL credentials. NOTE: the application does NOT use this Secret yet — it still reads from `auth.existingSecret`. This lets you verify the ExternalSecret syncs correctly before cutting over. To cut over: set `auth.existingSecret` to the externalSecret `name` and remove the old manually-managed Secret. |
| postgresql.auth.externalSecret.create | bool | `false` | When true (and `postgresql.ephemeral` is false), provisions an ExternalSecret and a corresponding Secret. |
| postgresql.auth.externalSecret.name | string | `"fwinsights-postgresql-external"` | Name of the ExternalSecret resource and the Secret it generates. |
| postgresql.auth.externalSecret.secretStoreRef | object | `{"kind":"ClusterSecretStore","name":"fairwinds-vault-backend"}` | SecretStore reference |
| postgresql.auth.externalSecret.annotations | object | `{}` | Extra annotations on the ExternalSecret resource (e.g. argocd.argoproj.io/sync-wave) |
| postgresql.auth.externalSecret.data | list | `[]` | ExternalSecret spec.data entries (each must have `secretKey` and `remoteRef` with `key` + `property`) |
| postgresql.parameters | object | `{"checkpoint_completion_target":"0.9","default_statistics_target":"100","effective_cache_size":"1GB","effective_io_concurrency":"200","maintenance_work_mem":"64MB","max_connections":"100","max_parallel_maintenance_workers":"2","max_parallel_workers":"8","max_parallel_workers_per_gather":"2","max_wal_size":"4GB","max_worker_processes":"8","min_wal_size":"1GB","password_encryption":"scram-sha-256","random_page_cost":"1.1","shared_buffers":"256MB","wal_buffers":"16MB","work_mem":"4MB"}` | PostgreSQL configuration parameters |
| postgresql.readReplica | object | `{"database":null,"host":null,"port":null,"sslMode":null,"username":null}` | Optional read replica configuration. Set cronjob `options.useReadReplica` to `true` to enable it |
| encryption.aes.cypherKey | string | `nil` |  |
| timescale.ephemeral | bool | `true` | Provision TimescaleDB with CloudNativePG in-cluster (same pattern as `postgresql.ephemeral`). Breaking change: the legacy timescaledb-single subchart is no longer part of this chart. |
| timescale.sslMode | string | `"require"` | SSL mode for connecting to the database |
| timescale.postgresqlHost | string | `"insights-timescale-rw"` | Host for Timescale (CloudNativePG read-write service) |
| timescale.postgresqlUsername | string | `"postgres"` | Username to connect to Timescale with |
| timescale.postgresqlDatabase | string | `"postgres"` | Name of the Postgres database |
| timescale.password | string | `""` | App user password for ephemeral CNPG (random if unset) |
| timescale.superuserpassword | string | `""` | Superuser password for ephemeral CNPG (random if unset) |
| timescale.image.registry | string | `""` | Optional registry prefix; leave empty for Docker Hub short form `timescale/timescaledb-ha:tag` |
| timescale.image.repository | string | `"timescale/timescaledb-ha"` |  |
| timescale.image.tag | string | `"pg17.9-ts2.25.1-all"` |  |
| timescale.imageCatalog | object | `{"major":17}` | PostgreSQL major version for ClusterImageCatalog + imageCatalogRef (must match the image) |
| timescale.postgresUID | int | `1000` | Container UID/GID for Timescale HA image (CNPG; often 1000 for timescaledb-ha) |
| timescale.postgresGID | int | `1000` |  |
| timescale.sharedPreloadLibraries | list | `["timescaledb"]` | Libraries loaded at server start; required before bootstrap postInitSQL can run `CREATE EXTENSION timescaledb` (see CloudNativePG Timescale examples). |
| timescale.parameters | object | `{"max_connections":"100"}` | PostgreSQL parameters for the Timescale CNPG cluster (`shared_preload_libraries` is set via sharedPreloadLibraries above) |
| timescale.storage.size | string | `"10Gi"` |  |
| timescale.storage.storageClass | string | `"standard"` |  |
| timescale.auth.existingSecret | string | `"fwinsights-timescale"` |  |
| timescale.auth.existingSuperUserSecret | string | `"fwinsights-timescale-superuser"` |  |
| timescale.auth.secretKeys.adminPasswordKey | string | `"postgresql-password"` |  |
| timescale.secrets.certificateSecretName | string | `"fwinsights-timescale-ca"` |  |
| timescale.secrets.credentialsSecretName | string | `"fwinsights-timescale"` |  |
| timescale.service.primary.port | int | `5432` |  |
| timescale.loadBalancer.enabled | bool | `false` |  |
| timescale.resources.limits.cpu | int | `1` |  |
| timescale.resources.limits.memory | string | `"1Gi"` |  |
| timescale.resources.requests.cpu | string | `"500m"` |  |
| timescale.resources.requests.memory | string | `"512Mi"` |  |
| email.strategy | string | `"memory"` | How to send emails, valid values include memory, ses, and smtp |
| email.sender | string | `nil` | Email address that emails will come from |
| email.recipient | string | `nil` | Email address to send notifications of new user signups. |
| email.smtpHost | string | `nil` | Host for SMTP strategy |
| email.smtpUsername | string | `nil` | Username for SMTP strategy |
| email.smtpPort | string | `nil` | Port for SMTP strategy |
| email.awsRegion | string | `nil` | Region for SES strategy, AWS_ACCESS_KEY_ID, and AWS_SECRET_ACCESS_KEY will need to be provided in the fwinsights-secrets secret. |
| reportStorage.strategy | string | `"rustfs"` | How to store report files: `rustfs` (in-cluster RustFS or external S3-compatible API via `s3Endpoint`; chart sets `REPORT_STORAGE_S3_*` and `REPORT_STORAGE_STRATEGY=rustfs` per Insights `pkg/files/s3.go`), `s3` (AWS S3 via default SDK credentials when no in-cluster RustFS / no custom endpoint), or `local` |
| reportStorage.bucket | string | `"reports"` | Bucket name for rustfs, s3, or local |
| reportStorage.region | string | `"us-east-1"` | Region for REPORT_STORAGE_REGION (AWS SDK / S3-compatible clients) |
| reportStorage.s3Endpoint | string | `nil` | Full URL for S3-compatible API when strategy is `rustfs` and RustFS runs outside the cluster (required when `rustfs.install` is false) |
| reportStorage.s3CredentialsSecret | string | `nil` | Secret with `accessKeyId` and `secretAccessKey` when strategy is `rustfs` and `rustfs.install` is false (external S3-compatible storage) |
| reportStorage.fixturesDir | string | `nil` | Directory to store files in for local. |
| rustfs.install | bool | `true` |  |
| rustfs.nameOverride | string | `"fw-rustfs"` |  |
| rustfs.replicaCount | int | `1` |  |
| rustfs.mode.standalone.enabled | bool | `true` |  |
| rustfs.mode.distributed.enabled | bool | `false` |  |
| rustfs.ingress.enabled | bool | `false` |  |
| rustfs.affinity.podAntiAffinity.enabled | bool | `false` |  |
| rustfs.service.endpoint.port | int | `9000` |  |
| rustfs.storageclass.name | string | `""` |  |
| rustfs.storageclass.dataStorageSize | string | `"50Gi"` |  |
| rustfs.storageclass.logStorageSize | string | `"1Gi"` |  |
| rustfs.resources.requests.cpu | string | `"50m"` |  |
| rustfs.resources.requests.memory | string | `"256Mi"` |  |
| rustfs.createBucketJob.enabled | bool | `true` |  |
| rustfs.createBucketJob.repository | string | `"amazon/aws-cli"` |  |
| rustfs.createBucketJob.tag | string | `"2.34.31"` |  |
| migrateHealthScoreJob.resources.limits.cpu | string | `"500m"` |  |
| migrateHealthScoreJob.resources.limits.memory | string | `"1024Mi"` |  |
| migrateHealthScoreJob.resources.requests.cpu | string | `"80m"` |  |
| migrateHealthScoreJob.resources.requests.memory | string | `"128Mi"` |  |
| cronjobExecutor.image.repository | string | `"alpine/kubectl"` |  |
| cronjobExecutor.image.tag | string | `"1.35.4"` |  |
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
| reportjob.appGroupHealthForReportWorkflowEnabled | bool | `false` |  |
| reportjob.additionalEnvVars | list | `[]` |  |
| outboxWorker | object | `{"additionalEnvVars":[],"affinity":null,"annotations":{},"args":[],"command":["outbox_worker"],"enabled":true,"image":{"repository":"","tag":""},"imagePullPolicy":"Always","initContainers":[],"nodeSelector":{},"podAnnotations":{},"priorityClassName":"","replicas":1,"resources":{"limits":{"cpu":"100m","memory":"128Mi"},"requests":{"cpu":"100m","memory":"128Mi"}},"securityContext":{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"privileged":false,"readOnlyRootFilesystem":true,"runAsNonRoot":true,"runAsUser":10324},"terminationGracePeriodSeconds":600,"tolerations":[],"topologySpreadConstraints":[],"useReadReplica":false,"volumeMounts":[],"volumes":[]}` | Deploy the outbox worker |
| outboxWorker.enabled | bool | `true` | Enable the outbox-worker Deployment |
| outboxWorker.replicas | int | `1` | Number of replicas |
| outboxWorker.image.repository | string | `""` | Overrides `apiImage.repository` when set (non-empty) |
| outboxWorker.image.tag | string | `""` | Overrides the API image tag when set (non-empty); otherwise uses `fairwinds-insights.apiImageTag` |
| outboxWorker.imagePullPolicy | string | `"Always"` | Container image pull policy |
| outboxWorker.command | list | `["outbox_worker"]` | Container entrypoint command (Insights API worker), e.g. same style as `report_job` |
| outboxWorker.args | list | `[]` | Optional args for the container |
| outboxWorker.useReadReplica | bool | `false` | When true, `env` uses the PostgreSQL read replica settings where applicable |
| outboxWorker.resources | object | `{"limits":{"cpu":"100m","memory":"128Mi"},"requests":{"cpu":"100m","memory":"128Mi"}}` | Resource requests and limits for the outbox worker container |
| outboxWorker.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"privileged":false,"readOnlyRootFilesystem":true,"runAsNonRoot":true,"runAsUser":10324}` | Container security context for the outbox worker |
| outboxWorker.additionalEnvVars | list | `[]` | Extra environment variables for the outbox worker container |
| outboxWorker.nodeSelector | object | `{}` | nodeSelector for the outbox worker pod |
| outboxWorker.tolerations | list | `[]` | Tolerations for the outbox worker pod |
| outboxWorker.topologySpreadConstraints | list | `[]` | Topology spread constraints for the outbox worker pod |
| outboxWorker.affinity | string | `nil` | Optional pod affinity (set to a mapping to enable) |
| outboxWorker.volumes | list | `[]` | Extra volumes for the pod (e.g. emptyDir). No GitHub secret volume is added by default. |
| outboxWorker.volumeMounts | list | `[]` | Volume mounts matching `outboxWorker.volumes` |
| outboxWorker.initContainers | list | `[]` | Optional init containers |
| outboxWorker.terminationGracePeriodSeconds | int | `600` | Pod termination grace period (seconds) |
| outboxWorker.priorityClassName | string | `""` | Optional priority class name for the pod |
| outboxWorker.annotations | object | `{}` | Extra annotations on the Deployment (merged with Polaris annotations) |
| outboxWorker.podAnnotations | object | `{}` | Extra annotations on the pod template |
| temporalDeploymentDefaults | object | `{"additionalEnv":[],"args":[],"hpa":{"enabled":true,"max":4,"metrics":[],"min":2},"pdb":{"enabled":false,"minAvailable":1},"rbac":{"enabled":false,"serviceAccount":{"annotations":{}}},"resources":{"limits":{"cpu":"1000m","memory":"1024Mi"},"requests":{"cpu":"500m","memory":"512Mi"}},"securityContext":{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"privileged":false,"readOnlyRootFilesystem":true,"runAsNonRoot":true,"runAsUser":10324},"tolerations":[],"topologySpreadConstraints":[],"useReadReplica":false,"volumeMounts":[{"mountPath":"/var/run/secrets/github","name":"secrets"}],"volumes":[{"name":"secrets","secret":{"optional":true,"secretName":"github-secrets"}}]}` | Default options for temporal deployments |
| temporalDeploymentDefaults.rbac.serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| temporalDeployments | object | `{"delete-org-cluster-worker":{"additionalEnv":[{"name":"POSTGRES_MAX_IDLE_CONNS","value":"2"},{"name":"POSTGRES_MAX_OPEN_CONNS","value":"2"}],"args":[],"command":"delete_organization_and_cluster_worker","enabled":true,"hpa":{"max":1,"metrics":[],"min":1},"pdb":{"enabled":false},"resources":{"limits":{"cpu":"800m","memory":"1024Mi"},"requests":{"cpu":"200m","memory":"256Mi"}},"tolerations":[],"topologySpreadConstraints":[{"labelSelector":{"matchLabels":{"app.kubernetes.io/component":"delete-org-cluster-worker","app.kubernetes.io/name":"fairwinds-insights"}},"maxSkew":1,"topologyKey":"topology.kubernetes.io/zone","whenUnsatisfiable":"ScheduleAnyway"},{"labelSelector":{"matchLabels":{"app.kubernetes.io/component":"delete-org-cluster-worker","app.kubernetes.io/name":"fairwinds-insights"}},"maxSkew":1,"topologyKey":"kubernetes.io/hostname","whenUnsatisfiable":"ScheduleAnyway"}]},"general-worker":{"additionalEnv":[{"name":"POSTGRES_MAX_IDLE_CONNS","value":"3"},{"name":"POSTGRES_MAX_OPEN_CONNS","value":"6"}],"args":[],"command":"general_worker","enabled":true,"hpa":{"max":2,"metrics":[],"min":2},"pdb":{"enabled":false},"resources":{"limits":{"cpu":"800m","memory":"1024Mi"},"requests":{"cpu":"200m","memory":"256Mi"}},"tolerations":[],"topologySpreadConstraints":[{"labelSelector":{"matchLabels":{"app.kubernetes.io/component":"general-worker","app.kubernetes.io/name":"fairwinds-insights"}},"maxSkew":1,"topologyKey":"topology.kubernetes.io/zone","whenUnsatisfiable":"ScheduleAnyway"},{"labelSelector":{"matchLabels":{"app.kubernetes.io/component":"general-worker","app.kubernetes.io/name":"fairwinds-insights"}},"maxSkew":1,"topologyKey":"kubernetes.io/hostname","whenUnsatisfiable":"ScheduleAnyway"}]},"github-worker":{"additionalEnv":[{"name":"POSTGRES_MAX_IDLE_CONNS","value":"2"},{"name":"POSTGRES_MAX_OPEN_CONNS","value":"2"},{"name":"INSIGHTS_CI_IMAGE_VERSION","value":"6.2"}],"args":[],"command":"github_worker","enabled":true,"hpa":{"max":2,"metrics":[],"min":2},"pdb":{"enabled":false},"rbac":{"enabled":true,"rules":[{"apiGroups":["batch"],"resources":["jobs"],"verbs":["get","create","delete"]},{"apiGroups":[""],"resources":["pods/log"],"verbs":["get"]},{"apiGroups":[""],"resources":["pods"],"verbs":["list","get"]},{"apiGroups":[""],"resources":["events"],"verbs":["list","get"]},{"apiGroups":[""],"resources":["secrets","configmaps"],"verbs":["create","delete"]}]},"resources":{"limits":{"cpu":"400m","memory":"512Mi"},"requests":{"cpu":"200m","memory":"256Mi"}},"tolerations":[],"topologySpreadConstraints":[{"labelSelector":{"matchLabels":{"app.kubernetes.io/component":"github-worker","app.kubernetes.io/name":"fairwinds-insights"}},"maxSkew":1,"topologyKey":"topology.kubernetes.io/zone","whenUnsatisfiable":"ScheduleAnyway"},{"labelSelector":{"matchLabels":{"app.kubernetes.io/component":"github-worker","app.kubernetes.io/name":"fairwinds-insights"}},"maxSkew":1,"topologyKey":"kubernetes.io/hostname","whenUnsatisfiable":"ScheduleAnyway"}]},"report-job-worker":{"additionalEnv":[{"name":"POSTGRES_MAX_IDLE_CONNS","value":"3"},{"name":"POSTGRES_MAX_OPEN_CONNS","value":"6"},{"name":"ENABLE_APP_GROUP_HEALTH_FOR_REPORT_WORKFLOW","value":"false"}],"args":[],"command":"report_job_worker","enabled":true,"hpa":{"max":6,"metrics":[],"min":2},"pdb":{"enabled":false},"resources":{"limits":{"cpu":"800m","memory":"1024Mi"},"requests":{"cpu":"200m","memory":"256Mi"}},"tolerations":[],"topologySpreadConstraints":[{"labelSelector":{"matchLabels":{"app.kubernetes.io/component":"report-job-worker","app.kubernetes.io/name":"fairwinds-insights"}},"maxSkew":1,"topologyKey":"topology.kubernetes.io/zone","whenUnsatisfiable":"ScheduleAnyway"},{"labelSelector":{"matchLabels":{"app.kubernetes.io/component":"report-job-worker","app.kubernetes.io/name":"fairwinds-insights"}},"maxSkew":1,"topologyKey":"kubernetes.io/hostname","whenUnsatisfiable":"ScheduleAnyway"}]}}` | Temporal worker deployments |
| temporalSchedulers | list | `[]` | Temporal workflow schedules (created via CLI on install/upgrade). Empty by default. Each schedule is created or updated idempotently. Input will be passed to the workflow as a JSON object. Example: temporalSchedulers:   - name: my-report-schedule     workflowType: MyReportWorkflow     taskQueue: my-task-queue     cron: "0 * 1 * *"     overlapPolicy: Skip     input:       RecipientEmails:         - user1@example.com         - user2@example.com |
| temporalSchedulersJob | object | `{"apiKey":{"existingSecret":"","existingSecretKey":"api-key"},"image":{"repository":"temporalio/admin-tools","tag":"1.30.4.1"},"resources":{"limits":{"cpu":"200m","memory":"256Mi"},"requests":{"cpu":"50m","memory":"128Mi"}},"tls":{"caFilename":"ca.crt","certFilename":"tls.crt","disableHostVerification":false,"enabled":false,"existingSecret":"temporal-frontend-client-certs","keyFilename":"tls.key","serverName":""}}` | Job that creates/updates Temporal schedules from temporalSchedulers |
| temporalSchedulersJob.tls.disableHostVerification | bool | `false` | Disable host verification if using internal cluster connections where cert CN/SAN doesn't match service DNS |
| temporal.hostPort | string | `"insights-temporal-frontend:7233"` |  |
| temporal.namespace | string | `"fwinsights"` |  |
| temporal.enabled | bool | `true` |  |
| temporal.fullnameOverride | string | `"insights-temporal"` |  |
| temporal.schema.useHelmHooks | bool | `false` |  |
| temporal.schema.securityContext.fsGroup | int | `1000` |  |
| temporal.schema.securityContext.runAsUser | int | `1000` |  |
| temporal.shims.dockerize | bool | `false` |  |
| temporal.shims.elasticsearchTool | bool | `false` |  |
| temporal.server.replicaCount | int | `1` |  |
| temporal.server.config.namespaces.create | bool | `true` |  |
| temporal.server.config.namespaces.namespace[0].name | string | `"fwinsights"` |  |
| temporal.server.config.namespaces.namespace[0].retention | string | `"3d"` |  |
| temporal.server.config.persistence.defaultStore | string | `"default"` |  |
| temporal.server.config.persistence.visibilityStore | string | `"visibility"` |  |
| temporal.server.config.persistence.numHistoryShards | int | `512` |  |
| temporal.server.config.persistence.datastores.default.sql.createDatabase | bool | `true` |  |
| temporal.server.config.persistence.datastores.default.sql.manageSchema | bool | `true` |  |
| temporal.server.config.persistence.datastores.default.sql.pluginName | string | `"postgres12"` |  |
| temporal.server.config.persistence.datastores.default.sql.driverName | string | `"postgres12"` |  |
| temporal.server.config.persistence.datastores.default.sql.databaseName | string | `"temporal"` |  |
| temporal.server.config.persistence.datastores.default.sql.connectAddr | string | `"insights-postgres-rw:5432"` |  |
| temporal.server.config.persistence.datastores.default.sql.connectProtocol | string | `"tcp"` |  |
| temporal.server.config.persistence.datastores.default.sql.user | string | `"postgres"` |  |
| temporal.server.config.persistence.datastores.default.sql.existingSecret | string | `"fwinsights-postgresql"` |  |
| temporal.server.config.persistence.datastores.default.sql.secretKey | string | `"password"` |  |
| temporal.server.config.persistence.datastores.default.sql.maxConns | int | `5` |  |
| temporal.server.config.persistence.datastores.default.sql.maxIdleConns | int | `3` |  |
| temporal.server.config.persistence.datastores.default.sql.maxConnLifetime | string | `"1h"` |  |
| temporal.server.config.persistence.datastores.default.sql.tls.enabled | bool | `true` |  |
| temporal.server.config.persistence.datastores.default.sql.tls.enableHostVerification | bool | `false` |  |
| temporal.server.config.persistence.datastores.default.sql.tls.certFile | string | `"/etc/temporal/tls/tls.crt"` |  |
| temporal.server.config.persistence.datastores.default.sql.tls.keyFile | string | `"/etc/temporal/tls/tls.key"` |  |
| temporal.server.config.persistence.datastores.visibility.sql.createDatabase | bool | `true` |  |
| temporal.server.config.persistence.datastores.visibility.sql.manageSchema | bool | `true` |  |
| temporal.server.config.persistence.datastores.visibility.sql.pluginName | string | `"postgres12"` |  |
| temporal.server.config.persistence.datastores.visibility.sql.driverName | string | `"postgres12"` |  |
| temporal.server.config.persistence.datastores.visibility.sql.databaseName | string | `"temporal_visibility"` |  |
| temporal.server.config.persistence.datastores.visibility.sql.connectAddr | string | `"insights-postgres-rw:5432"` |  |
| temporal.server.config.persistence.datastores.visibility.sql.connectProtocol | string | `"tcp"` |  |
| temporal.server.config.persistence.datastores.visibility.sql.user | string | `"postgres"` |  |
| temporal.server.config.persistence.datastores.visibility.sql.existingSecret | string | `"fwinsights-postgresql"` |  |
| temporal.server.config.persistence.datastores.visibility.sql.secretKey | string | `"password"` |  |
| temporal.server.config.persistence.datastores.visibility.sql.maxConns | int | `5` |  |
| temporal.server.config.persistence.datastores.visibility.sql.maxIdleConns | int | `3` |  |
| temporal.server.config.persistence.datastores.visibility.sql.maxConnLifetime | string | `"1h"` |  |
| temporal.server.config.persistence.datastores.visibility.sql.tls.enabled | bool | `true` |  |
| temporal.server.config.persistence.datastores.visibility.sql.tls.enableHostVerification | bool | `false` |  |
| temporal.server.config.persistence.datastores.visibility.sql.tls.certFile | string | `"/etc/temporal/tls/tls.crt"` |  |
| temporal.server.config.persistence.datastores.visibility.sql.tls.keyFile | string | `"/etc/temporal/tls/tls.key"` |  |
| temporal.server.additionalVolumes[0].name | string | `"secret-with-certs"` |  |
| temporal.server.additionalVolumes[0].secret.secretName | string | `"fwinsights-postgresql-ca"` |  |
| temporal.server.additionalVolumes[0].secret.defaultMode | int | `384` |  |
| temporal.server.additionalVolumeMounts[0].name | string | `"secret-with-certs"` |  |
| temporal.server.additionalVolumeMounts[0].mountPath | string | `"/etc/temporal/tls"` |  |
| temporal.server.additionalVolumeMounts[0].readOnly | bool | `true` |  |
| temporal.admintools.additionalVolumes[0].name | string | `"secret-with-certs"` |  |
| temporal.admintools.additionalVolumes[0].secret.secretName | string | `"fwinsights-postgresql-ca"` |  |
| temporal.admintools.additionalVolumes[0].secret.defaultMode | int | `384` |  |
| temporal.admintools.additionalVolumeMounts[0].name | string | `"secret-with-certs"` |  |
| temporal.admintools.additionalVolumeMounts[0].mountPath | string | `"/etc/temporal/tls"` |  |
| temporal.admintools.additionalVolumeMounts[0].readOnly | bool | `true` |  |
