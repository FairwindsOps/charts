{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "helm-release-pruner.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "helm-release-pruner.fullname" -}}
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
{{- define "helm-release-pruner.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "helm-release-pruner.labels" -}}
helm.sh/chart: {{ include "helm-release-pruner.chart" . }}
{{ include "helm-release-pruner.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "helm-release-pruner.selectorLabels" -}}
app.kubernetes.io/name: {{ include "helm-release-pruner.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "helm-release-pruner.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "helm-release-pruner.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Build CLI arguments for the pruner
*/}}
{{- define "helm-release-pruner.args" -}}
- --interval={{ .Values.pruner.interval }}
- --health-addr={{ .Values.healthAddr }}
{{- if .Values.pruner.dryRun }}
- --dry-run
{{- end }}
{{- if .Values.pruner.debug }}
- --debug
{{- end }}
{{- if .Values.pruner.olderThan }}
- --older-than={{ .Values.pruner.olderThan }}
{{- end }}
{{- if .Values.pruner.maxReleasesToKeep }}
- --max-releases-to-keep={{ .Values.pruner.maxReleasesToKeep }}
{{- end }}
{{- if .Values.pruner.releaseFilter }}
- --release-filter={{ .Values.pruner.releaseFilter }}
{{- end }}
{{- if .Values.pruner.releaseExclude }}
- --release-exclude={{ .Values.pruner.releaseExclude }}
{{- end }}
{{- if .Values.pruner.namespaceFilter }}
- --namespace-filter={{ .Values.pruner.namespaceFilter }}
{{- end }}
{{- if .Values.pruner.namespaceExclude }}
- --namespace-exclude={{ .Values.pruner.namespaceExclude }}
{{- end }}
{{- if .Values.pruner.preserveNamespace }}
- --preserve-namespace
{{- end }}
{{- if .Values.pruner.cleanupOrphanNamespaces }}
- --cleanup-orphan-namespaces
{{- end }}
{{- if .Values.pruner.orphanNamespaceFilter }}
- --orphan-namespace-filter={{ .Values.pruner.orphanNamespaceFilter }}
{{- end }}
{{- if .Values.pruner.orphanNamespaceExclude }}
- --orphan-namespace-exclude={{ .Values.pruner.orphanNamespaceExclude }}
{{- end }}
{{- if .Values.pruner.systemNamespaces }}
- --system-namespaces={{ .Values.pruner.systemNamespaces }}
{{- end }}
{{- if .Values.pruner.deleteRateLimit }}
- --delete-rate-limit={{ .Values.pruner.deleteRateLimit }}
{{- end }}
{{- end }}
