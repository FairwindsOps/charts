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

{{- define "fairwinds-insights.api.grpcEnabled" -}}
{{- .Values.api.grpc.enabled -}}
{{- end -}}

{{- define "fairwinds-insights.api.grpcListenAddress" -}}
{{- if .Values.api.grpc.address -}}
{{- .Values.api.grpc.address -}}
{{- else -}}
{{- printf ":%d" (int .Values.api.grpc.port) -}}
{{- end -}}
{{- end -}}

{{- define "fairwinds-insights.api.grpcIngressHostname" -}}
{{- if gt (len .Values.ingress.hostedZones) 0 -}}
{{- $zone := index .Values.ingress.hostedZones 0 -}}
{{- if .Values.sanitizedBranch -}}
{{- $branch := .Values.sanitizedBranch | trunc (int .Values.sanitizedPrefixMaxLength | default 12) | trimSuffix "-" -}}
{{- printf "grpc-%s.%s" $branch $zone -}}
{{- else -}}
{{- printf "grpc.%s" $zone -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "fairwinds-insights.api.grpcIngressGroupName" -}}
{{- if .Values.api.grpc.ingress.groupName -}}
{{- .Values.api.grpc.ingress.groupName -}}
{{- else if index .Values.ingress.annotations "alb.ingress.kubernetes.io/group.name" -}}
{{- printf "%s-grpc" (index .Values.ingress.annotations "alb.ingress.kubernetes.io/group.name") -}}
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

{{- define "fairwinds-insights.postgresqlSecretName" -}}
{{- $ext := .Values.postgresql.auth.externalSecret | default dict -}}
{{- if .Values.postgresql.auth.existingSecret -}}
{{- .Values.postgresql.auth.existingSecret -}}
{{- else if and $ext.create $ext.targetName -}}
{{- $ext.targetName -}}
{{- else -}}
fwinsights-postgresql
{{- end -}}
{{- end -}}

{{- define "fairwinds-insights.postgresqlSuperUserSecretName" -}}
{{- if .Values.postgresql.auth.existingSuperUserSecret -}}
{{- .Values.postgresql.auth.existingSuperUserSecret -}}
{{- else -}}
fwinsights-postgresql-superuser
{{- end -}}
{{- end -}}

{{- define "fairwinds-insights.postgresqlMigrationSecret" -}}
{{- $ext := .Values.postgresql.auth.migrationExternalSecret | default dict -}}
{{- if eq (include "fairwinds-insights.postgresqlSplitAppMigration" .) "true" -}}
{{- if .Values.postgresql.auth.existingMigrationSecret -}}
{{- .Values.postgresql.auth.existingMigrationSecret -}}
{{- else if and $ext.create $ext.targetName -}}
{{- $ext.targetName -}}
{{- else -}}
fwinsights-postgresql-migration
{{- end -}}
{{- else -}}
{{- include "fairwinds-insights.postgresqlSecretName" . -}}
{{- end -}}
{{- end -}}

{{- define "fairwinds-insights.postgresqlExternalSecretName" -}}
{{- $ext := .Values.postgresql.auth.externalSecret | default dict -}}
{{- if $ext.name -}}
{{- $ext.name -}}
{{- else -}}
{{- include "fairwinds-insights.postgresqlSecretName" . -}}
{{- end -}}
{{- end -}}

{{- define "fairwinds-insights.postgresqlManageAppSecret" -}}
{{- $ext := .Values.postgresql.auth.externalSecret | default dict -}}
{{- if and .Values.postgresql.ephemeral (not .Values.postgresql.auth.existingSecret) (not $ext.create) -}}
true
{{- end -}}
{{- end -}}

{{- define "fairwinds-insights.postgresqlMigrationExternalSecretName" -}}
{{- $ext := .Values.postgresql.auth.migrationExternalSecret | default dict -}}
{{- if $ext.name -}}
{{- $ext.name -}}
{{- else -}}
{{- include "fairwinds-insights.postgresqlMigrationSecret" . -}}
{{- end -}}
{{- end -}}

