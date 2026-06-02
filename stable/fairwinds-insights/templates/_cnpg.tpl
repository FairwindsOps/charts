{{/*
CloudNativePG Cluster / ClusterImageCatalog documents shared by:
- Helm-rendered manifests (operator not installed)
- The pre-install Job that runs kubectl apply (operator install mode)

Use mode "helm" for hook annotations on metadata where applicable; use "job" when applying via kubectl in the Job (no hook annotations — hooks do not apply to API-submitted resources).
*/}}

{{- define "fairwinds-insights.cnpg.postgresCluster" -}}
{{- $root := .root -}}
{{- $mode := .mode -}}
apiVersion: postgresql.cnpg.io/v1
kind: Cluster
metadata:
  name: insights-postgres
  namespace: {{ $root.Release.Namespace }}
  labels:
{{- include "fairwinds-insights.labels" $root | nindent 4 }}
{{- if eq $mode "helm" }}
  annotations:
    "helm.sh/hook-delete-policy": "before-hook-creation"
{{- end }}
spec:
  instances: 1
  enablePDB: {{ $root.Values.postgresql.enablePDB }}
  enableSuperuserAccess: true
  imageName: {{ $root.Values.postgresql.image.registry }}/{{ $root.Values.postgresql.image.repository }}:{{ $root.Values.postgresql.image.tag }}
  postgresql:
    parameters:
{{- toYaml $root.Values.postgresql.parameters | nindent 6 }}
  bootstrap:
    initdb:
      database: {{ $root.Values.postgresql.auth.database }}
      owner: {{ include "fairwinds-insights.postgresqlMigrationUsername" $root }}
      secret:
        name: {{ include "fairwinds-insights.postgresqlMigrationSecret" $root }}
{{- if or (eq (include "fairwinds-insights.postgresqlUseOwnerRole" $root) "true") (ne (include "fairwinds-insights.postgresqlMigrationUsername" $root) (include "fairwinds-insights.postgresqlAppUsername" $root)) }}
      postInitSQL:
{{- if eq (include "fairwinds-insights.postgresqlUseOwnerRole" $root) "true" }}
        - CREATE ROLE {{ include "fairwinds-insights.postgresqlOwnerRole" $root }} NOLOGIN
        - ALTER DATABASE {{ $root.Values.postgresql.auth.database }} OWNER TO {{ include "fairwinds-insights.postgresqlOwnerRole" $root }}
        - ALTER SCHEMA public OWNER TO {{ include "fairwinds-insights.postgresqlOwnerRole" $root }}
        - GRANT {{ include "fairwinds-insights.postgresqlOwnerRole" $root }} TO {{ include "fairwinds-insights.postgresqlMigrationUsername" $root }}
{{- end }}
{{- if ne (include "fairwinds-insights.postgresqlMigrationUsername" $root) (include "fairwinds-insights.postgresqlAppUsername" $root) }}
        - CREATE ROLE {{ include "fairwinds-insights.postgresqlAppUsername" $root }} LOGIN
        - GRANT CONNECT ON DATABASE {{ $root.Values.postgresql.auth.database }} TO {{ include "fairwinds-insights.postgresqlAppUsername" $root }}
        - GRANT pg_read_all_data, pg_write_all_data TO {{ include "fairwinds-insights.postgresqlAppUsername" $root }}
{{- end }}
{{- end }}
  superuserSecret:
    name: {{ $root.Values.postgresql.auth.existingSuperUserSecret }}
{{- if or (eq (include "fairwinds-insights.postgresqlUseOwnerRole" $root) "true") (ne (include "fairwinds-insights.postgresqlMigrationUsername" $root) (include "fairwinds-insights.postgresqlAppUsername" $root)) }}
  managed:
    roles:
{{- if eq (include "fairwinds-insights.postgresqlUseOwnerRole" $root) "true" }}
      - name: {{ include "fairwinds-insights.postgresqlOwnerRole" $root }}
        ensure: present
        login: false
        superuser: false
{{- end }}
{{- if ne (include "fairwinds-insights.postgresqlMigrationUsername" $root) (include "fairwinds-insights.postgresqlAppUsername" $root) }}
      - name: {{ include "fairwinds-insights.postgresqlAppUsername" $root }}
        ensure: present
        login: true
        superuser: false
        passwordSecret:
          name: {{ $root.Values.postgresql.auth.existingSecret }}
        inRoles:
          - pg_read_all_data
          - pg_write_all_data
{{- end }}
{{- end }}
  storage:
    size: {{ $root.Values.postgresql.storage.size }}
{{- if $root.Values.postgresql.storage.storageClass }}
    storageClass: {{ $root.Values.postgresql.storage.storageClass }}
{{- end }}
  resources:
{{- toYaml $root.Values.postgresql.resources | nindent 4 }}
{{- end }}

