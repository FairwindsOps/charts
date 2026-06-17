# Migrating fairwinds-insights Helm chart from 5.x to 6.x

Chart **6.0.0** introduces a **breaking change** for **ephemeral TimescaleDB**: the bundled **`timescaledb-single`** subchart moves from **0.34.\*** to **0.35.\***, and the default **`timescale/timescaledb-ha`** image from **`pg14.17-ts2.19.3-all`** to **`pg17.7-ts2.24.0-all`**. Read this before upgrading production or any release that sets `timescale` values.

For a concise list of release changes, see [CHANGELOG.md](./CHANGELOG.md).

## Summary

| Area | Chart 5.x | Chart 6.x |
|------|-----------|-----------|
| Ephemeral Timescale subchart | **`timescaledb-single` 0.34.\*** | **`timescaledb-single` 0.35.\*** |
| Default Timescale image | **`timescale/timescaledb-ha:pg14.17-ts2.19.3-all`** | **`timescale/timescaledb-ha:pg17.7-ts2.24.0-all`** |
| PostgreSQL major (image) | **14** | **17** |
| TimescaleDB extension (image) | **2.19.3** | **2.24.0** |
| Service / host / port | Subchart service **`timescale`**, port **5433** | Unchanged at 6.0.0 |
| Patroni / values shape | `timescale.fullnameOverride`, `patroni`, `timescaledbTune`, etc. | Unchanged at 6.0.0 |
| PostgreSQL (CNPG) | Unchanged in 6.0.0 | Unchanged at 6.0.0; **`postgresql.operator.version`** defaults to **`latest`** from **6.1.1** (see below) |
| Temporal / workers / CronJobs | See [MIGRATION-4-to-5.md](./MIGRATION-4-to-5.md) | Unchanged at 6.0.0; Temporal subchart bumped to **0.73.2** in **6.2.0** |
| Later major upgrades | — | Timescale **CNPG** migration in chart **8**: [MIGRATION-7-to-8.md](./MIGRATION-7-to-8.md); object storage (**RustFS**) in chart **7**: [MIGRATION-6-to-7.md](./MIGRATION-6-to-7.md) |

## Who is affected

- **Ephemeral Timescale** (`timescale.ephemeral: true`): upgrading to chart **6.0.0+** pulls the **PostgreSQL 17 / TimescaleDB 2.24** image. Existing **Patroni PVC data from PostgreSQL 14 will not start** on the new image without a planned **major-version upgrade** (pg_upgrade) or **logical dump/restore**.
- **Anyone who pinned `timescale.image.tag`** to the old **`pg14.*`** line: remove or update the override so it matches your upgrade plan; leaving a PG 14 tag on subchart **0.35.\*** is unsupported.
- **External Timescale** (`timescale.ephemeral: false`): the subchart image bump does not change your database. Confirm your external instance meets Insights application requirements for PostgreSQL / TimescaleDB versions before upgrading the chart.
- **Greenfield / disposable dev clusters:** a normal `helm upgrade` to chart 6 is usually sufficient; old Timescale PVCs can be deleted if data loss is acceptable.

## Values to remove (no longer used in chart 6)

Chart **6.0.0** does not remove Timescale value keys. If you added overrides only to stay on the old image indefinitely, plan to drop them once migration is complete:

- **`timescale.image.tag: pg14.17-ts2.19.3-all`** (or other **`pg14.*`** pins) — temporary only; do not carry into production without an explicit upgrade runbook.

## Values to set or review (chart 6)

1. **`timescale.ephemeral`** — Default **`true`**. Set **`false`** when Timescale is managed outside the chart and you only need connection settings (`timescale.postgresqlHost`, credentials, TLS).

2. **`timescale.image.repository`** / **`timescale.image.tag`** — Defaults come from subchart **0.35.\*** (**`pg17.7-ts2.24.0-all`** at 6.0.0). Override only when you have validated a different supported image tag.

3. **`timescale.postgresqlHost`** — Still **`timescale`** for bundled ephemeral installs. External installs should already point at your endpoint.

4. **`timescale.service.primary.port`** — Still **5433** for the Patroni subchart. Application connection env vars follow chart defaults unless you override them.

5. **`timescale.password`** / **`timescale.secrets.*`** — Credential layout is unchanged at 6.0.0. After dump/restore or pg_upgrade, ensure Secrets still match the restored database.