{{- define "fairwinds-insights.postgresqlManageMigrationSecret" -}}
{{- $ext := .Values.postgresql.auth.migrationExternalSecret | default dict -}}
{{- if and (eq (include "fairwinds-insights.postgresqlSplitAppMigration" .) "true") .Values.postgresql.ephemeral (not .Values.postgresql.auth.existingMigrationSecret) (not $ext.create) -}}
true
{{- end -}}
{{- end -}}

{{- define "fairwinds-insights.postgresqlManageSuperUserSecret" -}}
{{- if and .Values.postgresql.ephemeral (not .Values.postgresql.auth.existingSuperUserSecret) -}}
true
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

{{- define "fairwinds-insights.timescaleSecretName" -}}
{{- $ext := .Values.timescale.auth.externalSecret | default dict -}}
{{- if .Values.timescale.auth.existingSecret -}}
{{- .Values.timescale.auth.existingSecret -}}
{{- else if and $ext.create $ext.targetName -}}
{{- $ext.targetName -}}
{{- else -}}
fwinsights-timescale
{{- end -}}
{{- end -}}

{{- define "fairwinds-insights.timescaleSuperUserSecretName" -}}
{{- if .Values.timescale.auth.existingSuperUserSecret -}}
{{- .Values.timescale.auth.existingSuperUserSecret -}}
{{- else -}}
fwinsights-timescale-superuser
{{- end -}}
{{- end -}}

{{- define "fairwinds-insights.timescaleMigrationSecret" -}}
{{- $ext := .Values.timescale.auth.migrationExternalSecret | default dict -}}
{{- if eq (include "fairwinds-insights.timescaleSplitAppMigration" .) "true" -}}
{{- if .Values.timescale.auth.existingMigrationSecret -}}
{{- .Values.timescale.auth.existingMigrationSecret -}}
{{- else if and $ext.create $ext.targetName -}}
{{- $ext.targetName -}}
{{- else -}}
fwinsights-timescale-migration
{{- end -}}
{{- else -}}
{{- include "fairwinds-insights.timescaleSecretName" . -}}
{{- end -}}
{{- end -}}

{{- define "fairwinds-insights.timescaleExternalSecretName" -}}
{{- $ext := .Values.timescale.auth.externalSecret | default dict -}}
{{- if $ext.name -}}
{{- $ext.name -}}
{{- else -}}
{{- include "fairwinds-insights.timescaleSecretName" . -}}
{{- end -}}
{{- end -}}

{{- define "fairwinds-insights.timescaleManageAppSecret" -}}
{{- $ext := .Values.timescale.auth.externalSecret | default dict -}}
{{- if and .Values.timescale.ephemeral (not .Values.timescale.auth.existingSecret) (not $ext.create) -}}
true
{{- end -}}
{{- end -}}

{{- define "fairwinds-insights.timescaleMigrationExternalSecretName" -}}
{{- $ext := .Values.timescale.auth.migrationExternalSecret | default dict -}}
{{- if $ext.name -}}
{{- $ext.name -}}
{{- else -}}
{{- include "fairwinds-insights.timescaleMigrationSecret" . -}}
{{- end -}}
{{- end -}}

{{- define "fairwinds-insights.timescaleManageMigrationSecret" -}}
{{- $ext := .Values.timescale.auth.migrationExternalSecret | default dict -}}
{{- if and (eq (include "fairwinds-insights.timescaleSplitAppMigration" .) "true") .Values.timescale.ephemeral (not .Values.timescale.auth.existingMigrationSecret) (not $ext.create) -}}
true
{{- end -}}
{{- end -}}

{{- define "fairwinds-insights.timescaleManageSuperUserSecret" -}}
{{- if and .Values.timescale.ephemeral (not .Values.timescale.auth.existingSuperUserSecret) -}}
true
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

