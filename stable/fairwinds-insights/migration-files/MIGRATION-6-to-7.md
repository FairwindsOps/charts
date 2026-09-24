# Migrating fairwinds-insights Helm chart from 6.x to 7.x

Chart **7.0.0** introduces a **breaking change** for **report / object storage**: the bundled **MinIO** subchart is **removed** in favor of **[RustFS](https://charts.rustfs.com/)** as the default in-cluster S3-compatible store. Read this before upgrading production or any release that sets `minio`, `rustfs`, or `reportStorage` values.

For a concise list of release changes, see [CHANGELOG.md](./CHANGELOG.md).

## Summary

| Area | Chart 6.x | Chart 7.x |
|------|-----------|-----------|
| In-cluster object storage | **MinIO** subchart (`minio.install: true` default) | **RustFS** subchart only (`rustfs.install: true` default) |
| Default `reportStorage.strategy` | **`minio`** | **`rustfs`** |
| Valid `reportStorage.strategy` values | `minio`, `rustfs`, `s3`, `local` | **`rustfs`**, **`s3`**, **`local`** only (invalid values fail template) |
| App env for bundled storage | **`MINIO_*`** when `strategy: minio` and `rustfs.install: false` | **`REPORT_STORAGE_S3_*`** with **`REPORT_STORAGE_STRATEGY=rustfs`** for S3-compatible paths |
| In-cluster endpoint | `{release}-fw-minio:9000` | `{release}-fw-rustfs-svc:9000` (via `rustfs.nameOverride`) |
| S3 batch-delete compat toggle | **`reportStorage.s3MinIOCompat`** → `REPORT_STORAGE_S3_MINIO_COMPAT` | **Removed** — set env via **`additionalEnvironmentVariables`** if your Insights version supports it |
| External AWS S3 (`strategy: s3`) | Supported | Unchanged; remove obsolete **`minio.*`** keys from values |
| Local fixtures (`strategy: local`) | Supported | Unchanged |
| PostgreSQL / Timescale / Temporal | See [MIGRATION-5-to-6.md](./MIGRATION-5-to-6.md) | Unchanged at 7.0.0; Timescale CNPG migration in chart **8**: [MIGRATION-7-to-8.md](./MIGRATION-7-to-8.md) |

## Who is affected

- **Default chart 6 installs** (`minio.install: true`, `reportStorage.strategy: minio`, `rustfs.install: false`): upgrade **deploys RustFS instead of MinIO**. Existing MinIO PVC data is **not** migrated automatically; plan object copy or accept data loss for disposable environments.
- **Anyone with `reportStorage.strategy: minio`**: the value is **invalid** in chart 7. Set **`rustfs`** (in-cluster or external S3-compatible endpoint) or **`s3`** / **`local`** as appropriate.
- **Anyone who pinned `minio.*` overrides** (image tags, persistence, buckets, `nameOverride`, etc.): the entire **`minio`** block is **removed**; move sizing and storage settings under **`rustfs.*`** or external **`reportStorage.s3Endpoint`** / **`reportStorage.s3CredentialsSecret`**.
- **Installs already on RustFS from 6.3.0** (`minio.install: false`, `rustfs.install: true`, `reportStorage.strategy: rustfs`): upgrade is mostly cleanup—drop dead **`minio.*`** keys and confirm bucket/credentials still match.
- **External object storage** (`rustfs.install: false` with `reportStorage.s3Endpoint` and `reportStorage.s3CredentialsSecret`, or `strategy: s3` for AWS): MinIO removal does not change your backend; remove unused **`minio.*`** and **`reportStorage.minioHost`** from values.
- **Providers requiring Content-MD5 on batched deletes** (previously **`reportStorage.s3MinIOCompat: true`**): migrate the env var to **`additionalEnvironmentVariables`** on the workloads that need it.

## Values to remove (no longer used in chart 7)

If your `values.yaml` or GitOps repo still sets these, **remove** them:

- The entire **`minio`** block (`minio.install`, `minio.image`, `minio.mcImage`, `minio.buckets`, `minio.persistence`, `minio.nameOverride`, etc.)
- **`reportStorage.minioHost`**
- **`reportStorage.s3MinIOCompat`**
- **`reportStorage.strategy: minio`** — replace with **`rustfs`**, **`s3`**, or **`local`**

## Values to set or review (chart 7)

1. **`reportStorage.strategy`** — Default **`rustfs`**. Use **`s3`** for AWS S3 with default SDK credential chain (no in-cluster broker). Use **`local`** for filesystem fixtures only.

2. **`rustfs.install`** — Default **`true`**. Set **`false`** when object storage runs outside the cluster; then provide **`reportStorage.s3Endpoint`** and **`reportStorage.s3CredentialsSecret`** (Secret keys **`accessKeyId`**, **`secretAccessKey`**) for S3-compatible APIs.

3. **`reportStorage.bucket`** / **`reportStorage.region`** — Defaults **`reports`** and **`us-east-1`**. Keep aligned with your existing bucket if you are reusing external storage; RustFS installs create the bucket via **`rustfs.createBucketJob`** when enabled.

4. **`rustfs.createBucketJob`** — Default **`enabled: true`**. Run **`helm install|upgrade --wait --wait-for-jobs`** so the bucket Job completes before workloads expect the bucket.

5. **`rustfs.nameOverride`**, **`rustfs.service.endpoint.port`**, **`rustfs.storageclass.*`**, **`rustfs.resources`** — Review defaults in [values.yaml](./values.yaml); they replace MinIO persistence and sizing for in-cluster installs.

6. **`rustfs.secret.existingSecret`** — Optional override for RustFS credential Secret name; default follows **`{release}-fw-rustfs-secret`**.

7. **`additionalEnvironmentVariables`** — If you relied on **`reportStorage.s3MinIOCompat`**, add the equivalent env var here (e.g. **`REPORT_STORAGE_S3_MINIO_COMPAT`**) when your Insights application version documents support.

8. **`reportStorage.skipFileFixtures`** — Unchanged; still sets **`SKIP_FILE_FIXTURES`** when needed.

## Data and object lifecycle (MinIO → RustFS)

- Chart **7 does not copy objects** from the old MinIO PVC/StatefulSet into RustFS. Those are separate subcharts with different storage layouts.
- **Greenfield / disposable dev clusters:** uninstall or delete MinIO resources and PVCs as appropriate, then upgrade/install chart 7; RustFS PVCs and the create-bucket Job initialize fresh storage.
- **Production with existing report files in MinIO:** plan **object sync** (e.g. `mc mirror`, `aws s3 sync`, or vendor tooling) from the MinIO bucket to the RustFS bucket **before** or **during** cutover, or keep storage **external** (`rustfs.install: false`) and point **`reportStorage.s3Endpoint`** at a managed S3-compatible service you control.
- **Credential rotation:** MinIO root credentials lived in the MinIO subchart Secret; RustFS uses **`RUSTFS_ACCESS_KEY`** / **`RUSTFS_SECRET_KEY`** in the RustFS Secret. Update any external consumers that referenced MinIO keys.

## Helm upgrade

1. Back up Helm values and, for production, export objects from the MinIO **`reports`** bucket (or your overridden bucket name).
2. Merge your values with chart 7 defaults: remove obsolete keys listed above; set **`reportStorage.strategy`** and **`rustfs.install`** for your target layout.
3. If migrating from bundled MinIO, sync report objects to the new backend or schedule acceptable downtime for empty storage.
4. Run upgrade with hooks and jobs accounted for, for example:

   ```bash
   helm upgrade <release> fairwinds/fairwinds-insights --version 7.0.0 -f values.yaml --namespace <ns> --wait --wait-for-jobs
   ```

   Prefer the latest **7.x** patch (e.g. **7.0.4**) for RustFS config fixes (**7.0.1**, **7.0.2**) and application **18.3** (**7.0.3**).

5. Confirm RustFS Pods (when **`rustfs.install: true`**) are **Ready**, the create-bucket Job succeeded, and API / worker Deployments have **`REPORT_STORAGE_S3_*`** env vars (not **`MINIO_*`**).

## Operational notes

- **Preview in 6.3.0:** chart **6.3.0** added optional RustFS alongside MinIO (`minio.install: false`, `rustfs.install: true`, `reportStorage.strategy: rustfs`). If you already adopted that layout on 6.x, the 7.x upgrade is primarily removal of dead MinIO configuration.
- **Template validation:** chart 7 **fails** if **`reportStorage.strategy`** is not **`rustfs`**, **`s3`**, or **`local`**—catch invalid GitOps values before apply.
- **AWS S3 without custom endpoint:** keep **`reportStorage.strategy: s3`**, **`rustfs.install: false`**, and ensure **`fwinsights-secrets`** (or your credential source) supplies AWS credentials the SDK expects.
- **Insights application version:** chart **7.0.x** targets Insights **18.2** at **7.0.0** and **18.3** from **7.0.3** (see [CHANGELOG.md](./CHANGELOG.md)). Validate application release notes before upgrading production.

## Further reading

- Self-hosted installation overview: [insights.docs.fairwinds.com — installation](https://insights.docs.fairwinds.com/technical-details/self-hosted/installation/)
- Timescale image bump (chart 6): [MIGRATION-5-to-6.md](./MIGRATION-5-to-6.md)
- Timescale CNPG migration (chart 8): [MIGRATION-7-to-8.md](./MIGRATION-7-to-8.md)
- [CHANGELOG.md](./CHANGELOG.md) for 7.0.0 and earlier releases
- RustFS Helm chart: [charts.rustfs.com](https://charts.rustfs.com/)