6. **`postgresql.operator.version`** — From **6.1.1**, default **`latest`** (resolved at install time; fallback **`postgresql.operator.defaultVersion`**). Pin an explicit version if your cluster must not pull a newer CloudNativePG operator during upgrade.

7. **`temporal.enabled`** / **`temporalDeployments`** — Unchanged by 6.0.0. From **6.2.0**, bundled Temporal subchart is **0.73.2**; review custom `temporal:` overrides if you pin subchart behavior.

8. **`rustfs`** / **`reportStorage.strategy`** — Optional preview in **6.3.0** (`rustfs.install`, `reportStorage.strategy: rustfs`). Not required for 5→6; becomes breaking in chart **7.0.0** ([MIGRATION-6-to-7.md](./MIGRATION-6-to-7.md)).

## Data and cluster lifecycle (ephemeral Timescale image bump)

- Chart **6 does not migrate data** from PostgreSQL **14** to **17** on existing Patroni PVCs. A rolling upgrade that only changes the Helm release will leave Pods crash-looping or fail Patroni bootstrap against incompatible data directories.
- **Production with existing Timescale data:** plan one of:
  - **Logical dump/restore** (e.g. `pg_dump` / `pg_restore` or Timescale-aware backup tools) from the chart 5 cluster into a new PG 17 instance, then cut over `timescale.postgresqlHost` / Secrets.
  - **`pg_upgrade`** using Timescale’s documented procedure for `timescaledb-ha` images ([Timescale upgrade docs](https://docs.timescale.com/)).
  - Keep Timescale **external** (`timescale.ephemeral: false`) and upgrade the database out-of-band before moving the Insights release to chart 6.
- **Greenfield / disposable dev clusters:** delete the old Timescale StatefulSet PVCs (or uninstall the release), then upgrade/install chart 6 so new storage initializes on PG 17.
- **Extension compatibility:** validate Insights application release notes and any custom SQL against **TimescaleDB 2.24** on **PostgreSQL 17**.

## Helm upgrade

1. Back up Helm values and, for production, Timescale and PostgreSQL backups.
2. Decide the Timescale path: **in-place major upgrade**, **restore to new storage**, or **external DB** with `timescale.ephemeral: false`.
3. Merge your values with chart 6 defaults; remove temporary `timescale.image.tag` pins on PG 14 unless you are deliberately deferring the image bump (not recommended long-term).
4. Run upgrade with hooks and jobs accounted for, for example:

   ```bash
   helm upgrade <release> fairwinds/fairwinds-insights --version 6.0.0 -f values.yaml --namespace <ns> --wait --wait-for-jobs
   ```

   Prefer the latest **6.x** patch (e.g. **6.3.0**) for CNPG operator resolution (**6.1.1**), Temporal **0.73.2** (**6.2.0**), and optional RustFS support (**6.3.0**).

5. Confirm the Timescale StatefulSet Pods are **Ready**, Patroni reports a healthy primary, and hook Jobs (**`migrate-database`**, **`one-time-migration`** when applicable) complete successfully.

## Operational notes

- **Downtime:** Patroni failovers during image changes can cause brief disruption; major-version upgrades should be executed in a maintenance window with a tested rollback plan.
- **Subchart-only change:** Fairwinds Insights `timescale.*` keys in [values.yaml](./values.yaml) at 6.0.0 match chart 5 layout; the break is the **default image** inside **`timescaledb-single` 0.35.\***, not a rename of connection settings.
- **Migration Job timing:** chart **5.6.0+** runs **`migrate-database`** post-install/post-upgrade when **`timescale.ephemeral: true`**. Ensure you are on **5.6.0+** before jumping to 6 if you rely on that hook ordering.
- **Insights application version:** chart **6.0.x** targets Insights **18.2** (see [CHANGELOG.md](./CHANGELOG.md) for exact `appVersion` per patch). Validate application release notes before upgrading production.

## Further reading

- Self-hosted installation overview: [insights.docs.fairwinds.com — installation](https://insights.docs.fairwinds.com/technical-details/self-hosted/installation/)
- Temporal migration (chart 5): [MIGRATION-4-to-5.md](./MIGRATION-4-to-5.md)
- [CHANGELOG.md](./CHANGELOG.md) for 6.0.0 and earlier releases
- Timescale `timescaledb-single` subchart: [incubator/timescale](../../incubator/timescale/)