{{- define "fairwinds-insights.validatePostgresqlAuth" -}}
{{- $ext := .Values.postgresql.auth.externalSecret | default dict -}}
{{- $migExt := .Values.postgresql.auth.migrationExternalSecret | default dict -}}
{{- if and .Values.postgresql.auth.existingSecret $ext.create -}}
{{- fail "postgresql.auth.existingSecret and postgresql.auth.externalSecret.create cannot both be set; pick Existing (set existingSecret, create: false) or External (empty existingSecret, create: true)" -}}
{{- end -}}
{{- if and $ext.targetName (not $ext.create) -}}
{{- fail "postgresql.auth.externalSecret.targetName is set but postgresql.auth.externalSecret.create is false; set create: true or clear targetName" -}}
{{- end -}}
{{- if and (not .Values.postgresql.ephemeral) (not .Values.postgresql.auth.existingSecret) (not $ext.create) -}}
{{- fail "postgresql.auth: when postgresql.ephemeral is false, set postgresql.auth.existingSecret or postgresql.auth.externalSecret.create" -}}
{{- end -}}
{{- if and .Values.postgresql.auth.existingMigrationSecret $migExt.create -}}
{{- fail "postgresql.auth.existingMigrationSecret and postgresql.auth.migrationExternalSecret.create cannot both be set; pick Existing (set existingMigrationSecret, create: false) or External (empty existingMigrationSecret, create: true)" -}}
{{- end -}}
{{- if and $migExt.targetName (not $migExt.create) -}}
{{- fail "postgresql.auth.migrationExternalSecret.targetName is set but postgresql.auth.migrationExternalSecret.create is false; set create: true or clear targetName" -}}
{{- end -}}
{{- if and $migExt.create (ne (include "fairwinds-insights.postgresqlSplitAppMigration" .) "true") -}}
{{- fail "postgresql.auth.migrationExternalSecret.create requires postgresql.auth.migrationUsername to differ from postgresql.auth.username" -}}
{{- end -}}
{{- if and (eq (include "fairwinds-insights.postgresqlSplitAppMigration" .) "true") (not .Values.postgresql.ephemeral) (not .Values.postgresql.auth.existingMigrationSecret) (not $migExt.create) -}}
{{- fail "postgresql.auth: when migrationUsername differs from username and postgresql.ephemeral is false, set postgresql.auth.existingMigrationSecret or postgresql.auth.migrationExternalSecret.create" -}}
{{- end -}}
{{- end -}}

{{- define "fairwinds-insights.validateTimescaleAuth" -}}
{{- $ext := .Values.timescale.auth.externalSecret | default dict -}}
{{- $migExt := .Values.timescale.auth.migrationExternalSecret | default dict -}}
{{- if and .Values.timescale.auth.existingSecret $ext.create -}}
{{- fail "timescale.auth.existingSecret and timescale.auth.externalSecret.create cannot both be set; pick Existing (set existingSecret, create: false) or External (empty existingSecret, create: true)" -}}
{{- end -}}
{{- if and $ext.targetName (not $ext.create) -}}
{{- fail "timescale.auth.externalSecret.targetName is set but timescale.auth.externalSecret.create is false; set create: true or clear targetName" -}}
{{- end -}}
{{- if and (not .Values.timescale.ephemeral) (not .Values.timescale.auth.existingSecret) (not $ext.create) -}}
{{- fail "timescale.auth: when timescale.ephemeral is false, set timescale.auth.existingSecret or timescale.auth.externalSecret.create" -}}
{{- end -}}
{{- if and .Values.timescale.auth.existingMigrationSecret $migExt.create -}}
{{- fail "timescale.auth.existingMigrationSecret and timescale.auth.migrationExternalSecret.create cannot both be set; pick Existing (set existingMigrationSecret, create: false) or External (empty existingMigrationSecret, create: true)" -}}
{{- end -}}
{{- if and $migExt.targetName (not $migExt.create) -}}
{{- fail "timescale.auth.migrationExternalSecret.targetName is set but timescale.auth.migrationExternalSecret.create is false; set create: true or clear targetName" -}}
{{- end -}}
{{- if and $migExt.create (ne (include "fairwinds-insights.timescaleSplitAppMigration" .) "true") -}}
{{- fail "timescale.auth.migrationExternalSecret.create requires timescale.auth.migrationUsername to differ from timescale.postgresqlUsername" -}}
{{- end -}}
{{- if and (eq (include "fairwinds-insights.timescaleSplitAppMigration" .) "true") (not .Values.timescale.ephemeral) (not .Values.timescale.auth.existingMigrationSecret) (not $migExt.create) -}}
{{- fail "timescale.auth: when migrationUsername differs from postgresqlUsername and timescale.ephemeral is false, set timescale.auth.existingMigrationSecret or timescale.auth.migrationExternalSecret.create" -}}
{{- end -}}
{{- end -}}

