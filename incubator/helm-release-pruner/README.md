# Helm Release Pruner Chart

This chart deploys a cronjob that purges stale Helm releases and associated namespaces. Releases are selected based on regex patterns for release name and namespace along with a Bash `date` command date string to define the stale cutoff date and time.

One use-case for this chart is purging ephemeral release releases after a period of inactivity.

## Example usage values file

The following values will purge all releases matching `^feature-.+-web$` in namespace matching `^feature-.+` older than 7 days. `job.dryRun` can be toggled to output matches without deleting anything.

```
job:
  schedule: "0 */4 * * *"
  dryRun: False

pruneProfiles:
  - olderThan: "7 days ago"
    helmReleaseFilter: "^feature-.+-web$"
    namespaceFilter: "^feature-.+"
```

## Configuration

The following table lists the configurable parameters of the helm-release-pruner chart and their default values.

| Parameter | Description | Default | Required |
| --------- | ----------- | ------- | -------- |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` | no |
| `image.repository` | Repo for image that the job runs on. | `quay.io/reactiveops/ci-images` | no |
| `image.tag` | Image tag. | `v8-alpine` | no |
| `job.backoffLimit` | Job backoff limit. | `3` | no |
| `job.dryRun` | Output purge candidates without taking any action. | `True` | no |
| `job.restartPolicy` | Job restart policy. | `Never` | no |
| `job.schedule` | Cron format schedule for job. | `0 */4 * * *` | no |
| `job.serviceAccount.create` | Create a service account for the job. | `true` | no |
| `job.serviceAccount.name` | Service account for the job to run as. | `""` | no |
| `pruneProfiles` | Filters to use to find purge candidates. See example usage above for details. | `[]` | yes |
| `tiller.namespace` | Namespace where tiller resides. Used by job for helm commands. | `kube-system` | no |
| `rbac_manager.enabled` | If true, creates an RbacDefinition to manage access. | `false` | no |
| `rbac_manager.namespaceLabel` | label to match namespaces to grant access to. | `""` | no |



## Upgrading
Chart version 1.0.0 introduced RBacDefinitions with rbac-manager to manage access.  This is disabled by default.  If enabled with the `rbac_manager.enabled`, the release should be purged and re-installed to ensure helm manages the resources.
