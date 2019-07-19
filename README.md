[![CircleCI](https://circleci.com/gh/reactiveops/charts/tree/master.svg?style=svg)](https://circleci.com/gh/reactiveops/charts/tree/master)

# ReactiveOps Charts

A repository of Helm charts. Modelled after https://github.com/helm/charts

**Want to learn more?** ReactiveOps holds [office hours on Zoom](https://zoom.us/j/242508205) the first Friday of every month, at 12pm Eastern. You can also reach out via email at `opensource@fairwinds.com`

## Testing

All charts are linted and tested using [Helm Chart Testing](https://github.com/helm/chart-testing)

### Linting

Charts are linted using both thelm `helm lint` command and against the [schema](scripts/schema.yaml).  This ensures that maintainers, versions, etc. are included.

### e2e Testing

Charts are installed into a [kind](https://github.com/kubernetes-sigs/kind) cluster.  You can provide a folder called `ci` with a set of `*-values.yaml` files to provide overrides for the e2e test.

## Usage

To install a chart from this repo, you can add it as a [helm repository](https://github.com/helm/helm/blob/master/docs/chart_repository.md)

```
helm repo add reactiveops-stable https://charts.reactiveops.com/stable
helm search reactiveops-stable
```

## Organization

## Stable

These charts are considered stable for public consumption and use.

## Incubator

These charts are considered `alpha` or `beta` and are not intended for public consumption outside of ReactiveOps.  They are frequently for very specific use-cases and can be broken at any time without warning.  There are absolutely no guarantees in this folder.

## Scripts

This folder includes scripts for testing the charts and syncing the repo.
