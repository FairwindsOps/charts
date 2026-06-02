{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "fairwinds-insights.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 52 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 52 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "fairwinds-insights.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 20 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 20 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s" .Release.Name | trunc 20 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "fairwinds-insights.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 52 | trimSuffix "-" -}}
{{- end -}}

{{- define "fairwinds-insights.sanitizedPrefix" -}}
{{- if .Values.sanitizedBranch -}}
{{- printf "%s." (.Values.sanitizedBranch | trunc (int .Values.sanitizedPrefixMaxLength | default 12) | trimSuffix "-") -}}
{{- end -}}
{{- end -}}

{{- define "fairwinds-insights.cronjobImageTag" -}}
{{- if .Values.cronjobImage.tag -}}
{{- .Values.cronjobImage.tag -}}
{{- else -}}
{{- .Values.image.tag | default .Chart.AppVersion -}}
{{- end -}}
{{- end -}}

{{- define "fairwinds-insights.apiImageTag" -}}
{{- if .Values.apiImage.tag -}}
{{- .Values.apiImage.tag -}}
{{- else -}}
{{- .Values.image.tag | default .Chart.AppVersion -}}
{{- end -}}
{{- end -}}

{{- define "fairwinds-insights.openApiImageTag" -}}
{{- if .Values.openApiImage.tag -}}
{{- .Values.openApiImage.tag -}}
{{- else -}}
{{- .Values.image.tag | default .Chart.AppVersion -}}
{{- end -}}
{{- end -}}

{{- define "fairwinds-insights.dashboardImageTag" -}}
{{- if .Values.dashboardImage.tag -}}
{{- .Values.dashboardImage.tag -}}
{{- else -}}
{{- .Values.image.tag | default .Chart.AppVersion -}}
{{- end -}}
{{- end -}}

{{- define "fairwinds-insights.migrationImageTag" -}}
{{- if .Values.migrationImage.tag -}}
{{- .Values.migrationImage.tag -}}
{{- else -}}
{{- .Values.image.tag | default .Chart.AppVersion -}}
{{- end -}}
{{- end -}}

{{- define "fairwinds-insights.postgresqlAppUsername" -}}
{{- .Values.postgresql.auth.username -}}
{{- end -}}

{{- define "fairwinds-insights.postgresqlMigrationUsername" -}}
{{- default (include "fairwinds-insights.postgresqlAppUsername" .) .Values.postgresql.auth.migrationUsername -}}
{{- end -}}

{{- define "fairwinds-insights.postgresqlMigrationSecret" -}}
{{- if eq (include "fairwinds-insights.postgresqlSplitAppMigration" .) "true" -}}
{{- .Values.postgresql.auth.existingMigrationSecret -}}
{{- else -}}
{{- .Values.postgresql.auth.existingSecret -}}
{{- end -}}
{{- end -}}

{{- define "fairwinds-insights.postgresqlOwnerRole" -}}
{{- default (include "fairwinds-insights.postgresqlMigrationUsername" .) .Values.postgresql.auth.ownerRole -}}
{{- end -}}

{{- define "fairwinds-insights.postgresqlUseOwnerRole" -}}
{{- if ne (include "fairwinds-insights.postgresqlOwnerRole" .) (include "fairwinds-insights.postgresqlMigrationUsername" .) -}}
true
{{- end -}}
{{- end -}}

{{- define "fairwinds-insights.postgresqlRoleBootstrap" -}}
{{- if or (eq (include "fairwinds-insights.postgresqlUseOwnerRole" .) "true") (ne (include "fairwinds-insights.postgresqlMigrationUsername" .) (include "fairwinds-insights.postgresqlAppUsername" .)) -}}
true
{{- end -}}
{{- end -}}

{{- define "fairwinds-insights.postgresqlSplitAppMigration" -}}
{{- if ne (include "fairwinds-insights.postgresqlMigrationUsername" .) (include "fairwinds-insights.postgresqlAppUsername" .) -}}
true
{{- end -}}
{{- end -}}

{{- define "fairwinds-insights.timescaleAppUsername" -}}
{{- .Values.timescale.postgresqlUsername -}}
{{- end -}}

{{- define "fairwinds-insights.timescaleMigrationUsername" -}}
{{- default (include "fairwinds-insights.timescaleAppUsername" .) .Values.timescale.auth.migrationUsername -}}
{{- end -}}

{{- define "fairwinds-insights.timescaleMigrationSecret" -}}
{{- if eq (include "fairwinds-insights.timescaleSplitAppMigration" .) "true" -}}
{{- .Values.timescale.auth.existingMigrationSecret -}}
{{- else -}}
{{- .Values.timescale.auth.existingSecret -}}
{{- end -}}
{{- end -}}

