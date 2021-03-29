{{- define "common-labels" }}
chart: {{ .Chart.Name }}
release: {{ .Release.Name }}
heritage: {{ .Release.Service }}
{{- end }}

{{- define "selectorTemplate" }}
{{- if .selector }}
{{- if or .selector.matchLabels .selector.dnsNames .selector.dnsZones }}
selector:
  {{- if .selector.matchLabels }}
  matchLabels:
    {{- range $labelKey, $labelValue := .selector.matchLabels }}
    {{ $labelKey }}: {{ $labelValue }}
    {{- end }} {{- /* endrange $labelKey, $labelValue := .selector.matchLabels */ -}}
  {{- end }} {{- /* endif .selector.matchLabels */ -}}
  {{- if .selector.dnsNames }}
  dnsNames:
    {{- range .selector.dnsNames }}
  - {{ . | quote }}
    {{- end }} {{- /* endrange .selector.dnsNames */ -}}
  {{- end }} {{- /* endif .selector.dnsNames */ -}}
  {{- if .selector.dnsZones }}
  dnsZones:
  {{- range .selector.dnsZones }}
  - {{ . }}
  {{- end }} {{- /* endrange .selector.dnsZones */ -}}
  {{- end }} {{- /* endif .selector.dnsZones */ -}}
{{- else }}
selector: {}
{{- end }} {{- /* endif or .selector.matchLabels .selector.dnsNames .selector.dnsZones */ -}}
{{- end }} {{- /* endif .selector */ -}}
{{- end }} {{- /* end selectorTemplate */ -}}

{{- define "solverTemplate" }}
solvers:
{{- if .http.enabled }}
{{- if or .http.ingressClass .http.ingressName }}
- http01:
    ingress:
      {{- if .http.ingressClass }}
      class: {{ .http.ingressClass }}
      {{- end }} {{- /* endif .http.ingressClass */ -}}
      {{- if .http.ingressName }}
      name: {{ .http.ingressName }}
      {{- end }} {{- /* endif .http.ingressName */ -}}
  {{- include "selectorTemplate" .http | indent 2 }}
{{- else if .http.selector }}
- http01:
  {{- include "selectorTemplate" .http | indent 2 }}
{{- else }}
- http01: {}
{{- end }} {{- /* endif or .http.ingressClass .http.ingressName */ -}}
{{- end }} {{- /* endif .http.enabled */ -}}
{{- if .dns }}
{{- if gt (len .dns) 0 }}
{{- range .dns }}
- dns01:
  {{- if eq .type "route53" }}
    route53:
      hostedZoneID: {{ .hostedZoneID | default "" }}
      region: {{ .region }}
      {{- if .role }}
      role: {{ .role }}
      {{- end }} {{- /* endif .role */ -}}
      {{- if .secretName }}
      accessKeyID: {{ .accessKeyID }}
      secretAccessKeySecretRef:
        name: {{ .secretName }}
        key: {{ .secretKey }}
      {{- end }} {{- /* endif .secretName */ -}}
  {{- end }} {{- /* endif eq .type "route53" */ -}}
  {{- if eq .type "cloudflare" }}
    cloudflare:
      email: {{ .email | default "" }}
      {{- if .secretName }}
      apiKeySecretRef:
        name: {{ .secretName }}
        key: {{ .secretKey }}
      {{- end }} {{- /* endif .secretName */ -}}
  {{- end }} {{- /* endif eq .type "cloudflare" */ -}}
  {{- if eq .type "clouddns" }}
    clouddns:
      project: {{ required "A valid project is necessary for clouddns entry required!" .project }}
      {{- if .secretName }}
      serviceAccountSecretRef:
        name: {{ .secretName }}
        key: {{ .secretKey }}
      {{- end }} {{- /* endif .secretName */ -}}
  {{- end }} {{- /* endif eq .type "clouddns" */ -}}
  {{- include "selectorTemplate" . | indent 2 }}
{{- end }} {{- /* endrange .dns */ -}}
{{- end }} {{- /* endif len .dns */ -}}
{{- end }} {{- /* endif .dns */ -}}
{{- end }} {{- /* end solverTemplate */ -}}
