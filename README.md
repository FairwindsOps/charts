# ReactiveOps Charts

A repository of Helm charts. Modelled after https://github.com/helm/charts

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
