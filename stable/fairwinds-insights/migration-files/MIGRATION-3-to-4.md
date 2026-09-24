# Migrating fairwinds-insights Helm chart from 3.x to 4.x

Chart **4.0.0** introduces a **breaking change** for **ephemeral PostgreSQL**: the Bitnami PostgreSQL subchart is replaced by an in-cluster **CloudNativePG** `Cluster` (`insights-postgres`). Read this before upgrading production or any release that sets `postgresql` values.

For a concise list of release changes, see [CHANGELOG.md](./CHANGELOG.md).

## Summary

| Area | Chart 3.x | Chart 4.x |
|------|-----------|-----------|
| Ephemeral PostgreSQL | **Bitnami `postgresql` subchart** (StatefulSet), condition `postgresql.ephemeral` | **CloudNativePG** `Cluster` `insights-postgres` in-cluster (no Bitnami dependency) |
| PostgreSQL service / host | Subchart service **`insights-postgresql`** (`postgresql.fullnameOverride`) | CNPG read-write service: default **`insights-postgres-rw`** (`postgresql.postgresqlHost`) |
| PostgreSQL port value path | `postgresql.primary.service.port` (default **5432**) | **`postgresql.port`** (default **5432**) |
| PostgreSQL image | `fairwinds/postgres-partman` tag **`16.0`** | Same image, tag **`17.0`** |
| Storage / resources | `postgresql.primary.persistence` / `postgresql.primary.resources` | **`postgresql.storage`**, **`postgresql.resources`** |
| PostgreSQL tuning | Bitnami / subchart keys | **`postgresql.parameters`** (CNPG `Cluster` spec) |
| Credentials | Secret `fwinsights-postgresql` with key **`postgresql-password`** | Same Secret name; primary app key **`password`** ( **`postgresql-password`** also written for compatibility as of **4.0.2** ) |
| Superuser | Managed by Bitnami subchart | Separate Secret **`fwinsights-postgresql-superuser`** via **`postgresql.auth.existingSuperUserSecret`** |
| CNPG operator | — | Optional install via **`postgresql.operator`** (default **`install: true`**) |
| DB migration Job hook | `pre-install,pre-upgrade` unless `postgresql.ephemeral` or `postgresql.postMigrate` | Same rule restored in **4.0.3+**: ephemeral installs run migration **`post-install,post-upgrade`** by default |
| Bundled Temporal SQL stores | Default host **`insights-postgresql`** | Default host **`insights-postgres-rw`** (fixed in **4.0.4**; override if you use external Postgres) |
| Timescale | **`timescaledb-single` subchart** (unchanged in 4.x) | Still **`timescaledb-single`** when `timescale.ephemeral: true` |

## Who is affected

- **Ephemeral PostgreSQL** (`postgresql.ephemeral: true`): you must drop Bitnami subchart values, align with CNPG defaults, and plan for **new PVCs** and a **new database cluster** (no in-chart data migration from Bitnami).
- **External PostgreSQL** (`postgresql.ephemeral: false`): you already set `postgresql.postgresqlHost`. Update any copy-pasted default from **`insights-postgresql`** to your real endpoint; confirm port **5432** and TLS settings still match.
- **Bundled Temporal** (`temporal.enabled: true`): if you rely on chart defaults for SQL persistence hosts, they now target **`insights-postgres-rw`**. Override `temporal.server.config.persistence.datastores.*.sql.host` when Postgres is external or uses a custom Service name.
- **Clusters that already run CloudNativePG**: with **`postgresql.operator.install: true`**, the chart may install cluster-scoped operator resources and webhooks. Set **`postgresql.operator.install: false`** if an operator is already managed elsewhere, and ensure CRDs/webhooks do not conflict.

## Values to remove (no longer used in chart 4)

If your `values.yaml` or GitOps repo still sets these from the Bitnami subchart, **remove** them:

- `postgresql.fullnameOverride`
- `postgresql.primary.*` (including `primary.service.port`, `primary.persistence`, `primary.resources`)
- Any other **Bitnami-only** keys under `postgresql` (e.g. `architecture`, `metrics`, `volumePermissions`, subchart `global` overrides)

Timescale **`timescale.*`** Patroni / subchart fields are **unchanged** in chart 4; see [MIGRATION-7-to-8.md](./MIGRATION-7-to-8.md) when upgrading to chart 8.

## Values to set or review (chart 4)

