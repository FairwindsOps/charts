# Migrating fairwinds-insights Helm chart from 4.x to 5.x

Chart **5.0.0** introduces **breaking changes** around **Temporal**: the bundled Temporal server is **enabled by default**, background work moves from CronJobs and standalone Deployments to **Temporal worker** Deployments, and the **`cluster-deletion` CronJob is removed**. Read this before upgrading production or any release that sets `temporal`, `temporalDeployments`, or `cronjobs` values.

For a concise list of release changes, see [CHANGELOG.md](./CHANGELOG.md).

## Summary

| Area | Chart 4.x | Chart 5.x |
|------|-----------|-----------|
| Bundled Temporal server | **`temporal.enabled: false`** (opt-in) | **`temporal.enabled: true`** (default) |
| Temporal client env | `temporal.hostPort` / `temporal.namespace` (added in 4.1.0) | Unchanged defaults: **`insights-temporal-frontend:7233`**, namespace **`fwinsights`** |
| Org / cluster hard delete | **`cronjobs.cluster-deletion`** CronJob (`cluster_deletion`, every 15m) | **`temporalDeployments.delete-org-cluster-worker`** Deployment (`delete_organization_and_cluster_worker`) |
| Worker Deployments | — | **`temporalDeploymentDefaults`** and **`temporalDeployments`** (HPA/PDB templates per worker) |
| Default workers (5.0.0) | — | **`delete-org-cluster-worker`** enabled |
| Additional workers | — | **`general-worker`** default enabled as of **5.0.3**; **`github-worker`** as of **5.4.0** |
| Notification digests | **`cronjobs.alerts-realtime`**, **`cronjobs.notifications-digest`** | **Removed in 5.2.0** — use **`temporalSchedulers`** (added in **5.8.0**) or external scheduling |
| Repo scan / automated PR | **`repoScanJob`**, **`automatedPullRequestJob`** Deployments | **Removed in 5.4.2** — handled by Temporal workflows / **`github-worker`** |
| One-time data migrations | — | **`one-time-migration`** Helm hook Job (**5.1.0+**, `post-install,post-upgrade`) |
| DB migration hook override | — | **`dbMigration.overrideHook`** (**5.6.0+**): `""`, `none`, or custom hook list |
| PostgreSQL / Timescale | CNPG / `timescaledb-single` (unchanged in 5.0.0) | Unchanged at 5.0.0; see [MIGRATION-3-to-4.md](./MIGRATION-3-to-4.md) and [MIGRATION-7-to-8.md](./MIGRATION-7-to-8.md) for later major upgrades |

## Who is affected

- **Installs that relied on chart 4 defaults** (`temporal.enabled: false`): upgrade to chart 5 **deploys the Temporal server subchart** and creates **`temporal`** / **`temporal_visibility`** databases on the configured PostgreSQL host unless you opt out.
- **Anyone using `cronjobs.cluster-deletion`**: the CronJob is **removed**; hard deletes require a running Temporal cluster and **`delete-org-cluster-worker`** (or equivalent worker elsewhere).
- **Anyone with custom notification schedules** under **`cronjobs.alerts-realtime`** or **`cronjobs.notifications-digest`**: remove those keys when upgrading to **5.2.0+** and replace with Temporal schedules or another mechanism.
- **Anyone enabling `repoScanJob` or `automatedPullRequestJob`**: remove those value blocks when upgrading to **5.4.2+**; ensure **`github-worker`** (and bundled Temporal) meet your GitHub integration needs.
- **External Temporal** (`temporal.enabled: false`): you can still skip the bundled server, but **Insights Temporal worker Deployments render independently** of `temporal.enabled`. Point **`temporal.hostPort`** at your frontend and ensure namespace **`fwinsights`** exists, or disable individual entries under **`temporalDeployments`**.

## Values to remove (no longer used in chart 5)

If your `values.yaml` or GitOps repo still sets these, **remove** them:

- **`cronjobs.cluster-deletion`** (and any `cronjobOptions` overrides only used for that job)
- **`cronjobs.alerts-realtime`**, **`cronjobs.notifications-digest`** (removed in **5.2.0**)
- **`repoScanJob.*`**, **`automatedPullRequestJob.*`** (removed in **5.4.2**)

## Values to set or review (chart 5)

