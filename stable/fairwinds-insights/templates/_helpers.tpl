{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "fairwinds-insights.name" -}}
{{- default .Chart.Name .Values.global.nameOverride | trunc 52 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 52 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "fairwinds-insights.fullname" -}}
{{- if .Values.global.fullnameOverride -}}
{{- .Values.global.fullnameOverride | trunc 27 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.global.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 27 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s" .Release.Name | trunc 27 | trimSuffix "-" -}}
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
{{- if .Values.global.sanitizedBranch -}}
{{- printf "%s." (.Values.global.sanitizedBranch | trunc 12 | trimSuffix "-") -}}
{{- end -}}
{{- end -}}

{{- define "fairwinds-insights.cronjobImageTag" -}}
{{- if .Values.global.cronjobImage.tag -}}
{{- .Values.global.cronjobImage.tag -}}
{{- else -}}
{{- .Values.global.image.tag | default .Chart.AppVersion -}}
{{- end -}}
{{- end -}}

{{- define "fairwinds-insights.apiImageTag" -}}
{{- if .Values.global.apiImage.tag -}}
{{- .Values.global.apiImage.tag -}}
{{- else -}}
{{- .Values.global.image.tag | default .Chart.AppVersion -}}
{{- end -}}
{{- end -}}

{{- define "fairwinds-insights.openApiImageTag" -}}
{{- if .Values.global.openApiImage.tag -}}
{{- .Values.global.openApiImage.tag -}}
{{- else -}}
{{- .Values.global.image.tag | default .Chart.AppVersion -}}
{{- end -}}
{{- end -}}

{{- define "fairwinds-insights.dashboardImageTag" -}}
{{- if .Values.global.dashboardImage.tag -}}
{{- .Values.global.dashboardImage.tag -}}
{{- else -}}
{{- .Values.global.image.tag | default .Chart.AppVersion -}}
{{- end -}}
{{- end -}}

{{- define "fairwinds-insights.migrationImageTag" -}}
{{- if .Values.global.migrationImage.tag -}}
{{- .Values.global.migrationImage.tag -}}
{{- else -}}
{{- .Values.global.image.tag | default .Chart.AppVersion -}}
{{- end -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "fairwinds-insights.labels" -}}
helm.sh/chart: {{ include "fairwinds-insights.chart" . }}
{{ include "fairwinds-insights.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{ if .Values.global.rok8sCIRef }}
app.kubernetes.io/rok8sCIRef: {{ .Values.global.rok8sCIRef }}
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