{{- define "fairwinds-insights.timescaleOwnerRole" -}}
{{- default (include "fairwinds-insights.timescaleMigrationUsername" .) .Values.timescale.auth.ownerRole -}}
{{- end -}}

{{- define "fairwinds-insights.timescaleUseOwnerRole" -}}
{{- if ne (include "fairwinds-insights.timescaleOwnerRole" .) (include "fairwinds-insights.timescaleMigrationUsername" .) -}}
true
{{- end -}}
{{- end -}}

{{- define "fairwinds-insights.timescaleRoleBootstrap" -}}
{{- if or (eq (include "fairwinds-insights.timescaleUseOwnerRole" .) "true") (ne (include "fairwinds-insights.timescaleMigrationUsername" .) (include "fairwinds-insights.timescaleAppUsername" .)) -}}
true
{{- end -}}
{{- end -}}

{{- define "fairwinds-insights.timescaleSplitAppMigration" -}}
{{- if ne (include "fairwinds-insights.timescaleMigrationUsername" .) (include "fairwinds-insights.timescaleAppUsername" .) -}}
true
{{- end -}}
{{- end -}}

{{/*
Unquoted PostgreSQL identifiers only (used in CNPG postInitSQL).
*/}}
{{- define "fairwinds-insights.assertPostgresIdentifier" -}}
{{- $id := . -}}
{{- if not (regexMatch "^[a-zA-Z_][a-zA-Z0-9_]*$" $id) -}}
{{- fail (printf "invalid PostgreSQL identifier %q: use letters, digits, and underscores only; must start with a letter or underscore" $id) -}}
{{- end -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "fairwinds-insights.labels" -}}
helm.sh/chart: {{ include "fairwinds-insights.chart" . }}
{{ include "fairwinds-insights.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{ if .Values.rok8sCIRef }}
app.kubernetes.io/rok8sCIRef: {{ .Values.rok8sCIRef }}
{{ end }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "fairwinds-insights.selectorLabels" -}}
app.kubernetes.io/name: {{ include "fairwinds-insights.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "secrets_certificate" -}}
"fwinsights-timescale-ca"
{{- end -}}

{{- define "secrets_credentials" -}}
"fwinsights-timescale"
{{- end -}}

{{/* TimescaleDB HA image ref; omit registry for standard Docker Hub form (timescale/timescaledb-ha:tag). */}}
{{- define "fairwinds-insights.timescaleImage" -}}
{{- $reg := .Values.timescale.image.registry | default "" | trim -}}
{{- $repo := required "timescale.image.repository is required" .Values.timescale.image.repository -}}
{{- $tag := required "timescale.image.tag is required" .Values.timescale.image.tag -}}
{{- if $reg -}}
{{- printf "%s/%s:%s" $reg $repo $tag -}}
{{- else -}}
{{- printf "%s:%s" $repo $tag -}}
{{- end -}}
{{- end -}}

{{/* Cluster-scoped CNPG catalog for TimescaleDB (required because Timescale image tags fail spec.imageName validation). */}}
{{- define "fairwinds-insights.timescaleClusterImageCatalog" -}}
{{- printf "%s-insights-timescale-catalog" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Names must stay in sync with the rustfs subchart's rustfs.fullname / rustfs.secretName / service metadata.name (.fullname-svc). */}}
{{- define "fairwinds-insights.rustfsFullname" -}}
{{- $r := .Values.rustfs | default dict }}
{{- if $r.fullnameOverride }}
{{- $r.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default "rustfs" $r.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "fairwinds-insights.rustfsCredentialsSecretName" -}}
{{- $existing := dig "secret" "existingSecret" "" (.Values.rustfs | default dict) }}
{{- if $existing }}
{{- $existing }}
{{- else }}
{{- printf "%s-secret" (include "fairwinds-insights.rustfsFullname" .) }}
{{- end }}
{{- end }}

{{- define "fairwinds-insights.rustfsServiceName" -}}
{{- printf "%s-svc" (include "fairwinds-insights.rustfsFullname" .) }}
{{- end }}

{{/* Base URL for the Insights API as seen by the MCP server (self-hosted vs SaaS). */}}
{{- define "fairwinds-insights.mcp.fairwindsApiBaseUrl" -}}
{{- if .Values.mcp.fairwindsApiBaseUrl -}}
{{- .Values.mcp.fairwindsApiBaseUrl -}}
{{- else if .Values.options.host -}}
{{- .Values.options.host -}}
{{- else if gt (len .Values.ingress.hostedZones) 0 -}}
{{- printf "https://%s%s" (include "fairwinds-insights.sanitizedPrefix" .) (index .Values.ingress.hostedZones 0) -}}
{{- else -}}
https://insights.fairwinds.com
{{- end -}}
{{- end -}}
