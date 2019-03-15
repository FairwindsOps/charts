# OPA Chart

This chart will install the OPA controller and validating webhook to utilize it. It includes a default set of policies and allows the installation of additional policy.

## How Does This Work?

From a very high level, there is an opa container that takes validating admission webhooks and checks them against existing policy.  Policies are specified in configmaps that the kube-mgmt sidecar watches for and injects into the opa container.

## Certificates

The opa server requires a server certificate that the admission control trusts. In this chart I have added a self-signed CA and server cert using cert-manager. The cert ends up in a secret along with a CA cert. The ca-updater cronjob takes this CA and injects it into the validatingwebhookconfiguration caBundle field. This is a bit of a hack, but it will work until a better method becomes available.

### Cert-Manager

Cert-manager has the ability to generate a self-signed CA and certificate.  Enabling this option in the chart will utilize cert-manager CRDs to create and manage the cert for the validating webhook.

### selfSigned (Testing Only)

If you specify selfSigned=true, then the chart will use a helm pre-install hook to create a 1-day self-signed CA and cert to use for testing.

### certSecret

You can use this to specify your own certificate secret.  It *must* use the form:

```
apiVersion: v1
kind: Secret
metadata:
  name: certSecret
data:
  ca.crt: <BASE64 Encoded CA Cert>
  tls.crt: <BASE64 Encoded Server Cert>
  tls.key: <BASE64 Encoded Server Key>
```

## Default Policies

If you set `policy.default.enabled` to true (default), then a configmap will be created with the policies in the policies folder.

### Image-Whitelist

No images will be accepted as part of deployments unless permitted by an annotation on a namespace. Example below allows all images that being with `quay`. It accepts a comma-separated list of regexes.

```yaml
apiVersion: v1
kind: Namespace
metadata:
  annotations:
    image-whitelist: "^quay/.+"
  name: demo
```

### Duplicate Ingress

This is a simple policy that prevents the creation of any ingress that duplicates the `host` of an existing ingress (in any namespace)

## Testing

There are helm tests in place to test policy validity.  Run `helm test` to see if they are valid.  This just checks the annotation on the configmap.  Works for user-specified as well as default policy.

### ci testing

There are values in the [ci](ci/) folder that allow e2e testing to work.  They use the selfSigned cert as well as specify two broken custom policies.  The `helm test` on the custom policy is expected to fail and is accounted for in the test.

## Chart Configuration

| Parameter                         | Description                                                         | Default                             |
|-----------------------------------|---------------------------------------------------------------------|-------------------------------------|
| `affinity`                        | Pod Affinity Block                                                  | `{}`                                |
| `caUpdater.schedule`              | Schedule to run the ca-updater on.                                  | `42 */1 * * *`                      |
| `certManager.enabled`             | Whether or not to install cert-manager managed CA and cert.         | `True`                              |
| `selfSigned`                      | Enable to install a self-signed cert for testing.                   | `False`                             |
| `certSecret`                      | Use this to specify your own cert.  See above.                      | `False`                             |
| `createPolicy`                    | Should a configmap with default policies be created.                | `True`                              |
| `policy.custom.enabled`           | Enables the specification of custom policy.                         | `False`                             |
| `policy.custom.policies`          | Use this to specify the custom policies you want to install.        | `False`                             |
| `policy.default.enabled`          | Whether or not to install the default policies.                     | `True`                              |
| `fullnameOverride`                | Override the name                                                   | ``                                  |
| `kubeMgmt.args`                   | A list of args to pass to kube-mgmt                                 | `--replicate-cluster=v1/namespaces` |
| `kubeMgmt.image.repository`       | The kube-mgmt image to use                                          | `openpolicyagent/kube-mgmt`         |
| `kubeMgmt.image.tag`              | The kube-mgmt version to use                                        | `0.6`                               |
| `kubeMgmt.resources`              | Resource block for the kube-mgmt container                          | `{}`                                |
| `nameOverride`                    | Override the name                                                   | ``                                  |
| `nodeSelector`                    | A node selector block                                               | `{}`                                |
| `opa.args`                        | Args override for the opa server                                    | `[]`                                |
| `opa.image.repository`            | The opa image to use                                                | `openpolicyagent/opa`               |
| `opa.image.tag`                   | The opa image version to use                                        | `0.10.5`                            |
| `opa.resources`                   | Resource block for the opa container                                | `{}`                                |
| `replicaCount`                    | Number of controller pods to run. Haven't tried setting this higher | `1`                                 |
| `service.port`                    | The port to expose the service on. Don't change this.               | `443`                               |
| `service.type`                    | The type of service. Not recommended to change this.                | `ClusterIP`                         |
| `tolerations`                     | Tolerations block                                                   | `[]`                                |
| `validatingWebhook.failurePolicy` | The failure policy. Ignore or Fail. See the [docs](https://godoc.org/k8s.io/kubernetes/pkg/apis/admissionregistration#FailurePolicyType) | `Ignore` |

## Known Issues

* The current image whitelist policy requires that you annotate _every_ namespace you want to deploy to.
* The current image whitelist policy only applies to deployments.
* Currently the only way to update the caBundle with the CA from cert-manager is with the cronjob that I have put here. Hopefully we find a better way soon (or a better way is made)
* The cronjob that updates the ca is used to kick off a job from a helm hook on post-install.
* The ingress conflict policy will restrict the use of nginx-ingress for canaries. This could be fixed.
* There are very few policies right now. They are difficult to write.
