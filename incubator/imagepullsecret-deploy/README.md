# Image pull secret chart

A super-simple chart that just deploys a dockerconfigjson secret.

## Note about version 1.x

**Note that upgrading to version 1.x from 0.x may require a purge/install cycle in helm to handle a namespace mismatch**

If you were using a `secret.namespace` (now removed) that did not match the namespace for your helm release, do these steps

1. `helm upgrade --namespace correct-namespace`: Helm reports an error because you can't change a release namespace, but then creates your secret in the old incorrect namespace specified by the helm chart before. It leaves your previously created secret orphaned.
1. `helm delete --purge release-name`: Helm deletes the secret in the old incorrect namespace
1. `helm install --namespace correct-namespace --force`: Helm deletes and recreates the secret in the correct-namespace

## Values

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `secret.name`     |  The name of the secret                 | `imagepullsecret` |
| `secret.b64_data` |  The base64-encoded data for the secret |                   |
