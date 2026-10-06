# Migrating fairwinds-insights Helm chart from 7.x to 8.x

Chart 8.0.0 introduces **breaking changes** around **ephemeral TimescaleDB**. Read this before upgrading production or any release that sets `timescale` values.

For a concise list of release changes, see [CHANGELOG.md](./CHANGELOG.md).

## Summary

| Area | Chart 7.x | Chart 8.x |
|------|-----------|-----------|
| Ephemeral Timescale | **`timescaledb-single` subchart** (Patroni), condition `timescale.ephemeral` | **CloudNativePG** `Cluster` `insights-timescale` in-cluster (no `timescaledb-single` dependency) |
| Timescale service / host | Subchart service name (often `timescale` or overridden) | CNPG read-write service: default **`insights-timescale-rw`** (`timescale.postgresqlHost`) |
| Timescale port | Default **5433** (`timescale.service.primary.port`) | Default **5432** |
| Timescale credentials | Subchart-style values (e.g. `password`, Patroni-related secrets) | **`timescale.auth`**: `existingSecret` / `existingSuperUserSecret` (chart creates Secrets when ephemeral unless you override) |
| Optional component | — | **`outboxWorker`** Deployment (default **enabled**; API outbox worker) |

## Who is affected

- **Ephemeral Timescale** (`timescale.ephemeral: true`): you must align values with the new CNPG-based defaults and drop obsolete `timescaledb-single` / Patroni fields.
- **External Timescale** (`timescale.ephemeral: false`): you already set `timescale.postgresqlHost` (and related connection settings). Confirm **port** and **TLS** match your endpoint; chart defaults for port moved to **5432** for ephemeral installs—override if your external DB still uses another port.
- **Operators installing CNPG via this chart** (`postgresql.operator.install: true`): optional new value `postgresql.operator.clusterReadyTimeoutSeconds` controls how long the pre-install Job waits for clusters to become Ready (default `600`).

## Values to remove (no longer used in chart 8)

If your `values.yaml` or GitOps repo still sets these under `timescale` from the old subchart, **remove** them so upgrades do not carry dead configuration:

- `fullnameOverride`, `replicaCount`, `clusterName`
- `pdb` (and related PDB fields)
- `patroni` (including `patroni.postgresql.*`, `patroni.log`, etc.)
- `timescaledbTune`
- `rbac`, `serviceAccount` (Timescale-specific subchart RBAC)
- Any Patroni-specific secret key expectations (e.g. `PATRONI_*`); ephemeral Timescale now uses standard PostgreSQL-style secrets as documented in [values.yaml](./values.yaml) under `timescale.auth`.

## Values to set or review (chart 8)

1. **`timescale.postgresqlHost`** — Default is **`insights-timescale-rw`** (CNPG `-rw` service). Point this at your CNPG read-write Service if you customize names or use external Timescale.
2. **`timescale.service.primary.port`** — Default **`5432`**. Update app/env overrides that assumed **5433**.
3. **`timescale.auth`** — When using chart-managed Secrets for ephemeral Timescale, ensure **`existingSecret`** and **`existingSuperUserSecret`** match the Secret names you use (defaults: `fwinsights-timescale`, `fwinsights-timescale-superuser`). Set **`timescale.password`** / **`timescale.superuserpassword`** if you need deterministic passwords (otherwise random on install).
4. **`timescale.image`**, **`timescale.imageCatalog`**, **`timescale.postgresUID` / `postgresGID`**, **`timescale.sharedPreloadLibraries`**, **`timescale.parameters`**, **`timescale.storage`** — Review defaults in [values.yaml](./values.yaml); they apply to the CNPG Timescale cluster.
5. **`outboxWorker`** — New Deployment (default **`enabled: true`**). Disable with `outboxWorker.enabled: false` only if your Insights version/deployment model does not use it; tune resources under `outboxWorker.resources` as needed.

## Data and cluster lifecycle (ephemeral → CNPG)

- Chart **8 does not migrate data** from a v7 **`timescaledb-single`** PVC/StatefulSet into the new CNPG `insights-timescale` cluster. Those are different storage and operator models.
- **Greenfield / disposable dev clusters:** uninstall or delete the old release resources as appropriate, then install/upgrade chart 8; new PVCs and CNPG clusters will be created per chart rules.
- **Production with existing Timescale data:** plan a **backup and restore** (or logical dump/restore) from the old cluster to a new CNPG-backed instance, or keep Timescale **external** (`timescale.ephemeral: false`) and migrate the database out-of-band before switching traffic. This guide does not replace a full DBA runbook.

## Helm upgrade

1. Back up Helm values and, for production, database backups.
2. Merge your values with chart 8 defaults: remove obsolete keys listed above.
3. Run upgrade with hooks and jobs accounted for, for example:

   ```bash
   helm upgrade <release> fairwinds/fairwinds-insights --version 8.0.0 -f values.yaml --namespace <ns> --wait --wait-for-jobs
   ```

4. Confirm CNPG `Cluster` objects (`insights-postgres`, `insights-timescale` when ephemeral) become **Ready**, and that migration Jobs (`migrate-database`, etc.) complete successfully.

## PostgreSQL CNPG superuser reference (operational note)

Chart 8 fixes the pre-install Job so the PostgreSQL `Cluster` uses **`postgresql.auth.existingSuperUserSecret`** for `superuserSecret` (not the app secret). Existing clusters are unchanged until the `Cluster` spec is reapplied; new installs behave correctly when app and superuser secrets differ.

## Further reading

- Self-hosted installation overview: [insights.docs.fairwinds.com — installation](https://insights.docs.fairwinds.com/technical-details/self-hosted/installation/)
- [CHANGELOG.md](./CHANGELOG.md) for 8.0.0 and earlier releases
