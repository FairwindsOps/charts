{{/*
Expand the name of the chart.
*/}}
{{- define "mutillidae.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mutillidae.fullname" -}}
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
{{- define "mutillidae.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "mutillidae.labels" -}}
helm.sh/chart: {{ include "mutillidae.chart" . }}
{{ include "mutillidae.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "mutillidae.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mutillidae.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use for www
*/}}
{{- define "mutillidae.www.serviceAccountName" -}}
{{- if .Values.www.serviceAccount.create }}
{{- default (include "mutillidae.fullname" .) .Values.www.serviceAccount.name }}-www
{{- else }}
{{- default "default" .Values.www.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use for ldap
*/}}
{{- define "mutillidae.ldap.serviceAccountName" -}}
{{- if .Values.ldap.serviceAccount.create }}
{{- default (include "mutillidae.fullname" .) .Values.ldap.serviceAccount.name }}-ldap
{{- else }}
{{- default "default" .Values.ldap.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use for ldap
*/}}
{{- define "mutillidae.database.serviceAccountName" -}}
{{- if .Values.database.serviceAccount.create }}
{{- default (include "mutillidae.fullname" .) .Values.ldap.serviceAccount.name }}-database
{{- else }}
{{- default "default" .Values.database.serviceAccount.name }}
{{- end }}
{{- end }}