{{- define "fairwinds-insights.validateAppSecrets" -}}
{{- $ext := .Values.options.externalSecret | default dict -}}
{{- if and .Values.options.autogenerateKeys $ext.create -}}
{{- fail "options.autogenerateKeys and options.externalSecret.create cannot both be set; pick Chart-managed (autogenerateKeys: true, create: false) or External (autogenerateKeys: false, create: true)" -}}
{{- end -}}
{{- end -}}

{{- define "fairwinds-insights.appExternalSecretName" -}}
{{- $ext := .Values.options.externalSecret | default dict -}}
{{- if $ext.name -}}
{{- $ext.name -}}
{{- else -}}
{{- .Values.options.secretName -}}
{{- end -}}
{{- end -}}

{{- define "fairwinds-insights.validateDatabaseSecrets" -}}
{{- include "fairwinds-insights.validateAppSecrets" . -}}
{{- include "fairwinds-insights.validatePostgresqlAuth" . -}}
{{- include "fairwinds-insights.validateTimescaleAuth" . -}}
{{- end -}}

{{- define "fairwinds-insights.ephemeralSecretPassword" -}}
{{- $root := .root -}}
{{- $value := .value -}}
{{- $secretName := .secretName -}}
{{- $key := .key | default "password" -}}
{{- if $value -}}
{{- $value -}}
{{- else if $secretName -}}
{{- $existing := lookup "v1" "Secret" $root.Release.Namespace $secretName -}}
{{- if and $existing (index $existing.data $key) -}}
{{- index $existing.data $key | b64dec -}}
{{- else -}}
{{- randAlphaNum 32 -}}
{{- end -}}
{{- else -}}
{{- randAlphaNum 32 -}}
{{- end -}}
{{- end -}}

{{/* Resolved CloudNativePG operator values. `cnpg` is primary; `postgresql.operator` is deprecated. */}}
{{- define "fairwinds-insights.cnpg" -}}
{{- $legacy := default dict .Values.postgresql.operator -}}
{{- $cnpg := default dict .Values.cnpg -}}
{{- mergeOverwrite $legacy $cnpg | toYaml -}}
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

{{- define "fairwinds-insights.temporalHpaEnabled" -}}
{{- $options := .options -}}
{{- $root := .root -}}
{{- $default := $root.Values.temporalDeploymentDefaults.hpa.enabled | default false -}}
{{- if (dig "hpa" "enabled" $default $options) -}}true{{- else -}}false{{- end -}}
{{- end -}}

{{- define "fairwinds-insights.temporalKedaEnabled" -}}
{{- $options := .options -}}
{{- $root := .root -}}
{{- $default := $root.Values.temporalDeploymentDefaults.keda.enabled | default false -}}
{{- if (dig "keda" "enabled" $default $options) -}}true{{- else -}}false{{- end -}}
{{- end -}}

{{- define "fairwinds-insights.githubSecretName" -}}
{{- $p := .Values.githubSecret | default dict -}}
{{- $ext := $p.externalSecret | default dict -}}
{{- $ext.name | default "github-secrets" -}}
{{- end -}}

{{/*
Secret name for GCP pricing credentials.
ESO path: externalSecret.name (default gcp-pricing-credentials-external).
Existing Secret path: existingSecret (empty means do not mount).
*/}}
{{- define "fairwinds-insights.gcpPricingSecretName" -}}
{{- $p := .Values.gcpPricing | default dict -}}
{{- $ext := $p.externalSecret | default dict -}}
{{- if $ext.create -}}
{{- $ext.name | default "gcp-pricing-credentials-external" -}}
{{- else -}}
{{- $p.existingSecret -}}
{{- end -}}
{{- end -}}

