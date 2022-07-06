# Updating this Chart

This chart is forked from https://github.com/timescale/timescaledb-kubernetes/tree/master/charts/timescaledb-single

We have removed a particular Job which creates a Service. This service
gets orphaned after a `helm uninstall`, making this chart unusable as
a subchart.

Relevant issue: https://github.com/timescale/timescaledb-kubernetes/issues/357

To update this chart, run:

```bash
git clone github.com/timescale/timescaledb-kubernetes
cp -r timescaledb-kubernetes/charts/timescaledb-single/* ~/git/charts/incubator/timescale/
rm incubator/timescale/templates/job-update-patroni.yaml
helm-docs --sort-values-order=file
```

You may also need to change the chart version to make the linter happy.
