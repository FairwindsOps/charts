{{/*
Return attestation predicate types (attestations.types with fallback to legacy attestationTypes).
*/}}
{{- define "image-trust.attestationTypes" -}}
{{- $cfg := index .Values "image-trust" -}}
{{- if $cfg.attestations.types -}}
{{- join "," $cfg.attestations.types -}}
{{- else if $cfg.attestationTypes -}}
{{- join "," $cfg.attestationTypes -}}
{{- end -}}
{{- end -}}

{{/*
True when attestations.enabled or at least one attestation type is configured.
*/}}
{{- define "image-trust.attestationsActive" -}}
{{- $cfg := index .Values "image-trust" -}}
{{- if $cfg.attestations.enabled -}}true{{- else if include "image-trust.attestationTypes" . -}}true{{- end -}}
{{- end -}}

{{/*
Effective IMAGE_TRUST_MODES: base modes plus attestation modes when attestations are active.
*/}}
{{- define "image-trust.effectiveModes" -}}
{{- $cfg := index .Values "image-trust" -}}
{{- $modes := $cfg.modes | default (list) -}}
{{- if eq (include "image-trust.attestationsActive" .) "true" -}}
{{- if and (has "cosign-keyless" $modes) (not (has "cosign-attestation-keyless" $modes)) -}}
{{- $modes = append $modes "cosign-attestation-keyless" -}}
{{- end -}}
{{- if and (has "cosign-key" $modes) (not (has "cosign-attestation-key" $modes)) -}}
{{- $modes = append $modes "cosign-attestation-key" -}}
{{- end -}}
{{- end -}}
{{- join "," $modes -}}
{{- end -}}
