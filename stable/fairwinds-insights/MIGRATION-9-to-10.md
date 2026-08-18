# Migrating fairwinds-insights Helm chart from 9.x to 10.x

Chart **10.0.0** unifies PostgreSQL and Timescale secret ownership. Read this before upgrading production or any release that copies `postgresql.auth` / `timescale.auth` (or `timescale.password`) from older chart defaults.

For a concise list of release changes, see [CHANGELOG.md](./CHANGELOG.md).

## Summary

| Area | Chart 9.x | Chart 10.x |
|------|-----------|------------|
| `existingSecret` / `existingMigrationSecret` / `existingSuperUserSecret` defaults | Chart default names (`fwinsights-postgresql`, …) | **Empty.** Empty + `ephemeral: true` + `externalSecret.create: false` = chart-managed Secret at the same default names |
| Secret keys | `password` plus dual-write `postgresql-password`; overridable `secretKeys.*`; non-ephemeral Timescale used PG Secret key `timescale-password` | **Fixed keys only:** `username` + `password` (PG also `readonly-password` / `readreplica-password` when those features are used) |
| Timescale password source | `timescale.password` / `timescale.superuserpassword`; non-ephemeral env read `postgresql.auth.existingSecret` / `timescale-password` | **`timescale.auth.password` / `timescale.auth.superuserpassword`**; Timescale always uses its own Secret |
| ExternalSecret | `create: true` only when not ephemeral; CR and Secret named `fwinsights-postgresql-external`; app still read `existingSecret` (cut-over dance) | `create: true` **wires** app/CNPG to **`fwinsights-postgresql`** / **`fwinsights-timescale`** (or `externalSecret.targetName`). `externalSecret.name` is the CR name only. Allowed with `ephemeral: true` |
| Secret modes | Implicit (ephemeral created Secrets named by `existing*`) | **Exclusive:** Existing, External, or Chart-managed. `existingSecret` + `create` **fails** |
| Managed credential Secrets | Timescale app/migration had `helm.sh/resource-policy: keep`; PG/superuser did not | **All** managed PG + TS credential Secrets (app, migration, superuser) have **`keep`**. Uninstall does not delete them |
| Split migration | Could share one Secret with two password keys (`migrationPasswordKey`) | **Second Secret**, same keys (`username` + `password`). No ESO block for migration / superuser |

`ephemeral` is still **database lifecycle** (create the CNPG `Cluster`). It is not a secret-ownership mode: an in-cluster DB can use Existing, External, or Chart-managed Secrets.

## Who is affected

- **Default ephemeral, values not copied:** names stay `fwinsights-postgresql` / `fwinsights-timescale` with key `password`. Temporal defaults still match. Clear any **copied** `existing*: fwinsights-*` so Helm keeps creating those Secrets.
- **Copied `existingSecret: fwinsights-postgresql` (or Timescale twin):** that is now **Existing** mode. Helm stops creating the Secret and may delete the release-owned one. Clear those keys to stay chart-managed.
- **External PostgreSQL** using key `postgresql-password` (or `secretKeys.*`): rename the key to **`password`** (and `username` when CNPG bootstrap needs it) **before** upgrade.
- **External Timescale** that stored the password on the PostgreSQL Secret as `timescale-password`: give Timescale its **own** Secret (or Timescale ExternalSecret) with `password`.
- **Split app/migration** using `migrationPasswordKey` in the same Secret: create a **second** Secret with `username` + `password` and set `existingMigrationSecret`.
- **ExternalSecret cut-over users** (`create: true` + old `name: fwinsights-postgresql-external`): drop the cut-over. Leave `existingSecret` empty, keep `create: true`, and point `data[].secretKey` at `password` (and `username` as needed). The app reads `fwinsights-postgresql` unless you set `externalSecret.targetName`.
- **`timescale.password` / `timescale.superuserpassword`:** move under `timescale.auth`.

