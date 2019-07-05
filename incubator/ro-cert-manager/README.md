# Chart - ro-cert-manager

Installs the necessary additional items that the cert-manager chart lacks.

## Known Issues

### Race Condition With Cert-manager Chart

When this chart is installed too quickly after versions 0.6+ of the cert-manager chart, the cert-manager validating webhook may not yet be initialized, making cert-manager incapable of creating Clusterissuer objects.

Until this chart is updated to address this issue, we recommend setting `cert-manager.enabled` to `false` for this chart, and installing the cert-manager chart separately. Allow one minute for the cert-manager webhook to initialize before installing this chart.

For discussion and updates, see [this issue](https://github.com/reactiveops/charts/issues/97).

## Configuration

The following table lists the configurable parameters of the chart and their default values.

| Parameter | Description | Default | Required |
| --------- | ----------- | ------- | -------- |
| `cert-manager.enabled` | Install the cert-manager chart as a dependency | `true` | yes |
| `clusterIssuers.staging.clusterIssuerName` | Name of the staging clusterIssuer | `Release.Name-staging-self-signed` | no |
| `clusterIssuers.staging.enabled` | Whether or not the staging ClusterIssuer is installed | `true` | yes |
| `clusterIssuers.staging.issuerUrl` | The URL to use for ACME | `https://acme-staging-v02.api.letsencrypt.org/directory` | no |
| `clusterIssuers.staging.http.enabled` | Enables http01 validation on staging issuer | `false` | yes |
| `clusterIssuers.staging.dns.enabled` | Enables dns01 validation on staging issuer. See [values.yaml](values.yaml) for configuration. | `false` | yes |
| `clusterIssuers.production.clusterIssuerName` | Name of the production clusterIssuer | `Release.Name-production-valid` | no |
| `clusterIssuers.production.enabled` | Whether or not the production ClusterIssuer is installed | `true` | yes |
| `clusterIssuers.production.issuerUrl` | The URL to use for ACME | `https://acme-v02.api.letsencrypt.org/directory` | no |
| `clusterIssuers.production.http.enabled` | Enables http01 validation on production issuer | `false` | yes |
| `clusterIssuers.production.dns.enabled` | Enables dns01 validation on production issuer. See [values.yaml](values.yaml) for configuration. | `false` | yes |

