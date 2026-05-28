{{- define "image-trust-env" -}}
{{- $cfg := index .Values "image-trust" -}}
{{- if $cfg.modes }}
- name: IMAGE_TRUST_MODES
  value: {{ join "," $cfg.modes | quote }}
{{- end }}
{{- if $cfg.modePolicy }}
- name: IMAGE_TRUST_MODE_POLICY
  value: {{ $cfg.modePolicy | quote }}
{{- end }}
{{- if $cfg.trustedIssuers }}
- name: IMAGE_TRUST_TRUSTED_ISSUERS
  value: {{ join "," $cfg.trustedIssuers | quote }}
{{- end }}
{{- if $cfg.trustedSubjects }}
- name: IMAGE_TRUST_TRUSTED_SUBJECTS
  value: {{ join "," $cfg.trustedSubjects | quote }}
{{- end }}
{{- if $cfg.trustedSubjectRegexps }}
- name: IMAGE_TRUST_TRUSTED_SUBJECT_REGEXPS
  value: {{ join "," $cfg.trustedSubjectRegexps | quote }}
{{- end }}
{{- if $cfg.ignoreTlog }}
- name: IMAGE_TRUST_IGNORE_TLOG
  value: "true"
{{- end }}
{{- if $cfg.publicKeys.secretName }}
- name: IMAGE_TRUST_PUBLIC_KEY_DIR
  value: "/etc/image-trust/keys"
{{- end }}
{{- if $cfg.maxConcurrentScans }}
- name: MAX_CONCURRENT_SCANS
  value: {{ $cfg.maxConcurrentScans | quote }}
{{- end }}
{{- if $cfg.imageVerifyTimeoutSeconds }}
- name: IMAGE_VERIFY_TIMEOUT_SECONDS
  value: {{ $cfg.imageVerifyTimeoutSeconds | quote }}
{{- end }}
{{- if $cfg.namespaceBlocklist }}
- name: NAMESPACE_BLOCKLIST
  value: {{ join "," $cfg.namespaceBlocklist | lower | quote }}
{{- end }}
{{- if $cfg.namespaceAllowlist }}
- name: NAMESPACE_ALLOWLIST
  value: {{ join "," $cfg.namespaceAllowlist | lower | quote }}
{{- end }}
{{- if $cfg.privateImages.registryUser }}
- name: REGISTRY_USER
  value: {{ $cfg.privateImages.registryUser | quote }}
{{- end }}
{{- if $cfg.privateImages.registryPasswordSecret }}
- name: REGISTRY_PASSWORD_FILE
  value: "/etc/registry/{{ default "password" $cfg.privateImages.registryPasswordSecretKey }}"
{{- end }}
{{- if $cfg.privateImages.dockerConfigSecret }}
- name: REGISTRY_DOCKER_CONFIG_PATH
  value: "/etc/docker/config.json"
{{- end }}
{{- if $cfg.privateImages.registryCertDir }}
- name: REGISTRY_CERT_DIR
  value: {{ $cfg.privateImages.registryCertDir | quote }}
{{- end }}
{{- end -}}