**Not affected** for default ephemeral if you did not copy `existing*` or `secretKeys`: managed names, Temporal `existingSecret: fwinsights-postgresql` + `secretKey: password`, env var names, role-split / `ownerRole`, `ephemeralSecretPassword` lookup on key `password`.

## Values to remove

- `postgresql.auth.secretKeys` (including `adminPasswordKey`, `migrationPasswordKey`)
- `timescale.auth.secretKeys`
- `timescale.secrets` (`certificateSecretName`, `credentialsSecretName`)
- Top-level `timescale.password` / `timescale.superuserpassword` (use `timescale.auth.*`)
- Copied default `existingSecret` / `existingMigrationSecret` / `existingSuperUserSecret` **if you want chart-managed Secrets** (empty string, not the old default name)

## Secret modes

| Mode | `existingSecret` | `externalSecret.create` | Chart creates | Valid `ephemeral` |
|------|------------------|-------------------------|---------------|-------------------|
| Existing | set | false | nothing | true or false |
| External | empty | true | `ExternalSecret` (ESO creates the Secret at `fwinsights-*`, or `targetName`) | true or false |
| Chart-managed | empty | false | Kubernetes `Secret` at `fwinsights-*` | **must be true** |

Invalid combinations **fail** (the error names the values to change):

- `existingSecret` set **and** `externalSecret.create`
- not ephemeral, no `existingSecret`, no `create`
- split migration, not ephemeral, empty `existingMigrationSecret`

`externalSecret.name` is only the ExternalSecret **resource** name. Empty = same as the resolved Secret name.

`externalSecret.targetName` is the Secret ESO creates (and the name env/CNPG use). Empty = `fwinsights-postgresql` / `fwinsights-timescale`. Set only with `create: true`. It is **not** `existingSecret` (that is Existing mode: you own the Secret, chart creates nothing).

Example ExternalSecret `data` (PostgreSQL):

```yaml
postgresql:
  ephemeral: false
  auth:
    existingSecret: ""
    externalSecret:
      create: true
      data:
        - secretKey: username
          remoteRef:
            key: your/vault/path
            property: username
        - secretKey: password
          remoteRef:
            key: your/vault/path
            property: password
```

**Temporal:** defaults remain `fwinsights-postgresql` + `secretKey: password`. A custom PostgreSQL Secret name (`existingSecret` or `externalSecret.targetName`) also requires overriding `temporal.server.config.persistence.datastores.{default,visibility}.sql.existingSecret`.

Split migration / superuser stay a second Secret you provide (or a second ExternalSecret you own). There is no `externalSecret` block for those.

## Helm upgrade

1. Back up Helm values and, for production, PostgreSQL and Timescale.
2. Rename Secret keys to `password` (and `username` where required) **before** upgrade. For external Timescale, create the Timescale Secret if it was previously `timescale-password` on the PG Secret.
3. Merge values: remove keys listed above; nest Timescale passwords; clear copied `existing*` if chart-managed is desired.
4. Upgrade with hooks and jobs accounted for:

   ```bash
   helm upgrade <release> fairwinds/fairwinds-insights --version 10.0.0 -f values.yaml --namespace <ns> --wait --wait-for-jobs
   ```

5. Confirm Secret names (`fwinsights-postgresql` / `fwinsights-timescale` unless you set `existingSecret` or `externalSecret.targetName`), CNPG `bootstrap.secret` / `superuserSecret` refs, app env `POSTGRES_PASSWORD` / `TIMESCALE_PASSWORD` key `password`, and Temporal still using `fwinsights-postgresql` + `password` (or your override).

## Further reading

- [CHANGELOG.md](./CHANGELOG.md) for 10.0.0 and earlier releases
- Self-hosted installation overview: [insights.docs.fairwinds.com — installation](https://insights.docs.fairwinds.com/technical-details/self-hosted/installation/)
- Self-hosted database notes: [insights.docs.fairwinds.com — database](https://insights.docs.fairwinds.com/technical-details/self-hosted/database/) (may lag this chart until the docs follow-up)
