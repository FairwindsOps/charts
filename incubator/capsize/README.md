# Chart - capsize

This chart will watch a deployment's pods and restart them if they are older than a specified number of seconds.

## Configuration

The following table lists the configurable parameters of the capsize chart and their default values.

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `image.repository` | Image repository | `python` |
| `image.tag` | Image tag | `3.7-alpine` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `targetDeployment.namespace` | Namespace the deployment is in | `istio-system` |
| `targetDeployment.name` | Name of the deployment to monitor | `istio-ingressgateway` |
| `targetDeployment.container` | Name of the container in the pod to add the env to trigger the restart | `istio-proxy` |
| `targetDeployment.maxAge` | Amount of time to wait before triggering a restart | `'2592000'` (30 days |
| `schedule` | The cron schedule to run this check on.  Make sure it is more often than your maxAge | `'0 3 */1 * *'` |
| `suspend` | Whether or not to suspend the cron | `'false'` |
| `logLevel` | Logging level of the script | `'INFO'` |
| `configType` | The type of config to use. `local` or `cluster` | `cluster` |
| `rbac.create` | Create rbac ClusterRole and RoleBinding | `true` |
| `serviceAccount.create` | Create the service account for the pod | `true` |
| `serviceAccount.name` | Service account to be used. If not set and `serviceAccount.create` is true, a name is generated using the fullname template |
