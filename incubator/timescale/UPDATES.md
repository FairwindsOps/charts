# Updating this Chart

This chart is forked from https://github.com/timescale/helm-charts/tree/main/charts/timescaledb-single

We have removed a particular Job which creates a Service. This service
gets orphaned after a `helm uninstall`, making this chart unusable as
a subchart.

Relevant issue: https://github.com/timescale/timescaledb-kubernetes/issues/357

To update this chart, run:

```bash
git clone https://github.com/timescale/helm-charts
cp -r helm-charts/charts/timescaledb-single/* ./incubator/timescale/
rm incubator/timescale/templates/job-update-patroni.yaml
git checkout -- incubator/timescale/templates/role-timescaledb.yaml
helm-docs --sort-values-order=file
```

Note that changes to role-timescaledb.yaml are reverted above. This is to remove the
ability to create services. Other changes to this file may need to be persisted.

You may also need to change the Chart.yaml to make the linter happy
