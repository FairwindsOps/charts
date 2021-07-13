# Fairwinds Charts
[![CircleCI](https://circleci.com/gh/FairwindsOps/charts/tree/master.svg?style=svg)](https://circleci.com/gh/FairwindsOps/charts/tree/master)
[![Fairwinds Insights](https://insights.fairwinds.com/v0/gh/FairwindsOps/charts/badge.svg)](https://insights.fairwinds.com/gh/FairwindsOps/charts)

A repository of Helm charts. Modelled after https://github.com/helm/charts

## Join the Fairwinds Open Source Community

The goal of the Fairwinds Community is to exchange ideas, influence the open source roadmap, and network with fellow Kubernetes users. [Chat with us on Slack](https://join.slack.com/t/fairwindscommunity/shared_invite/zt-e3c6vj4l-3lIH6dvKqzWII5fSSFDi1g) or [join the user group](https://www.fairwinds.com/open-source-software-user-group) to get involved!

## Testing

All charts are linted and tested using [Helm Chart Testing](https://github.com/helm/chart-testing)

## Generating docs

Fairwinds charts are using
[helm-docs](https://github.com/norwoodj/helm-docs) for automating the
generation of docs. Before pushing your changes, run `helm-docs --sort-values-order=file` - this will add new values together with their documentation to the README of the chart. Ideally document the values via comments inside the values file itself - those comments will end up in the README as well.

### Linting

Charts are linted using both the `helm lint` command and against the [schema](scripts/schema.yaml).  This ensures that maintainers, versions, etc. are included.

### e2e Testing

Charts are installed into a [kind](https://github.com/kubernetes-sigs/kind) cluster.  You can provide a folder called `ci` with a set of `*-values.yaml` files to provide overrides for the e2e test.

If you have any prerequisites to a chart install that cannot be performed by helm itself (e.g. manually installing CRDs from a remote location) you can place a shell (not bash) script in the `ci` folder of your chart. The script should be exactly named: `pre-test-script.sh`

## Usage

To install a chart from this repo, you can add it as a [helm repository](https://github.com/helm/helm/blob/master/docs/chart_repository.md)

```
helm repo add fairwinds-stable https://charts.fairwinds.com/stable
helm search repo fairwinds-stable
```

## Organization

## Stable

These charts are considered stable for public consumption and use. See the criteria in the [contributing](CONTRIBUTING.md) document.

## Incubator

These charts are considered `alpha` or `beta` and are not intended for public consumption outside of Fairwinds.  They are frequently for very specific use-cases and can be broken at any time without warning.  There are absolutely no guarantees in this folder.

## Scripts

This folder includes scripts for testing the charts and syncing the repo.


## Other Projects from Fairwinds

Enjoying Charts? Check out some of our other projects:
* [Polaris](https://github.com/FairwindsOps/Polaris) - Audit, enforce, and build policies for Kubernetes resources, including over 20 built-in checks for best practices
* [Goldilocks](https://github.com/FairwindsOps/Goldilocks) - Right-size your Kubernetes Deployments by compare your memory and CPU settings against actual usage
* [Pluto](https://github.com/FairwindsOps/Pluto) - Detect Kubernetes resources that have been deprecated or removed in future versions
* [Nova](https://github.com/FairwindsOps/Nova) - Check to see if any of your Helm charts have updates available
* [rbac-manager](https://github.com/FairwindsOps/rbac-manager) - Simplify the management of RBAC in your Kubernetes clusters

Or [check out the full list](https://www.fairwinds.com/open-source-software?utm_source=charts&utm_medium=charts&utm_campaign=charts)