1. **`temporal.enabled`** — Default **`true`**. Set **`false`** only when Temporal is managed outside this chart **and** you accept that Insights worker Deployments still connect via **`temporal.hostPort`** unless you disable them under **`temporalDeployments`**.

2. **`temporal.hostPort`** / **`temporal.namespace`** — Defaults **`insights-temporal-frontend:7233`** and **`fwinsights`**. Override for external Temporal or custom Service names.

3. **`temporalDeployments`** — Per-worker settings (`enabled`, `command`, `resources`, `hpa`, `pdb`, `rbac`, `additionalEnv`, `volumes`, etc.). At minimum review:
   - **`delete-org-cluster-worker`** — replaces **`cluster-deletion`**; default **`enabled: true`**, HPA fixed at 1 replica.
   - **`general-worker`** — default **`enabled: true`** from **5.0.3**; handles general Temporal task queues.
   - **`github-worker`** — default **`enabled: true`** from **5.4.0**; requires **`github-secrets`** volume (optional Secret) and RBAC for Job orchestration when enabled.

4. **`temporalDeploymentDefaults`** — Shared defaults for all workers (resources, securityContext, HPA, PDB, optional GitHub secret volume mounts). Tune cluster-wide worker behavior here before per-worker overrides.

5. **`temporal.server.config.persistence`** — When **`temporal.enabled: true`**, defaults create **`temporal`** and **`temporal_visibility`** databases on **`insights-postgres-rw`** (or your overridden SQL host). Confirm PostgreSQL capacity, credentials (`fwinsights-postgresql`, key **`password`**), and TLS settings match your layout.

6. **`oneTimeMigration`** — From **5.1.0**, a **`one-time-migration`** Job runs on **`post-install,post-upgrade`** hooks. Review **`resources`** and **`additionalEnv`** if the hook competes with other Jobs during upgrade.

7. **`dbMigration.overrideHook`** — From **5.6.0**, override migrate-database hook behavior: **`""`** (chart default), **`none`** (normal Job, no hook), or a comma-separated hook list.

8. **`temporalSchedulers`** / **`temporalSchedulersJob`** — From **5.8.0**, define Temporal workflow schedules in values when replacing removed notification CronJobs or adding new scheduled workflows.

## Operational notes

- **Resource footprint:** enabling bundled Temporal adds server subchart pods plus worker Deployments. Size the cluster and PostgreSQL connection limits accordingly (`POSTGRES_MAX_*` on workers are set per deployment in defaults).
- **Cluster deletion behavior:** the old CronJob polled every 15 minutes; the Temporal worker processes delete workflows from a task queue. Deletion will not run if Temporal is down or workers are scaled to zero.
- **Worker vs server:** `temporal.enabled` controls only the **Temporal server subchart**. Worker Deployments are controlled by **`temporalDeployments.<name>.enabled`**.
- **Insights application version:** chart **5.0.x** targets Insights **18.x** (see [CHANGELOG.md](./CHANGELOG.md) for exact `appVersion` per patch). Validate application release notes before upgrading production.

## Helm upgrade

1. Back up Helm values and, for production, database backups.
2. Merge your values with chart 5 defaults: remove obsolete keys listed above.
3. Decide **`temporal.enabled`**: keep **`true`** for bundled Temporal, or **`false`** for external/managed Temporal with **`temporal.hostPort`** updated.
4. Confirm **`temporalDeployments.delete-org-cluster-worker.enabled`** matches your org/cluster deletion requirements.
5. Run upgrade with hooks and jobs accounted for, for example:

   ```bash
   helm upgrade <release> fairwinds/fairwinds-insights --version 5.0.0 -f values.yaml --namespace <ns> --wait --wait-for-jobs
   ```

   Prefer the latest **5.x** patch (e.g. **5.8.0**) for follow-up worker additions, CronJob removals, and migration-hook fixes.

6. Confirm Temporal server pods (when enabled) are **Ready**, worker Deployments are running, and hook Jobs (**`migrate-database`**, **`one-time-migration`** when applicable) complete successfully.

## Further reading

- Self-hosted installation overview: [insights.docs.fairwinds.com — installation](https://insights.docs.fairwinds.com/technical-details/self-hosted/installation/)
- [CHANGELOG.md](./CHANGELOG.md) for 5.0.0 and earlier releases
- PostgreSQL CNPG migration (chart 4): [MIGRATION-3-to-4.md](./MIGRATION-3-to-4.md)
