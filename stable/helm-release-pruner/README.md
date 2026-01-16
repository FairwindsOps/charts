# Helm Release Pruner Chart

This chart deploys a cronjob that purges stale Helm releases and associated namespaces. Releases are selected based on regex patterns for release name and namespace along with a Bash `date` command date string to define the stale cutoff date and time.

One use-case for this chart is purging ephemeral release releases after a period of inactivity.

## Example usage values file

The following values will purge all releases matching `^feature-.+-web$`
in namespace matching `^feature-.+` older than 7 days. It will also only
keep the 10 newest releases.

`job.dryRun` can be toggled to output matches without deleting anything.

```
job:
  schedule: "0 */4 * * *"
  dryRun: False

pruneProfiles:
  - olderThan: "7 days ago"
    helmReleaseFilter: "^feature-.+-web$"
    namespaceFilter: "^feature-.+"
    maxReleasesToKeep: 10
```

## Cleaning Up Orphan Namespaces

After `helm uninstall`, some resources may remain in the namespace that were created outside of Helm (e.g., secrets from SOPS, operators, or CI/CD pipelines). This can leave "orphan" namespaces that have no Helm releases but still contain resources.

To clean up these orphan namespaces, enable the `cleanupOrphanNamespaces` feature:

```yaml
job:
  dryRun: false

pruneProfiles:
  - olderThan: "7 days ago"
    helmReleaseFilter: "^fwinsights-"
    namespaceFilter: "^fwinsights-"

cleanupOrphanNamespaces:
  enabled: true
  namespacePatterns:
    - "^fwinsights-"
  excludePatterns:
    - "-main$"
    - "-production$"
```

This will:
1. Run the normal Helm release pruning first
2. Find namespaces matching the patterns that have NO Helm releases
3. Delete those orphan namespaces (which cascades to delete all resources within them)

**Note:** This feature respects the `job.dryRun` setting. Set `dryRun: true` first to see what would be deleted.

## Upgrading

### v3.0.0

This version is only compatible with Helm3. Update to this once you have upgraded helm.

In addition, this version moves the image to the Fairwinds repository in Quay. See the values section for the new location.

### v1.0.0

Chart version 1.0.0 introduced RBacDefinitions with rbac-manager to manage access.  This is disabled by default.  If enabled with the `rbac_manager.enabled`, the release should be purged and re-installed to ensure helm manages the resources.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| image.repository | string | `"quay.io/fairwinds/helm-release-pruner"` | Repo for image that the job runs on |
| image.tag | string | `"v3.4.0"` | The image tag to use |
| image.pullPolicy | string | `"Always"` | The image pull policy. We do not recommend changing this |
| podAnnotations | object | `{}` |  |
| job.backoffLimit | int | `3` | The backoff limit for the job |
| job.restartPolicy | string | `"Never"` |  |
| job.schedule | string | `"0 */4 * * *"` | The schedule for the cronjob to run on |
| job.dryRun | bool | `true` | If true, will only log candidates for removal and not remove them |
| job.debug | bool | `false` | If true, will enable debug logging |
| job.serviceAccount.create | bool | `true` | If true, a service account will be created for the job to use |
| job.serviceAccount.name | string | `"ExistingServiceAccountName"` | The name of a pre-existing service account to use if job.serviceAccount.create is false |
| job.listSecretsRole.create | bool | `true` | If true, a cluster role will be created for the job to list helm releases |
| job.listSecretsRole.name | string | `"helm-release-pruner-list-secrets"` | Name of a cluster role granting list secrets permission |
| job.resources.limits.cpu | string | `"25m"` |  |
| job.resources.limits.memory | string | `"32Mi"` |  |
| job.resources.requests.cpu | string | `"25m"` |  |
| job.resources.requests.memory | string | `"32M"` |  |
| job.nodeSelector | object | `{}` | The job nodeSelector |
| job.tolerations | list | `[]` | The job tolerations |
| pruneProfiles | list | `[]` | Filters to use to find purge candidates. See example usage in values.yaml for details |
| cleanupOrphanNamespaces.enabled | bool | `false` | If true, will clean up namespaces that have no Helm releases but still contain resources (e.g., secrets created outside of Helm) |
| cleanupOrphanNamespaces.namespacePatterns | list | `[]` | List of regex patterns to match namespace names for cleanup |
| cleanupOrphanNamespaces.excludePatterns | list | `[]` | List of regex patterns to exclude namespaces from cleanup |
| rbac_manager.enabled | bool | `false` | If true, creates an RbacDefinition to manage access |
| rbac_manager.namespaceLabel | string | `""` | Label to match namespaces to grant access to |
| fullnameOverride | string | `""` | A template override for fullname |
| nameOverride | string | `""` | A template override for name |
