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
True when cosign needs a writable home directory for Sigstore TUF/Rekor cache (readOnlyRootFilesystem).
*/}}
{{- define "image-trust.needsCosignCache" -}}
{{- $cfg := index .Values "image-trust" -}}
{{- $modesStr := include "image-trust.effectiveModes" . | trim -}}
{{- if $modesStr -}}
{{- $modes := splitList "," $modesStr -}}
{{- $hasKeyless := or (has "cosign-keyless" $modes) (has "cosign-attestation-keyless" $modes) -}}
{{- $hasKeyedRekor := and (or (has "cosign-key" $modes) (has "cosign-attestation-key" $modes)) (not $cfg.ignoreTlog) -}}
{{- if or $hasKeyless $hasKeyedRekor -}}true{{- end -}}
{{- end -}}
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

{{/*
Fail at render time when image-trust is enabled with invalid plugin configuration.
*/}}
{{- define "image-trust.validateConfig" -}}
{{- $cfg := index .Values "image-trust" -}}
{{- if $cfg.enabled -}}
{{- $modesStr := include "image-trust.effectiveModes" . | trim -}}
{{- if not $modesStr -}}
{{- fail "image-trust.enabled: modes must include at least one verification mode (e.g. cosign-keyless, cosign-key)" -}}
{{- end -}}
{{- $modes := splitList "," $modesStr -}}
{{- $hasKeylessPolicy := or (has "cosign-keyless" $modes) (has "cosign-attestation-keyless" $modes) -}}
{{- if $hasKeylessPolicy -}}
{{- if and (not $cfg.trustedIssuers) (not $cfg.trustedSubjects) (not (gt (len $cfg.trustedSubjectRegexps) 0)) -}}
{{- fail "image-trust.enabled: cosign-keyless (or attestation-keyless) requires trustedIssuers, trustedSubjects, or trustedSubjectRegexps" -}}
{{- end -}}
{{- end -}}
{{- $hasKeyedMode := or (has "cosign-key" $modes) (has "cosign-attestation-key" $modes) -}}
{{- if $hasKeyedMode -}}
{{- $hasPublicKeys := or $cfg.publicKeys.secretName (gt (len ($cfg.publicKeys.refs | default list)) 0) (gt (len ($cfg.publicKeys.paths | default list)) 0) -}}
{{- if not $hasPublicKeys -}}
{{- fail "image-trust.enabled: cosign-key (or attestation-key) requires publicKeys.secretName, publicKeys.refs, or publicKeys.paths" -}}
{{- end -}}
{{- end -}}
{{- if eq (include "image-trust.attestationsActive" .) "true" -}}
{{- if not (include "image-trust.attestationTypes" .) -}}
{{- fail "image-trust.enabled: attestations require attestations.types (or legacy attestationTypes)" -}}
{{- end -}}
{{- if not (or (has "cosign-keyless" $modes) (has "cosign-key" $modes) (has "cosign-attestation-keyless" $modes) (has "cosign-attestation-key" $modes)) -}}
{{- fail "image-trust.enabled: attestations require cosign-keyless and/or cosign-key in modes (attestation modes are appended automatically)" -}}
{{- end -}}
{{- end -}}
{{- if and $cfg.namespaceAllowlist $cfg.namespaceBlocklist -}}
{{- $blockLower := list -}}
{{- range $cfg.namespaceBlocklist -}}
{{- $blockLower = append $blockLower (lower .) -}}
{{- end -}}
{{- range $ns := $cfg.namespaceAllowlist -}}
{{- if has (lower $ns) $blockLower -}}
{{- fail (printf "image-trust.enabled: namespace %q cannot be in both namespaceAllowlist and namespaceBlocklist" $ns) -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}
