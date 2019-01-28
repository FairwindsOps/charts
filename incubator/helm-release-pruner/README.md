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
| `image.repository` | Repo for image that the job runs on. | `lachlanevenson/k8s-helm` | no |
| `image.tag` | Image tag. | `v2.9.1` | no |
| `job.backoffLimit` | Job backoff limit. | `3` | no |
| `job.dryRun` | Output purge candidates without taking any action. | `True` | no |
| `job.restartPolicy` | Job restart policy. | `Never` | no |
| `job.schedule` | Cron format schedule for job. | `0 */4 * * *` | no |
| `job.serviceAccountName` | Service account for the job to run as. | `helm-release-pruner` | no |
| `pruneProfiles` | Filters to use to find purge candidates. See example usage above for details. | `[]` | yes |
| `tiller.namespace` | Namespace where tiller resides. Used by job for helm commands. | `kube-system` | no |
