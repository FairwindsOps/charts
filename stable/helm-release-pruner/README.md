# Helm Release Pruner Chart

A Go-based daemon for automatically deleting old Helm releases. Runs continuously in your cluster and prunes stale releases at configurable intervals. Supports filtering by release name, namespace, age, or count with regex patterns.

## Overview

This chart deploys helm-release-pruner, a Go-based daemon that automatically deletes old Helm releases based on configurable filters. It runs as a Deployment that continuously prunes at configurable intervals.

## Features

- Delete releases older than a specified age
- Keep only the N most recent releases globally
- Filter releases by name and namespace using regex patterns
- Exclude releases and namespaces using regex patterns
- Clean up empty namespaces after release deletion
- Clean up orphaned namespaces (namespaces with no Helm releases)
- Prometheus metrics for monitoring
- Health endpoints for Kubernetes probes

## Example Usage

### Basic Usage

Prune feature branch releases older than 2 weeks, checking every hour:

```yaml
pruner:
  dryRun: false
  interval: "1h"
  olderThan: "2w"
  releaseFilter: "^feature-.+-web$"
  namespaceFilter: "^feature-.+"

serviceMonitor:
  enabled: true
```

### With Release Count Limit

Keep only the 10 most recent matching releases:

```yaml
pruner:
  dryRun: false
  olderThan: "14d"
  releaseFilter: "^feature-.+"
  maxReleasesToKeep: 10
```

### Orphan Namespace Cleanup

Clean up namespaces that have no Helm releases:

```yaml
pruner:
  dryRun: false
  olderThan: "2w"
  namespaceFilter: "^feature-.+"
  cleanupOrphanNamespaces: true
  orphanNamespaceFilter: "^feature-.+"
```

## Duration Formats

The `olderThan` and `interval` values support:
- Go durations: `1h`, `30m`, `336h`
- Days: `14d` (14 days)
- Weeks: `2w` (2 weeks)

## Prometheus Metrics

The following metrics are exposed on `/metrics`:

| Metric | Type | Description |
|--------|------|-------------|
| `helm_pruner_releases_deleted_total` | Counter | Total releases deleted |
| `helm_pruner_namespaces_deleted_total` | Counter | Total namespaces deleted |
| `helm_pruner_cycle_duration_seconds` | Histogram | Duration of prune cycles |
| `helm_pruner_cycle_failures_total` | Counter | Failed prune cycles |
| `helm_pruner_releases_scanned_total` | Counter | Total releases scanned |

## Health Endpoints

| Endpoint | Description |
|----------|-------------|
| `/healthz` | Liveness probe - returns 200 if running |
| `/readyz` | Readiness probe - returns 200 after initialization |
| `/metrics` | Prometheus metrics |

## Upgrading

### From v3.x (Bash) to v4.x (Go)

v4.0.0 is a major rewrite from Bash to Go with significant changes:

| Change | v3.x (Bash) | v4.x (Go) |
|--------|-------------|-----------|
| Deployment | CronJob | Deployment (daemon) |
| Duration format | `"7 days ago"` | `7d`, `1w`, `168h` |
| Release filter | `helmReleaseFilter` | `releaseFilter` |
| Exclude filter | `helmReleaseNegateFilter` | `releaseExclude` |
| Namespace exclude | `namespaceNegateFilter` | `namespaceExclude` |
| Health endpoints | None | `/healthz`, `/readyz`, `/metrics` |
| Prometheus metrics | None | Supported |
| Orphan NS cleanup | Not supported | Supported |

**Migration example:**

v3.x values:
```yaml
job:
  schedule: "0 */4 * * *"
  dryRun: false

pruneProfiles:
  - olderThan: "7 days ago"
    helmReleaseFilter: "^feature-.+"
    namespaceFilter: "^feature-.+"
    maxReleasesToKeep: 10
```