{{- define "fairwinds-insights.cnpg.timescaleClusterImageCatalog" -}}
{{- $root := .root -}}
{{- $mode := .mode -}}
apiVersion: postgresql.cnpg.io/v1
kind: ClusterImageCatalog
metadata:
  name: {{ include "fairwinds-insights.timescaleClusterImageCatalog" $root }}
  labels:
{{- include "fairwinds-insights.labels" $root | nindent 4 }}
{{- if eq $mode "helm" }}
  annotations:
    "helm.sh/hook-delete-policy": "before-hook-creation"
{{- end }}
spec:
  images:
    - major: {{ $root.Values.timescale.imageCatalog.major }}
      image: {{ include "fairwinds-insights.timescaleImage" $root }}
{{- end }}

{{- define "fairwinds-insights.cnpg.timescaleCluster" -}}
{{- $root := .root -}}
{{- $mode := .mode -}}
apiVersion: postgresql.cnpg.io/v1
kind: Cluster
metadata:
  name: insights-timescale
  namespace: {{ $root.Release.Namespace }}
  labels:
{{- include "fairwinds-insights.labels" $root | nindent 4 }}
{{- if eq $mode "helm" }}
  annotations:
    "helm.sh/hook-delete-policy": "before-hook-creation"
{{- end }}
spec:
  instances: 1
  enablePDB: {{ $root.Values.timescale.enablePDB }}
  enableSuperuserAccess: true
  postgresUID: {{ $root.Values.timescale.postgresUID }}
  postgresGID: {{ $root.Values.timescale.postgresGID }}
  imageCatalogRef:
    apiGroup: postgresql.cnpg.io
    kind: ClusterImageCatalog
    name: {{ include "fairwinds-insights.timescaleClusterImageCatalog" $root }}
    major: {{ $root.Values.timescale.imageCatalog.major }}
  postgresql:
{{- if $root.Values.timescale.sharedPreloadLibraries }}
    shared_preload_libraries:
{{- range $root.Values.timescale.sharedPreloadLibraries }}
      - {{ . }}
{{- end }}
{{- end }}
    parameters:
{{- toYaml $root.Values.timescale.parameters | nindent 6 }}
  bootstrap:
    initdb:
      database: {{ $root.Values.timescale.postgresqlDatabase }}
      owner: {{ $root.Values.timescale.postgresqlUsername }}
      secret:
        name: {{ $root.Values.timescale.auth.existingSecret }}
      postInitSQL:
        - CREATE EXTENSION IF NOT EXISTS timescaledb;
  superuserSecret:
    name: {{ $root.Values.timescale.auth.existingSuperUserSecret }}
  storage:
    size: {{ $root.Values.timescale.storage.size }}
{{- if $root.Values.timescale.storage.storageClass }}
    storageClass: {{ $root.Values.timescale.storage.storageClass }}
{{- end }}
  resources:
{{- toYaml $root.Values.timescale.resources | nindent 4 }}
{{- end }}
