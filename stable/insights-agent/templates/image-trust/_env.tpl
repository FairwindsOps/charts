{{- define "image-trust-env" -}}
{{- $cfg := index .Values "image-trust" -}}
{{- $effectiveModes := include "image-trust.effectiveModes" . -}}
{{- if $effectiveModes }}
- name: IMAGE_TRUST_MODES
  value: {{ $effectiveModes | quote }}
{{- end }}
{{- if eq (include "image-trust.attestationsActive" .) "true" }}
- name: IMAGE_TRUST_ATTESTATIONS_ENABLED
  value: "true"
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
{{- $attTypes := include "image-trust.attestationTypes" . -}}
{{- if $attTypes }}
- name: IMAGE_TRUST_ATTESTATION_TYPES
  value: {{ $attTypes | quote }}
{{- end }}
{{- if $cfg.ignoreTlog }}
- name: IMAGE_TRUST_IGNORE_TLOG
  value: "true"
{{- end }}
{{- if $cfg.publicKeys.secretName }}
- name: IMAGE_TRUST_PUBLIC_KEY_DIR
  value: "/etc/image-trust/keys"
{{- end }}
{{- if $cfg.publicKeys.refs }}
- name: IMAGE_TRUST_PUBLIC_KEY_REFS
  value: {{ join "," $cfg.publicKeys.refs | quote }}
{{- end }}
{{- if $cfg.publicKeys.paths }}
- name: IMAGE_TRUST_PUBLIC_KEY_PATHS
  value: {{ join "," $cfg.publicKeys.paths | quote }}
{{- end }}
{{- if $cfg.imageAllowlist }}
- name: IMAGE_TRUST_IMAGE_ALLOWLIST
  value: {{ join "," $cfg.imageAllowlist | quote }}
{{- end }}
{{- if $cfg.registryAllowlist }}
- name: IMAGE_TRUST_REGISTRY_ALLOWLIST
  value: {{ join "," $cfg.registryAllowlist | quote }}
{{- end }}
{{- if $cfg.signerAllowlist }}
- name: IMAGE_TRUST_SIGNER_ALLOWLIST
  value: {{ join "," $cfg.signerAllowlist | quote }}
{{- end }}
{{- if $cfg.maxConcurrentScans }}
- name: MAX_CONCURRENT_SCANS
  value: {{ $cfg.maxConcurrentScans | quote }}
{{- end }}
{{- if $cfg.imageVerifyTimeoutSeconds }}
- name: IMAGE_VERIFY_TIMEOUT_SECONDS
  value: {{ $cfg.imageVerifyTimeoutSeconds | quote }}
{{- end }}
{{- if $cfg.verifyRetries }}
- name: IMAGE_TRUST_VERIFY_RETRIES
  value: {{ $cfg.verifyRetries | quote }}
{{- end }}
{{- if $cfg.verifyRetryBackoffSeconds }}
- name: IMAGE_TRUST_VERIFY_RETRY_BACKOFF_SECONDS
  value: {{ $cfg.verifyRetryBackoffSeconds | quote }}
{{- end }}
{{- if ne $cfg.verifyRetryJitter nil }}
- name: IMAGE_TRUST_VERIFY_RETRY_JITTER
  value: {{ $cfg.verifyRetryJitter | quote }}
{{- end }}
{{- if not $cfg.resolveDigests }}
- name: IMAGE_TRUST_RESOLVE_DIGESTS
  value: "false"
{{- end }}
{{- if $cfg.registryAuthHost }}
- name: IMAGE_TRUST_REGISTRY_AUTH_HOST
  value: {{ $cfg.registryAuthHost | quote }}
{{- end }}
{{- if $cfg.namespaceBlocklist }}
- name: IMAGE_TRUST_NAMESPACE_BLOCKLIST
  value: {{ join "," $cfg.namespaceBlocklist | lower | quote }}
{{- end }}
{{- if $cfg.namespaceAllowlist }}
- name: IMAGE_TRUST_NAMESPACE_ALLOWLIST
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
{{- if $cfg.privateImages.registryAuthsSecret }}
- name: IMAGE_TRUST_REGISTRY_AUTHS_FILE
  value: "/etc/image-trust/registry/{{ default "auths.json" $cfg.privateImages.registryAuthsSecretKey }}"
{{- end }}
{{- if $cfg.registryMirrors }}
- name: IMAGE_TRUST_REGISTRY_MIRRORS
  value: {{ $cfg.registryMirrors | quote }}
{{- end }}
{{- if $cfg.registryMirrorsFile.secret }}
- name: IMAGE_TRUST_REGISTRY_MIRRORS_FILE
  value: "/etc/image-trust/mirrors/{{ default "mirrors.txt" $cfg.registryMirrorsFile.secretKey }}"
{{- end }}
{{- if $cfg.registryCertDirs }}
- name: IMAGE_TRUST_REGISTRY_CERT_DIRS
  value: {{ $cfg.registryCertDirs | quote }}
{{- end }}
{{- if $cfg.registryCertDirsFile.secret }}
- name: IMAGE_TRUST_REGISTRY_CERT_DIRS_FILE
  value: "/etc/image-trust/certs/{{ default "cert-dirs.txt" $cfg.registryCertDirsFile.secretKey }}"
{{- end }}
{{- if $cfg.privateImages.registryCertDir }}
- name: REGISTRY_CERT_DIR
  value: {{ $cfg.privateImages.registryCertDir | quote }}
{{- end }}
{{- if $cfg.sigstore.envFileSecret }}
- name: IMAGE_TRUST_SIGSTORE_ENV_FILE
  value: "/etc/sigstore/{{ default "sigstore.env" $cfg.sigstore.envFileSecretKey }}"
{{- end }}
{{- if $cfg.sigstore.trustBundleSecret }}
- name: SIGSTORE_ROOT_FILE
  value: "/etc/sigstore/trust/{{ default "root.pem" $cfg.sigstore.trustBundleSecretKey }}"
{{- end }}
{{- range $key, $value := $cfg.sigstore.env }}
- name: {{ $key }}
  value: {{ $value | quote }}
{{- end }}
{{- end -}}
