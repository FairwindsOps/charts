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
{{- .Values.fullnameOverride | trunc 27 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
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
