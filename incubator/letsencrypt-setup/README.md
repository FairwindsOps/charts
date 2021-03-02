# Chart - letsencrypt-setup

Installs the necessary additional items that the cert-manager chart lacks.

## Upgrading to 2.0.0 Chart Version

There are breaking changes with 2.0.0 chart version in that it absolutely requires a version of cert-manager v0.11.0 or higher to be running in the cluster.

Please follow upgrade instructions [located here](https://docs.cert-manager.io/en/release-0.11/tasks/upgrading/upgrading-0.10-0.11.html)

## Configuration

The following table lists the configurable parameters of the chart and their default values.

| Parameter | Description | Default | Required |
| --------- | ----------- | ------- | -------- |
| `clusterIssuers.selfsigned.clusterIssuerName` | Name of the selfsigned clusterIssuer | `Release.Name-self-signed` | no |
| `clusterIssuers.selfsigned.enabled` | Whether or not the selfsigned ClusterIssuer is installed | `false` | yes |
| `clusterIssuers.selfsigned.issuerUrl` | The URL to use for ACME | `https://acme-staging-v02.api.letsencrypt.org/directory` | yes |
| `clusterIssuers.selfsigned.email` | The email used for ACME registration | `""` | yes |
| `clusterIssuers.selfsigned.solvers.http.enabled` | Enables http01 validation on selfsigned issuer | `false` | yes |
| `clusterIssuers.selfsigned.solvers.http.ingressClass` | Use http01 solver with a specific ingress class | `""` | no |
| `clusterIssuers.selfsigned.solvers.http.ingressName` | Use this solver with a specific ingress name | `""` | no |
| `clusterIssuers.selfsigned.solvers.http.selector` | selector for http01 solver | `{}` | no |
| `clusterIssuers.selfsigned.solvers.dns` | List of DNS solvers and optional selectors for each. See below for configuration | `[]` | no |
| `clusterIssuers.primary.clusterIssuerName` | Name of the primary clusterIssuer | `Release.Name-primary-valid` | no |
| `clusterIssuers.primary.enabled` | Whether or not the primary ClusterIssuer is installed | `false` | yes |
| `clusterIssuers.primary.issuerUrl` | The URL to use for ACME | `https://acme-v02.api.letsencrypt.org/directory` | yes |
| `clusterIssuers.primary.email` | The email used for ACME registration | `someone@example.com` | yes |
| `clusterIssuers.primary.solvers.http.enabled` | Enables http01 validation on primary issuer | `false` | yes |
| `clusterIssuers.primary.solvers.http.ingressClass` | Use http01 solver with a specific ingress class | `nginx` | no |
| `clusterIssuers.primary.solvers.http.ingressName` | Use this solver with a specific ingress name | `""` | no |
| `clusterIssuers.primary.solvers.http.selector` | selector for http01 solver | `{}` | no |
| `clusterIssuers.primary.solvers.dns` | List of DNS solvers and optional selectors for each. See below for configuration | `[]` | no |

## DNS Solvers Configuration

### Route53

| Parameter | Description |
| --------- | --------- |
| `accessKeyID` | For use with specific IAM account credentials, not necessary if nodes have IAM role that gives access to route53|
| `hostedZoneID` | Route53 hosted zone ID |
| `region` | Required if using `accessKeyID` for authentication |
| `secretName` | Required if using `accessKeyID`, name of kubernetes secret that contains the IAM secret access key correlating to the `accessKeyID` |
| `secretKey` | Required if using `accessKeyID`, key within a kubernetes secret data block that holds the IAM secret access key |
| `type` | Defines the type of DNS solver, should be set to `route53` |

### Cloud DNS

| Parameter | Description |
| --------- | --------- |
| `project` | Name of the project in Google Cloud where Cloud DNS is used |
| `secretName` | optional kubernetes secret name in same namespace |
| `secretKey` | key in the kubernetes secret with the service account creds |
| `type` | Defines the type of DNS solver, should be set to `clouddns` |

### Cloudflare

| Parameter | Description |
| --------- | --------- |
| `email` | Email associated with the Cloudflare account |
| `secretName` | Name of kubernetes secret that contains the secret access key |
| `secretKey` | Key within a kubernetes secret data block that holds the secret access key |
| `type` | Defines the type of DNS solver, should be set to `cloudflare` |

### AzureDNS

| Parameter | Description |
| --------- | ----------- |
| `clientId` | The AAD Service Principal Application ID |
| `clientSecret` | Name of kubernetes secret that contains the secret Service Principal password |
| `clientSecretKey` | Key within a kubernetes secret data block that holds the Service Principal password |
| `subscriptionId` | Azure subscription where the DNS zone lives |
| `tenantId` | Azure tenant where the subscription lives |
| `resourceGroupName` | Resource group where the DNS zone lives |
| `hostedZoneName` | DNS Zone name (ex: example.com) |
| `environment` | Public or Private zone (default `AzurePublicCloud`) |
| `type` | Defines the type of solver, should be set to `azuredns` |

## Selector Settings

Selectors allow you to specify multiple challenge solvers and force certain constraints on when specific solvers should be used. The most common will probably be `dnsZones`, but you can also use `dnsNames` to force a set of specific entries to be solved a certain way. The third way to specify an ingress to use a specific solver is through labels using the `matchLabels` setting which accepts key/value objects to match labels against. An empty selector will attempt to be used for any and all ingress challenges.

| Parameter | Value Type | Description |
| --------- | --------- | --------- |
| `matchLabels` | map | Labels applied to a given ingress that should use this solver |
| `dnsNames` | list | Specific Ingress DNS entries that should use this solver |
| `dnsZones` | list | Entire DNS domains that should only use this solver |

In the example configuration below, we use route53 DNS to solve for `foo.com` and Google Cloud DNS for `bar.com`:

```yaml
clusterIssuers:
  primary:
    enabled: true
    email: someone@example.com
    solvers:
      dns:
      - type: route53
        hostedZoneID: MYHOSTEDZONE
        selector:
          dnsZones:
          - foo.com
      - type: clouddns
        project: test-project
        selector:
          dnsZones:
          - bar.com
```
