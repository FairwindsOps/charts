{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "insights-agent.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "insights-agent.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "insights-agent.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "metadata" }}
  name: {{ .Label }}
  labels:
    app: insights-agent
  {{- if .Values.cronjobs.disableServiceMesh }}
  annotations:
    linkerd.io/inject: disabled
    sidecar.istio.io/inject: "false"
  {{- end }}
{{- end }}
{{/*
Metadata for the cronjobs but always show annotations
*/}}
{{- define "annotation-metadata" }}
  name: {{ .Label }}
  labels:
    app: insights-agent
  annotations:
  {{- if .Values.cronjobs.disableServiceMesh }}
    linkerd.io/inject: disabled
    sidecar.istio.io/inject: "false"
  {{- end }}
{{- end }}
