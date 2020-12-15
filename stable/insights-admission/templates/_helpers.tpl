{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "insights-admission.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "insights-admission.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "insights-admission.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "insights-admission.labels" -}}
helm.sh/chart: {{ include "insights-admission.chart" . }}
{{ include "insights-admission.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "insights-admission.selectorLabels" -}}
app.kubernetes.io/name: {{ include "insights-admission.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "insights-admission.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "insights-admission.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the Secret to use
*/}}
{{- define "insights-admission.secretName" -}}
{{- if .Values.insights.secret.name }}
{{- .Values.insights.secret.name }}
{{- else }}
{{- printf "%s-%s" (include "insights-admission.fullname" .) (default "-token" .Values.insights.secret.suffix) }}
{{- end }}
{{- end }}

{{/*
Create the name of the ConfigMap to use
*/}}
{{- define "insights-admission.configmapName" -}}
{{- if .Values.insights.configmap.name }}
{{- .Values.insights.configmap.name }}
{{- else }}
{{- printf "%s-%s" (include "insights-admission.fullname" .) (default "-configmap" .Values.insights.configmap.suffix) }}
{{- end }}
{{- end }}
