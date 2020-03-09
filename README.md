# Fairwinds Charts [![CircleCI](https://circleci.com/gh/FairwindsOps/charts/tree/master.svg?style=svg)](https://circleci.com/gh/FairwindsOps/charts/tree/master)

A repository of Helm charts. Modelled after https://github.com/helm/charts

**Want to learn more?** Reach out on [the Slack channel](https://fairwindscommunity.slack.com), send an email to `opensource@fairwinds.com`, or join us for [office hours on Zoom](https://fairwindscommunity.slack.com/messages/office-hours)

## Testing

All charts are linted and tested using [Helm Chart Testing](https://github.com/helm/chart-testing)

### Linting

Charts are linted using both the `helm lint` command and against the [schema](scripts/schema.yaml).  This ensures that maintainers, versions, etc. are included.

### e2e Testing

Charts are installed into a [kind](https://github.com/kubernetes-sigs/kind) cluster.  You can provide a folder called `ci` with a set of `*-values.yaml` files to provide overrides for the e2e test.

If you have any prerequisites to a chart install that cannot be performed by helm itself (e.g. manually installing CRDs from a remote location) you can place a shell (not bash) script in the `ci` folder of your chart. The script should be exactly named: `pre-test-script.sh`

## Usage

To install a chart from this repo, you can add it as a [helm repository](https://github.com/helm/helm/blob/master/docs/chart_repository.md)

```
helm repo add fairwinds-stable https://charts.fairwinds.com/stable
helm search fairwinds-stable
```

## Organization

## Stable

These charts are considered stable for public consumption and use.

## Incubator

These charts are considered `alpha` or `beta` and are not intended for public consumption outside of Fairwinds.  They are frequently for very specific use-cases and can be broken at any time without warning.  There are absolutely no guarantees in this folder.

## Scripts

This folder includes scripts for testing the charts and syncing the repo.
