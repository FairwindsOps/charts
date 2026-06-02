{{/*
CloudNativePG Cluster / ClusterImageCatalog documents shared by:
- Helm-rendered manifests (operator not installed)
- The pre-install Job that runs kubectl apply (operator install mode)

Use mode "helm" for hook annotations on metadata where applicable; use "job" when applying via kubectl in the Job (no hook annotations — hooks do not apply to API-submitted resources).
*/}}

{{- define "fairwinds-insights.cnpg.postgresCluster" -}}
{{- $root := .root -}}
{{- $mode := .mode -}}
{{- if eq (include "fairwinds-insights.postgresqlRoleBootstrap" $root) "true" }}
{{- include "fairwinds-insights.assertPostgresIdentifier" (include "fairwinds-insights.postgresqlMigrationUsername" $root) }}
{{- include "fairwinds-insights.assertPostgresIdentifier" (include "fairwinds-insights.postgresqlOwnerRole" $root) }}
{{- if eq (include "fairwinds-insights.postgresqlSplitAppMigration" $root) "true" }}
{{- include "fairwinds-insights.assertPostgresIdentifier" (include "fairwinds-insights.postgresqlAppUsername" $root) }}
{{- end }}
{{- include "fairwinds-insights.assertPostgresIdentifier" $root.Values.postgresql.auth.database }}
{{- end }}
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
{{- if eq (include "fairwinds-insights.postgresqlRoleBootstrap" $root) "true" }}
      postInitSQL:
{{- if eq (include "fairwinds-insights.postgresqlUseOwnerRole" $root) "true" }}
        - CREATE ROLE {{ include "fairwinds-insights.postgresqlOwnerRole" $root }} NOLOGIN
        - ALTER DATABASE {{ $root.Values.postgresql.auth.database }} OWNER TO {{ include "fairwinds-insights.postgresqlOwnerRole" $root }}
        - ALTER SCHEMA public OWNER TO {{ include "fairwinds-insights.postgresqlOwnerRole" $root }}
        - GRANT {{ include "fairwinds-insights.postgresqlOwnerRole" $root }} TO {{ include "fairwinds-insights.postgresqlMigrationUsername" $root }}
{{- end }}
{{- if eq (include "fairwinds-insights.postgresqlSplitAppMigration" $root) "true" }}
        {{/* GRANTs here; app password and reconciliation via managed.roles below */}}
        - CREATE ROLE {{ include "fairwinds-insights.postgresqlAppUsername" $root }} LOGIN
        - GRANT CONNECT ON DATABASE {{ $root.Values.postgresql.auth.database }} TO {{ include "fairwinds-insights.postgresqlAppUsername" $root }}
        - GRANT pg_read_all_data, pg_write_all_data TO {{ include "fairwinds-insights.postgresqlAppUsername" $root }}
{{- end }}
{{- end }}
  superuserSecret:
    name: {{ $root.Values.postgresql.auth.existingSuperUserSecret }}
{{- if eq (include "fairwinds-insights.postgresqlRoleBootstrap" $root) "true" }}
  managed:
    roles:
{{- if eq (include "fairwinds-insights.postgresqlUseOwnerRole" $root) "true" }}
      - name: {{ include "fairwinds-insights.postgresqlOwnerRole" $root }}
        ensure: present
        login: false
        superuser: false
{{- end }}
{{- if eq (include "fairwinds-insights.postgresqlSplitAppMigration" $root) "true" }}
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
{{- if eq (include "fairwinds-insights.timescaleRoleBootstrap" $root) "true" }}
{{- include "fairwinds-insights.assertPostgresIdentifier" (include "fairwinds-insights.timescaleMigrationUsername" $root) }}
{{- include "fairwinds-insights.assertPostgresIdentifier" (include "fairwinds-insights.timescaleOwnerRole" $root) }}
{{- if eq (include "fairwinds-insights.timescaleSplitAppMigration" $root) "true" }}
{{- include "fairwinds-insights.assertPostgresIdentifier" (include "fairwinds-insights.timescaleAppUsername" $root) }}
{{- end }}
{{- include "fairwinds-insights.assertPostgresIdentifier" $root.Values.timescale.postgresqlDatabase }}
{{- end }}
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
      owner: {{ include "fairwinds-insights.timescaleMigrationUsername" $root }}
      secret:
        name: {{ include "fairwinds-insights.timescaleMigrationSecret" $root }}
{{- if eq (include "fairwinds-insights.timescaleRoleBootstrap" $root) "true" }}
      postInitSQL:
        - CREATE EXTENSION IF NOT EXISTS timescaledb;
{{- if eq (include "fairwinds-insights.timescaleUseOwnerRole" $root) "true" }}
        - CREATE ROLE {{ include "fairwinds-insights.timescaleOwnerRole" $root }} NOLOGIN
        - ALTER DATABASE {{ $root.Values.timescale.postgresqlDatabase }} OWNER TO {{ include "fairwinds-insights.timescaleOwnerRole" $root }}
        - ALTER SCHEMA public OWNER TO {{ include "fairwinds-insights.timescaleOwnerRole" $root }}
        - GRANT {{ include "fairwinds-insights.timescaleOwnerRole" $root }} TO {{ include "fairwinds-insights.timescaleMigrationUsername" $root }}
{{- end }}
{{- if eq (include "fairwinds-insights.timescaleSplitAppMigration" $root) "true" }}
        {{/* GRANTs here; app password and reconciliation via managed.roles below */}}
        - CREATE ROLE {{ include "fairwinds-insights.timescaleAppUsername" $root }} LOGIN
        - GRANT CONNECT ON DATABASE {{ $root.Values.timescale.postgresqlDatabase }} TO {{ include "fairwinds-insights.timescaleAppUsername" $root }}
        - GRANT pg_read_all_data, pg_write_all_data TO {{ include "fairwinds-insights.timescaleAppUsername" $root }}
{{- end }}
{{- else }}
      postInitSQL:
        - CREATE EXTENSION IF NOT EXISTS timescaledb;
{{- end }}
  superuserSecret:
    name: {{ $root.Values.timescale.auth.existingSuperUserSecret }}
{{- if eq (include "fairwinds-insights.timescaleRoleBootstrap" $root) "true" }}
  managed:
    roles:
{{- if eq (include "fairwinds-insights.timescaleUseOwnerRole" $root) "true" }}
      - name: {{ include "fairwinds-insights.timescaleOwnerRole" $root }}
        ensure: present
        login: false
        superuser: false
{{- end }}
{{- if eq (include "fairwinds-insights.timescaleSplitAppMigration" $root) "true" }}
      - name: {{ include "fairwinds-insights.timescaleAppUsername" $root }}
        ensure: present
        login: true
        superuser: false
        passwordSecret:
          name: {{ $root.Values.timescale.auth.existingSecret }}
        inRoles:
          - pg_read_all_data
          - pg_write_all_data
{{- end }}
{{- end }}
  storage:
    size: {{ $root.Values.timescale.storage.size }}
{{- if $root.Values.timescale.storage.storageClass }}
    storageClass: {{ $root.Values.timescale.storage.storageClass }}
{{- end }}
  resources:
{{- toYaml $root.Values.timescale.resources | nindent 4 }}
{{- end }}