v4.x values:
```yaml
pruner:
  dryRun: false
  interval: "4h"
  olderThan: "7d"
  releaseFilter: "^feature-.+"
  namespaceFilter: "^feature-.+"
  maxReleasesToKeep: 10
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| image.repository | string | `"quay.io/fairwinds/helm-release-pruner"` | Image repository |
| image.tag | string | `"4.0"` | Image tag (defaults to appVersion) |
| image.pullPolicy | string | `"Always"` | Image pull policy |
| imagePullSecrets | list | `[]` | Image pull secrets |
| nameOverride | string | `""` | Override the chart name |
| fullnameOverride | string | `""` | Override the full release name |
| pruner | object | `{"cleanupOrphanNamespaces":false,"debug":false,"deleteRateLimit":"100ms","dryRun":true,"interval":"1h","maxReleasesToKeep":0,"namespaceExclude":"","namespaceFilter":"","olderThan":"","orphanNamespaceExclude":"","orphanNamespaceFilter":"","preserveNamespace":false,"releaseExclude":"","releaseFilter":"","systemNamespaces":""}` | Pruner configuration options (maps to CLI flags) |
| pruner.dryRun | bool | `true` | If true, only log what would be deleted without actually deleting |
| pruner.debug | bool | `false` | Enable debug logging |
| pruner.interval | string | `"1h"` | How often to run the pruning cycle (daemon mode only) Supports Go duration format: "1h", "30m", "6h" |
| pruner.olderThan | string | `""` | Delete releases older than this duration Supports: Go durations (336h), days (14d), weeks (2w) |
| pruner.maxReleasesToKeep | int | `0` | Keep only the N most recent releases globally after filtering (0 = no limit) |
| pruner.releaseFilter | string | `""` | Regex to include matching release names |
| pruner.releaseExclude | string | `""` | Regex to exclude matching release names |
| pruner.namespaceFilter | string | `""` | Regex to include matching namespaces |
| pruner.namespaceExclude | string | `""` | Regex to exclude matching namespaces |
| pruner.preserveNamespace | bool | `false` | Don't delete namespaces even when empty after release deletion |
| pruner.cleanupOrphanNamespaces | bool | `false` | Enable cleanup of namespaces that have no Helm releases |
| pruner.orphanNamespaceFilter | string | `""` | Regex filter for namespaces to consider for orphan cleanup (REQUIRED when using cleanupOrphanNamespaces) |
| pruner.orphanNamespaceExclude | string | `""` | Regex to exclude namespaces from orphan cleanup |
| pruner.systemNamespaces | string | `""` | Comma-separated list of additional namespaces to never delete (kube-system, kube-public, default, kube-node-lease are always protected) |
| pruner.deleteRateLimit | string | `"100ms"` | Minimum duration between delete operations (0 to disable) |
| replicas | int | `1` | Number of replicas (should typically be 1) |
| healthAddr | string | `":8080"` | Address for health check and metrics endpoints |
| service.enabled | bool | `true` | Create a Service for health/metrics endpoints |
| service.port | int | `8080` | Service port |
| service.annotations | object | `{}` | Service annotations |
| serviceMonitor.enabled | bool | `false` | Create a ServiceMonitor for Prometheus scraping |
| serviceMonitor.interval | string | `"30s"` | Scrape interval |
| serviceMonitor.additionalLabels | object | `{}` | Additional labels for the ServiceMonitor |
| serviceAccount.create | bool | `true` | Create a ServiceAccount |
| serviceAccount.name | string | `""` | Name of an existing ServiceAccount to use (if create is false) |
| serviceAccount.annotations | object | `{}` | Annotations for the ServiceAccount |
| rbac.create | bool | `true` | Create RBAC resources (ClusterRole, ClusterRoleBinding) |
| podAnnotations | object | `{}` | Additional annotations for pods |
| podLabels | object | `{}` | Additional labels for pods |
| resources | object | `{"limits":{"memory":"128Mi"},"requests":{"cpu":"10m","memory":"32Mi"}}` | Resource requests and limits |
| nodeSelector | object | `{}` | Node selector for pod scheduling |
| tolerations | list | `[]` | Tolerations for pod scheduling |
| affinity | object | `{}` | Affinity rules for pod scheduling |
| securityContext | object | `{"fsGroup":10324,"runAsNonRoot":true,"runAsUser":10324}` | Pod security context |
| containerSecurityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true}` | Container security context |
