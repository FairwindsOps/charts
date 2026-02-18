{{/*
Expand the name of the chart.
*/}}
{{- define "datadog-apm.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "datadog-apm.fullname" -}}
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
{{- define "datadog-apm.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Return secret name to be used based on provided values.
*/}}
{{- define "datadog-apm.apiSecretName" -}}
{{- $fullName := include "datadog-apm.fullname" . -}}
{{- default $fullName .Values.datadog.apiKeyExistingSecret | quote -}}
{{- end -}}

{{/*
Return secret name to be used based on provided values.
*/}}
{{- define "datadog-apm.appKeySecretName" -}}
{{- $fullName := printf "%s-appkey" (include "datadog-apm.fullname" .) -}}
{{- default $fullName .Values.datadog.appKeyExistingSecret | quote -}}
{{- end -}}

{{/*
Return secret name to be used based on provided values.
*/}}
{{- define "clusterAgent.tokenSecretName" -}}
{{- if not .Values.clusterAgent.tokenExistingSecret -}}
{{- include "datadog-apm.fullname" . -}}-cluster-agent
{{- else -}}
{{- .Values.clusterAgent.tokenExistingSecret -}}
{{- end -}}
{{- end -}}

{{/*
Return the cluster-agent image (repository:tag) for main and init containers.
*/}}
{{- define "clusterAgent.image" -}}
{{- .Values.clusterAgent.image.repository }}:{{ default .Chart.AppVersion .Values.clusterAgent.image.tag }}
{{- end -}}

{{/*
Correct `clusterAgent.metricsProvider.service.port` if Kubernetes <= 1.15
*/}}
{{- define "clusterAgent.metricsProvider.port" -}}
{{- if semverCompare "^1.15-0" .Capabilities.KubeVersion.GitVersion -}}
{{- .Values.clusterAgent.metricsProvider.service.port -}}
{{- else -}}
443
{{- end -}}
{{- end -}}

{{/*
Return the appropriate os label
*/}}
{{- define "label.os" -}}
{{- if semverCompare "^1.14-0" .Capabilities.KubeVersion.GitVersion -}}
kubernetes.io/os
{{- else -}}
beta.kubernetes.io/os
{{- end -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "datadog-apm.labels" -}}
helm.sh/chart: {{ include "datadog-apm.chart" . }}
{{ include "datadog-apm.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "datadog-apm.selectorLabels" -}}
app.kubernetes.io/name: {{ include "datadog-apm.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "datadog-apm.serviceAccountName" -}}
{{- if .Values.clusterAgent.serviceAccount.create }}
{{- default (include "datadog-apm.fullname" .) .Values.clusterAgent.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.clusterAgent.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Returns env vars correctly quoted and valueFrom respected
*/}}
{{- define "additional-env-entries" -}}
{{- if . -}}
{{- range . }}
- name: {{ .name }}
{{- if .value }}
  value: {{ .value | quote }}
{{- else }}
  valueFrom:
{{ toYaml .valueFrom | indent 4 }}
{{- end }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Returns env vars correctly quoted and valueFrom respected, defined in a dict
*/}}
{{- define "additional-env-dict-entries" -}}
{{- range $key, $value := . }}
- name: {{ $key }}
{{- if kindIs "map" $value }}
{{ toYaml $value | indent 2 }}
{{- else }}
  value: {{ $value | quote }}
{{- end }}
{{- end }}
{{- end -}}