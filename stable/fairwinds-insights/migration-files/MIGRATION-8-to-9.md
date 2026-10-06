# Migrating fairwinds-insights Helm chart from 8.x to 9.x

Chart **9.0.0** bumps the bundled **[Temporal Helm chart](https://github.com/temporalio/helm-charts)** dependency from **0.73.2** to **1.2.0** and aligns defaults with **Temporal server 1.30.x** and the **Temporal UI** image used by that subchart. Read this before upgrading production if `temporal.enabled` is `true` or you override `temporal.*` values.

For a concise list of release changes, see [CHANGELOG.md](./CHANGELOG.md).

Upstream background (generic Temporal chart behavior): [UPGRADING.md](https://github.com/temporalio/helm-charts/blob/main/UPGRADING.md).

## Summary

| Area | Chart 8.x | Chart 9.x |
|------|-----------|-----------|
| Temporal subchart | **0.73.2** | **1.2.0** |
| Server config delivery | Dockerize-style ConfigMap (`insights-temporal-dockerize-config`, `.Env.TEMPORAL_STORE_PASSWORD` in template) | Native config template (`insights-temporal-config`, `TEMPORAL_DEFAULT_STORE_PASSWORD`) |
| Legacy shims | Effectively dockerize path with 1.29-era images | Defaults set **`shims.dockerize: false`** and **`shims.elasticsearchTool: false`** for Temporal **1.30+** |
| Default server / admin-tools image line | Temporal **1.29.1** (per 0.73.2 defaults) | Temporal **1.30.3** (per 1.2.0 defaults) |
| Internal frontend Service | **0.73.x** could render `insights-temporal-internal-frontend` | Often **not** rendered unless you enable **`server.internal-frontend`** in Temporal values; main client path remains **`insights-temporal-frontend:7233`** |
| Probes | Older defaults | Frontend **gRPC readiness** and Temporal Web **`/healthz`** readiness are common in 1.x subchart defaults |
| Insights app ↔ Temporal | `temporal.hostPort` / `temporal.namespace` unchanged in principle | Still **`insights-temporal-frontend:7233`** and namespace **`fwinsights`** in chart defaults |

## Who is affected

- **Self-hosted installs with `temporal.enabled: true`** (default when using bundled Temporal).
- Anyone with **custom `temporal:` values** copied from pre-1.0 Temporal chart docs (e.g. **`server.internalFrontend`**, **`imagePullSecrets`** as a map, or overrides that assume dockerize env names).
- Anyone who **patches Temporal server Pods** or **Jobs** with extra env vars: **`TEMPORAL_STORE_PASSWORD`** on server containers is replaced by **`TEMPORAL_DEFAULT_STORE_PASSWORD`** in the new subchart rendering.

**Not affected** for Temporal semantics: Insights workloads that only use the chart’s templated **`TEMPORAL_HOST_PORT`** / **`TEMPORAL_NAMESPACE`** (derived from `temporal.hostPort` and `temporal.namespace`) without custom Temporal server env overrides.

## Values and keys to review (chart 9)

1. **`temporal.shims`** — Chart 9 defaults **`dockerize: false`** and **`elasticsearchTool: false`**. If you pin **Temporal server** images to **1.29.x**, consult [Temporal UPGRADING.md](https://github.com/temporalio/helm-charts/blob/main/UPGRADING.md) (`shims.dockerize`); mismatched shim vs image version can break startup.

2. **`server.internal-frontend`** — If you relied on the **`insights-temporal-internal-frontend`** Service (uncommon for Insights), enable and configure **`temporal.server.internal-frontend`** using the **hyphenated** key (renamed from historical `internalFrontend` in upstream docs).

3. **`imagePullSecrets`** — Upstream Temporal chart expects an **array** (`[]`), not a map. Update any `temporal.imagePullSecrets` (or global pull secrets passed into the subchart) accordingly.

4. **`temporal.server.config.persistence.numHistoryShards`** — **Do not change** on an existing Temporal cluster. It must stay aligned with the value used when the cluster was first initialized (chart default remains **512**, matching historical defaults).

5. **Persistence / secrets** — Chart defaults still use **`existingSecret: fwinsights-postgresql`** and **`secretKey: password`** for both default and visibility SQL stores. No Fairwinds change to secret *names* is required for the default layout; only the **environment variable names** on Temporal **server** pods changed upstream (see Summary table).

6. **Custom raw manifests or post-renderer patches** — Search for **`insights-temporal-dockerize-config`**, **`TEMPORAL_STORE_PASSWORD`**, or **`config-dockerize`** volume names and update to the **1.1.x** resource names and env vars if you maintain patches outside Helm values.

## Helm upgrade

1. Back up Helm values, and for production back up PostgreSQL.
2. Merge your values with chart 9 defaults; apply the key renames and probe/shim notes above.
3. Run upgrade with hooks and jobs accounted for, for example:

   ```bash
   helm upgrade <release> fairwinds/fairwinds-insights --version 9.0.0 -f values.yaml --namespace <ns> --wait --wait-for-jobs
   ```

4. Confirm Temporal Deployments become **Ready**, schema / setup Jobs complete, and Insights workers still connect (same frontend Service DNS in default configuration).

## Further reading

- [CHANGELOG.md](./CHANGELOG.md) for 9.0.0 and earlier releases
- Temporal Helm migration notes: [github.com/temporalio/helm-charts — UPGRADING.md](https://github.com/temporalio/helm-charts/blob/main/UPGRADING.md)
- Self-hosted installation overview: [insights.docs.fairwinds.com — installation](https://insights.docs.fairwinds.com/technical-details/self-hosted/installation/)
