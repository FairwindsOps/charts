<div align="center">
<a href="https://github.com/FairwindsOps/goldilocks"><img src="logo.svg" height="150" alt="Goldilocks" style="padding-bottom: 20px" /></a>
<br>
</div>

# timescaledb-single

![Version: 0.21.0](https://img.shields.io/badge/Version-0.21.0-informational?style=flat-square) ![AppVersion: 0.21.0](https://img.shields.io/badge/AppVersion-0.21.0-informational?style=flat-square)

TimescaleDB HA Deployment.

**Homepage:** <https://github.com/timescale/helm-charts>

## Source Code

* <https://github.com/timescale/helm-charts>
* <https://github.com/timescale/timescaledb-docker-ha>
* <https://github.com/zalando/patroni>

## Values

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| replicaCount | int | `3` |  |
| fullnameOverride | string | `"{{ .Release.Name }}"` |  |
| clusterName | string | `""` |  |
| version | string | `nil` |  |
| image.repository | string | `"timescale/timescaledb-ha"` |  |
| image.tag | string | `"pg14.13-ts2.17.1-all"` |  |
| image.pullPolicy | string | `"Always"` |  |
| curlImage.repository | string | `"curlimages/curl"` |  |
| curlImage.tag | string | `"7.87.0"` |  |
| curlImage.pullPolicy | string | `"Always"` |  |
| secrets.credentials.PATRONI_SUPERUSER_PASSWORD | string | `""` |  |
| secrets.credentials.PATRONI_REPLICATION_PASSWORD | string | `""` |  |
| secrets.credentials.PATRONI_admin_PASSWORD | string | `""` |  |
| secrets.credentialsSecretName | string | `""` |  |
| secrets.certificate."tls.crt" | string | `""` |  |
| secrets.certificate."tls.key" | string | `""` |  |
| secrets.certificateSecretName | string | `""` |  |
| secrets.pgbackrest | object | `{}` |  |
| secrets.pgbackrestSecretName | string | `""` |  |
| backup.enabled | bool | `false` |  |
| backup.pgBackRest.compress-type | string | `"lz4"` |  |
| backup.pgBackRest.process-max | int | `4` |  |
| backup.pgBackRest.start-fast | string | `"y"` |  |
| backup.pgBackRest.repo1-retention-diff | int | `2` |  |
| backup.pgBackRest.repo1-retention-full | int | `2` |  |
| backup.pgBackRest.repo1-cipher-type | string | `"none"` |  |
| backup.pgBackRest:archive-push | object | `{}` |  |
| backup.pgBackRest:archive-get | object | `{}` |  |
| backup.jobs[0].name | string | `"full-weekly"` |  |
| backup.jobs[0].type | string | `"full"` |  |
| backup.jobs[0].schedule | string | `"12 02 * * 0"` |  |
| backup.jobs[1].name | string | `"incremental-daily"` |  |
| backup.jobs[1].type | string | `"incr"` |  |
| backup.jobs[1].schedule | string | `"12 02 * * 1-6"` |  |
| backup.envFrom | string | `nil` |  |
| backup.env | string | `nil` |  |
| backup.resources | object | `{}` |  |
| bootstrapFromBackup.enabled | bool | `false` |  |
| bootstrapFromBackup.repo1-path | string | `nil` |  |
| bootstrapFromBackup.secretName | string | `"pgbackrest-bootstrap"` |  |
| env | string | `nil` |  |
| envFrom | string | `nil` |  |
| patroni.log.level | string | `"WARNING"` |  |
| patroni.bootstrap.method | string | `"restore_or_initdb"` |  |
| patroni.bootstrap.restore_or_initdb.command | string | `"/etc/timescaledb/scripts/restore_or_initdb.sh --encoding=UTF8 --locale=C.UTF-8\n"` |  |
| patroni.bootstrap.restore_or_initdb.keep_existing_recovery_conf | bool | `true` |  |
| patroni.bootstrap.post_init | string | `"/etc/timescaledb/scripts/post_init.sh"` |  |
| patroni.bootstrap.dcs.loop_wait | int | `10` |  |
| patroni.bootstrap.dcs.maximum_lag_on_failover | int | `33554432` |  |
| patroni.bootstrap.dcs.postgresql.parameters.archive_command | string | `"/etc/timescaledb/scripts/pgbackrest_archive.sh %p"` |  |
| patroni.bootstrap.dcs.postgresql.parameters.archive_mode | string | `"on"` |  |
| patroni.bootstrap.dcs.postgresql.parameters.archive_timeout | string | `"1800s"` |  |
| patroni.bootstrap.dcs.postgresql.parameters.autovacuum_analyze_scale_factor | float | `0.02` |  |
| patroni.bootstrap.dcs.postgresql.parameters.autovacuum_naptime | string | `"5s"` |  |
| patroni.bootstrap.dcs.postgresql.parameters.autovacuum_max_workers | int | `10` |  |
| patroni.bootstrap.dcs.postgresql.parameters.autovacuum_vacuum_cost_limit | int | `500` |  |
| patroni.bootstrap.dcs.postgresql.parameters.autovacuum_vacuum_scale_factor | float | `0.05` |  |
| patroni.bootstrap.dcs.postgresql.parameters.log_autovacuum_min_duration | string | `"1min"` |  |
| patroni.bootstrap.dcs.postgresql.parameters.hot_standby | string | `"on"` |  |
| patroni.bootstrap.dcs.postgresql.parameters.log_checkpoints | string | `"on"` |  |
| patroni.bootstrap.dcs.postgresql.parameters.log_connections | string | `"on"` |  |
| patroni.bootstrap.dcs.postgresql.parameters.log_disconnections | string | `"on"` |  |
| patroni.bootstrap.dcs.postgresql.parameters.log_line_prefix | string | `"%t [%p]: [%c-%l] %u@%d,app=%a [%e] "` |  |
| patroni.bootstrap.dcs.postgresql.parameters.log_lock_waits | string | `"on"` |  |
| patroni.bootstrap.dcs.postgresql.parameters.log_min_duration_statement | string | `"1s"` |  |
| patroni.bootstrap.dcs.postgresql.parameters.log_statement | string | `"ddl"` |  |
| patroni.bootstrap.dcs.postgresql.parameters.max_connections | int | `100` |  |
| patroni.bootstrap.dcs.postgresql.parameters.max_prepared_transactions | int | `150` |  |
| patroni.bootstrap.dcs.postgresql.parameters.shared_preload_libraries | string | `"timescaledb,pg_stat_statements"` |  |
| patroni.bootstrap.dcs.postgresql.parameters.ssl | string | `"on"` |  |
| patroni.bootstrap.dcs.postgresql.parameters.ssl_cert_file | string | `"/etc/certificate/tls.crt"` |  |
| patroni.bootstrap.dcs.postgresql.parameters.ssl_key_file | string | `"/etc/certificate/tls.key"` |  |
| patroni.bootstrap.dcs.postgresql.parameters.tcp_keepalives_idle | int | `900` |  |
| patroni.bootstrap.dcs.postgresql.parameters.tcp_keepalives_interval | int | `100` |  |
| patroni.bootstrap.dcs.postgresql.parameters.temp_file_limit | string | `"1GB"` |  |
| patroni.bootstrap.dcs.postgresql.parameters."timescaledb.passfile" | string | `"../.pgpass"` |  |
| patroni.bootstrap.dcs.postgresql.parameters.unix_socket_directories | string | `"/var/run/postgresql"` |  |
| patroni.bootstrap.dcs.postgresql.parameters.unix_socket_permissions | string | `"0750"` |  |
| patroni.bootstrap.dcs.postgresql.parameters.wal_level | string | `"hot_standby"` |  |
| patroni.bootstrap.dcs.postgresql.parameters.wal_log_hints | string | `"on"` |  |
| patroni.bootstrap.dcs.postgresql.use_pg_rewind | bool | `true` |  |
| patroni.bootstrap.dcs.postgresql.use_slots | bool | `true` |  |
| patroni.bootstrap.dcs.retry_timeout | int | `10` |  |
| patroni.bootstrap.dcs.ttl | int | `30` |  |
| patroni.kubernetes.role_label | string | `"role"` |  |
| patroni.kubernetes.scope_label | string | `"cluster-name"` |  |
| patroni.kubernetes.use_endpoints | bool | `true` |  |
| patroni.postgresql.create_replica_methods[0] | string | `"pgbackrest"` |  |
| patroni.postgresql.create_replica_methods[1] | string | `"basebackup"` |  |
| patroni.postgresql.pgbackrest.command | string | `"/etc/timescaledb/scripts/pgbackrest_restore.sh"` |  |
| patroni.postgresql.pgbackrest.keep_data | bool | `true` |  |
| patroni.postgresql.pgbackrest.no_params | bool | `true` |  |
| patroni.postgresql.pgbackrest.no_master | bool | `true` |  |
| patroni.postgresql.basebackup[0].waldir | string | `"/var/lib/postgresql/wal/pg_wal"` |  |
| patroni.postgresql.recovery_conf.restore_command | string | `"/etc/timescaledb/scripts/pgbackrest_archive_get.sh %f \"%p\""` |  |
| patroni.postgresql.callbacks.on_role_change | string | `"/etc/timescaledb/scripts/patroni_callback.sh"` |  |
| patroni.postgresql.callbacks.on_start | string | `"/etc/timescaledb/scripts/patroni_callback.sh"` |  |
| patroni.postgresql.callbacks.on_reload | string | `"/etc/timescaledb/scripts/patroni_callback.sh"` |  |
| patroni.postgresql.callbacks.on_restart | string | `"/etc/timescaledb/scripts/patroni_callback.sh"` |  |
| patroni.postgresql.callbacks.on_stop | string | `"/etc/timescaledb/scripts/patroni_callback.sh"` |  |
| patroni.postgresql.authentication.replication.username | string | `"standby"` |  |
| patroni.postgresql.authentication.superuser.username | string | `"postgres"` |  |
| patroni.postgresql.listen | string | `"0.0.0.0:5432"` |  |
| patroni.postgresql.pg_hba[0] | string | `"local     all             postgres                              peer"` |  |
| patroni.postgresql.pg_hba[1] | string | `"local     all             all                                   md5"` |  |
| patroni.postgresql.pg_hba[2] | string | `"hostnossl all,replication all                all                reject"` |  |
| patroni.postgresql.pg_hba[3] | string | `"hostssl   all             all                127.0.0.1/32       md5"` |  |
| patroni.postgresql.pg_hba[4] | string | `"hostssl   all             all                ::1/128            md5"` |  |
| patroni.postgresql.pg_hba[5] | string | `"hostssl   replication     standby            all                md5"` |  |
| patroni.postgresql.pg_hba[6] | string | `"hostssl   all             all                all                md5"` |  |
| patroni.postgresql.use_unix_socket | bool | `true` |  |
| patroni.restapi.listen | string | `"0.0.0.0:8008"` |  |
| callbacks.configMap | string | `nil` |  |
| postInit[0].configMap.name | string | `"custom-init-scripts"` |  |
| postInit[0].configMap.optional | bool | `true` |  |
| postInit[1].secret.name | string | `"custom-secret-scripts"` |  |
| postInit[1].secret.optional | bool | `true` |  |
| service.primary.type | string | `"ClusterIP"` |  |
| service.primary.port | int | `5432` |  |
| service.primary.nodePort | string | `nil` |  |
| service.primary.labels | object | `{}` |  |
| service.primary.annotations | object | `{}` |  |
| service.primary.spec | object | `{}` |  |
| service.replica.type | string | `"ClusterIP"` |  |
| service.replica.port | int | `5432` |  |
| service.replica.nodePort | string | `nil` |  |
| service.replica.labels | object | `{}` |  |
| service.replica.annotations | object | `{}` |  |
| service.replica.spec | object | `{}` |  |
| readinessProbe.enabled | bool | `true` |  |
| readinessProbe.initialDelaySeconds | int | `5` |  |
| readinessProbe.periodSeconds | int | `30` |  |
| readinessProbe.timeoutSeconds | int | `5` |  |
| readinessProbe.failureThreshold | int | `6` |  |
| readinessProbe.successThreshold | int | `1` |  |
| persistentVolumes.data.enabled | bool | `true` |  |
| persistentVolumes.data.size | string | `"2Gi"` |  |
| persistentVolumes.data.subPath | string | `""` |  |
| persistentVolumes.data.mountPath | string | `"/var/lib/postgresql"` |  |
| persistentVolumes.data.annotations | object | `{}` |  |
| persistentVolumes.data.accessModes[0] | string | `"ReadWriteOnce"` |  |
| persistentVolumes.wal.enabled | bool | `true` |  |
| persistentVolumes.wal.size | string | `"1Gi"` |  |
| persistentVolumes.wal.subPath | string | `""` |  |
| persistentVolumes.wal.storageClass | string | `nil` |  |
| persistentVolumes.wal.mountPath | string | `"/var/lib/postgresql/wal"` |  |
| persistentVolumes.wal.annotations | object | `{}` |  |
| persistentVolumes.wal.accessModes[0] | string | `"ReadWriteOnce"` |  |
| resources | object | `{}` |  |
| sharedMemory.useMount | bool | `false` |  |
| timescaledbTune.enabled | bool | `true` |  |
| timescaledbTune.args | object | `{}` |  |
| pgBouncer.enabled | bool | `false` |  |
| pgBouncer.port | int | `6432` |  |
| pgBouncer.config.server_reset_query | string | `"DISCARD ALL"` |  |
| pgBouncer.config.max_client_conn | int | `500` |  |
| pgBouncer.config.default_pool_size | int | `12` |  |
| pgBouncer.config.pool_mode | string | `"transaction"` |  |
| pgBouncer.pg_hba[0] | string | `"local     all postgres                   peer"` |  |
| pgBouncer.pg_hba[1] | string | `"host      all postgres,standby 0.0.0.0/0 reject"` |  |
| pgBouncer.pg_hba[2] | string | `"host      all postgres,standby ::0/0     reject"` |  |
| pgBouncer.pg_hba[3] | string | `"hostssl   all all              0.0.0.0/0 md5"` |  |
| pgBouncer.pg_hba[4] | string | `"hostssl   all all              ::0/0     md5"` |  |
| pgBouncer.pg_hba[5] | string | `"hostnossl all all              0.0.0.0/0 reject"` |  |
| pgBouncer.pg_hba[6] | string | `"hostnossl all all              ::0/0     reject"` |  |
| pgBouncer.userListSecretName | string | `nil` |  |
| networkPolicy.enabled | bool | `false` |  |
| networkPolicy.prometheusApp | string | `"prometheus"` |  |
| networkPolicy.ingress | string | `nil` |  |
| nodeSelector | object | `{}` |  |
| prometheus.enabled | bool | `false` |  |
| prometheus.image.repository | string | `"quay.io/prometheuscommunity/postgres-exporter"` |  |
| prometheus.image.tag | string | `"v0.11.1"` |  |
| prometheus.image.pullPolicy | string | `"Always"` |  |
| prometheus.env | string | `nil` |  |
| prometheus.args | list | `[]` |  |
| prometheus.volumes | string | `nil` |  |
| prometheus.volumeMounts | string | `nil` |  |
| podMonitor.enabled | bool | `false` |  |
| podMonitor.path | string | `"/metrics"` |  |
| podMonitor.interval | string | `"10s"` |  |
| podManagementPolicy | string | `"OrderedReady"` |  |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| tolerations | list | `[]` |  |
| affinity | object | `{}` |  |
| topologySpreadConstraints | list | `[]` |  |
| rbac.create | bool | `true` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `nil` |  |
| serviceAccount.annotations | object | `{}` |  |
| debug.execStartPre | string | `nil` |  |
