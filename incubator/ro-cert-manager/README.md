# Chart - ro-cert-manager

Installs the necessary additional items that the cert-manager chart lacks.

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