1. **`postgresql.postgresqlHost`** — Default **`insights-postgres-rw`**. Point at the CNPG read-write Service, or your external host.
2. **`postgresql.port`** — Default **`5432`**. Replaces `postgresql.primary.service.port`.
3. **`postgresql.storage`** — **`size`**, **`storageClass`**. Replaces Bitnami `primary.persistence`.
4. **`postgresql.resources`** — Cluster pod resources (moved from `primary.resources`).
5. **`postgresql.parameters`** — PostgreSQL settings for the CNPG `Cluster` (replaces subchart tuning knobs).
6. **`postgresql.image.tag`** — Default **`17.0`**. Plan a major-version upgrade path if you depend on PG 16 data directories from chart 3.
7. **`postgresql.auth.existingSuperUserSecret`** — Default **`fwinsights-postgresql-superuser`**. Required for CNPG `superuserSecret`; set **`postgresql.auth.superuserpassword`** for a deterministic superuser password on greenfield ephemeral installs.
8. **`postgresql.auth.existingSecret`** — Still **`fwinsights-postgresql`**. Ensure the Secret exposes key **`password`** for app and migration workloads. Key **`postgresql-password`** is also populated for components that still expect the old name (Temporal subchart, etc.).
9. **`postgresql.operator`** — Review **`install`**, **`version`**, **`webhook`**, **`crds`**. Disable operator install when CNPG is already cluster-managed.
10. **`postgresql.postMigrate`** — Default **`false`**. With **`postgresql.ephemeral: true`**, the migration Job still runs **after** install/upgrade; set **`postMigrate: true`** for external Postgres if you need post-hook migrations.
11. **`temporal.server.config.persistence`** — Confirm SQL **`host`** values if you override Temporal persistence; chart defaults use **`insights-postgres-rw`**.

## Data and cluster lifecycle (ephemeral Bitnami → CNPG)

- Chart **4 does not migrate data** from the Bitnami PostgreSQL StatefulSet/PVC into the CNPG `insights-postgres` cluster. Storage layout and operators differ.
- **Greenfield / disposable dev clusters:** remove or orphan old Bitnami Postgres PVCs as appropriate, then install/upgrade chart 4; new CNPG PVCs and Secrets are created per chart rules.
- **Production with existing Postgres data:** plan **backup and restore** (or logical dump/restore) from the Bitnami instance to CNPG (or to external Postgres) before cutover. This guide does not replace a full DBA runbook.
- **PostgreSQL 16 → 17:** default image moves to **17.0**. Validate extension compatibility (`postgres-partman`, etc.) and follow PostgreSQL major-upgrade procedures if reusing data.

## Helm upgrade

1. Back up Helm values and, for production, database backups.
2. Merge your values with chart 4 defaults: remove obsolete Bitnami keys listed above.
3. If the cluster already has CNPG, decide whether **`postgresql.operator.install`** should be **`false`** to avoid duplicate operators/webhooks.
4. Run upgrade with hooks and jobs accounted for, for example:

   ```bash
   helm upgrade <release> fairwinds/fairwinds-insights --version 4.0.0 -f values.yaml --namespace <ns> --wait --wait-for-jobs
   ```

   Prefer the latest **4.0.x** patch (e.g. **4.0.5**) for follow-up fixes to Temporal hosts, migration hooks, and Secret keys.

5. Confirm the CNPG `Cluster` **`insights-postgres`** becomes **Ready**, Services **`insights-postgres-rw`** (and `-ro` if used) exist, and the **`migrate-database`** Job completes successfully.

## Operational notes

- **Webhook / CRD conflicts:** installing CNPG where another release already registered `cnpg-mutating-webhook-configuration` or `cnpg-validating-webhook-configuration` can fail. Resolve operator ownership before upgrade, or use an existing operator with **`postgresql.operator.install: false`**.
- **Pre-install Job RBAC:** when **`postgresql.operator.install: true`**, chart 4.0.0 uses a hook Job with cluster-scoped permissions to install the operator and create the cluster. Restricted clusters may require pre-provisioning CNPG and setting **`operator.install: false`**.
- **Local testing cleanup:** [cleanup-cloudnative-pg.sh](./cleanup-cloudnative-pg.sh) can remove conflicting CNPG webhooks/CRDs in dev only; do **not** use it against production clusters with existing CNPG data.

## Further reading

- Self-hosted installation overview: [insights.docs.fairwinds.com — installation](https://insights.docs.fairwinds.com/technical-details/self-hosted/installation/)
- CloudNativePG documentation: [cloudnative-pg.io](https://cloudnative-pg.io/documentation/current/)
- [CHANGELOG.md](./CHANGELOG.md) for 4.0.0 and earlier releases
