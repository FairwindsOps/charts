# Fairwinds Insights Agent

The Fairwinds Insights Agent is a collection of reporting tools, which send data back
to [Fairwinds Insights](https://insights.fairwinds.com).

A list of breaking changes for each major version release is available at the bottom of this document.

## Installation
We recommend installing `insights-agent` in its own namespace.

```
helm repo add fairwinds-stable https://charts.fairwinds.com/stable
helm upgrade --install insights-agent fairwinds-stable/insights-agent \
  --namespace insights-agent \
  --set insights.organization=acme-co \
  --set insights.cluster=staging \
  --set insights.base64token="abcde=="
```

## CronJob schedules
Most Insights reports run as CronJobs, typically every hour.

In order to avoid every report consuming resources at once, you can stagger the reports
by setting the minute of the cron schedule to a random number. For example,
to run at a random minute every hour, your cron expression can be `rand * * * *`.

## Reports
There are several different report types which can be enabled and configured:
* `polaris`
* `goldilocks`
* `workloads`
* `kube-hunter`
* `trivy`
* `nova`
* `rbac-reporter`
* `kube-bench`
* `pluto`
* `opa`
* `prometheus-metrics`
* `admission`
* `awscosts`

See below for configuration details.

## Fleet Installation
If you're installing the Insights Agent across a large fleet of clusters,
it can be tedious to use the UI to create each cluster, then copy out the
cluster's access token.

To better serve customers with a large number of clusters, we've created a flow
that allows you to easily deploy the Insights Agent across your fleet.
[Read more here](https://insights.docs.fairwinds.com/run/agent/installation/#fleet-installation)

## Configuration
Parameter | Description | Default
--------- | ----------- | -------
`insights.organization` | The name of the organization to upload data to | ""
`insights.cluster` | The name of the cluster the data is coming from | ""
`insights.base64token` | Your cluster's base64-encoded auth token provided by Insights | ""
`insights.tokenSecretName` | If you don't provide a `base64token`, you can specify the name of a secret to pull the token from | ""
`insights.host` | The location of the Insights server | https://insights.fairwinds.com
`rbac.disabled` | Don't use any of the built-in RBAC | `false`
`fleetInstall` | See Fleet Installation docs | `false`
`global.priority.low` | PriorityClass value for low-priority pods | ""
`global.priority.high` | PriorityClass value for high-priority pods | ""
`global.proxy.http` | Annotations used to access the proxy servers(http) | ""
`global.proxy.https` | Annotations used to access the proxy servers(https) | ""
`global.proxy.ftp` | Annotations used to access the proxy servers(ftp) | ""
`global.proxy.no_proxy` | Annotations to provides a way to exclude traffic destined to certain hosts from using the proxy | ""
`global.sslCertFileSecretName` | The name of an existing Secret containing an SSL certificate file to be used when communicating with a self-hosted Insights API. | ""
`global.sslCertFileSecretKey` | The key, within global.sslCertFileSecretName, containing an SSL certificate file to be used when communicating with a self-hosted Insights API. | ""
`customWorkloadAnnotations` | Additional annotations to add to each worload. (excluding Falco, uses metadata) | `{}` 
`insights.apiToken` | Only needed if `fleetInstall=true` | ""
`uploader.image.repository`  | The repository to pull the uploader script from | quay.io/fairwinds/insights-uploader
`uploader.imagePullSecret` | A pull secret for a private uploader image
`uploader.image.tag` | The tag to use for the uploader script | 0.2
`uploader.resources` | CPU/memory requests and limits for the uploader script |
`uploader.sendFailures` | Send logs of failure to Insights when a job fails. | true
`uploader.env` | Set extra environment variables for the uploader script | []
`cronjobs.disableServiceMesh` | Adds annotations to all CronJobs to not inject Linkerd or Istio | true
`cronjobs.backoffLimit` | Backoff limit to use for each report CronJob | 1
`cronjobs.imagePullSecret` | A pull secret for cronjob images
`cronjobs.failedJobsHistoryLimit` | Number of failed jobs to keep in history for each report | 2
`cronjobs.successfulJobsHistoryLimit` | Number of successful jobs to keep in history for each report | 2
`cronjobs.nodeSelector` | Node selector to use for cronjobs | null
`cronjobs.tolerations` | Tolerations to use for cronjobs | null
`cronjobs.runJobsImmediately` | Run each of the reports immediately upon install of the Insights Agent | true
`cronjobs.dnsPolicy` | Adds pod DNS policy |
`cronjobs.imagePullSecret` | Name of a pull secret to attach to all CronJobs |
`{report}.enabled` | Enable the report type |
`{report}.schedule` | Cron expression for running the report | `rand * * * *`
`{report}.timeout` | Maximum time in seconds to wait for the report |
`{report}.resources` | CPU/memory requests and limits for the report |
`{report}.securityContext` | Additional securityContext field in the Pod specification(PodSecurityContext) for the report |
`{report}.image.repository` | Repository to use for the report image |
`{report}.image.tag` | Image tag to use for the report |
`{report}.securityContext` | Pod securityContext for the CronJob | {}
`{report}.containerSecurityContext` | Container securityContext for the CronJob | {}
`{report}.labels` | labels for the CronJob | {}
`{report}.annotations` | annotations for the CronJob | {}
`{report}.jobLabels` | labels for the Jobs created by the CronJob | {}
`{report}.jobAnnotations` | annotations for the Jobs created by the CronJob | {}
`polaris.config` | A custom [polaris configuration](https://polaris.docs.fairwinds.com/customization/configuration/)
`polaris.extraArgs` | A string of custom arguments to pass to the polaris CLI, e.g. `--disallow-annotation-exemptions=true` | 
`kube-hunter.logLevel` | DEFAULT, INFO, or WARNING | `INFO`
`kube-bench.mode` | Changes the way this plugin is deployed, either `cronjob` where it will run a single pod on the `schedule` that will pull the data necessary from a single node and report that back to Insights. `daemonset` which deploys a daemonset to the cluster which gathers data then a cronjob will gather data from each of those pods. `daemonsetMaster`  is the same as `daemonset` except the daemonset can also run on masters. | `cronjob`
`kube-bench.hourInterval` | If running in `daemonset` or `daemonsetMaster` this configuration changes how often the daemonset pods will rescan the node they are running on | 2
`kube-bench.aggregator` | contains `resources` and `image.repository` and `image.tag`, this controls the pod scheduled via a CronJob that aggregates from the daemonset in `daemonset` or `daemonsetMaster` deployment modes. |
`trivy.ignoreUnfixed` | Adds `--ignore-unfixed` trivy flag | false
`trivy.insecureSSL` | Can be used to allow insecure connections to a container registry when using SSL. | `false`
`trivy.privateImages.dockerConfigSecret` | Name of a secret containing a docker `config.json` | ""
`trivy.maxConcurrentScans` | Maximum number of scans to run concurrently | 1
`trivy.maxScansPerRun` | Maximum number of images to scan on a single run | 20
`trivy.namespaceAllowlist` | Specifies which namespaces to scan, takes an array of namespaces for example: `--set trivy.namespaceAllowlist="{kube-system,default}"` | []
`trivy.namespaceBlocklist` | Specifies which namespaces to not scan, takes an array of namespaces for example: `--set trivy.namespaceBlocklist="{kube-system,default}"` | []
`trivy.serviceAccount.annotations` | Annotations to add to the Trivy service account, e.g. `eks.amazonaws.com/role-arn: arn:aws:iam::ACCOUNT_ID:role/IAM_ROLE_NAME` for accessing private images | nil
`trivy.env` | A map of environment variables that will be set for the trivy container. | `nil`
`opa.role` | Specifies which ClusterRole to grant the OPA agent access to | view
`opa.additionalAccess` | Specifies additional access to grant the OPA agent. This should contain an array of objects with each having an array of apiGroups, an array of resources, and an array of verbs. Just like a RoleBinding. | null
`insights-agent` chart twice you will want to set this flag to `false` on *one* of the installs, doesn't matter which. | true
`opa.targetResources` | A user-specified list of Kubernetes targets to which OPA policies will be applied. Each target requires a list of apiGroups and a list of Resources. | `{}`
`opa.targetResourcesAutoRBAC` | Automatically add RBAC rules allowing get and list operations for APIGroups and Resources supplied via `targetResources`. This *does not* impact RBAC rules added for `defaultTargetResources`. | `true`
`opa.admissionRulesAsTargetResources` | IF the admission controller is enabled, the APIGroups and Resources found in insights-admission `webhookConfig.rules` will be added as OPA Kubernetes target resources, plus supporting RBAC rules are granted to OPA, if the insights-admission `webhookConfig.rulesAutoRBAC` value is also set. | `true`
`goldilocks.controller.flags.exclude-namespaces` | Namespaces to exclude from the goldilocks report | `kube-system`
`goldilocks.vpa.enabled` | Install the Vertical Pod Autoscaler as part of the Goldilocks installation | true
`goldilocks.controller.flags.on-by-default` | Goldilocks will by default monitor all namespaces that aren't excluded | true
`goldilocks.controller.resources` | CPU/memory requests and limits for the Goldilcoks controller |
`goldilocks.dashboard.enabled` | Installs the Goldilocks Dashboard | false
`prometheus-metrics.installPrometheusServer` | Install a new Prometheus server instance for the prometheus report | false
`prometheus-metrics.address` | The address of an existing Prometheus instance to query in the form `<scheme>://<service-name>.<namespace>[:<port>]` for example `http://prometheus-server.prometheus` | `"http://prometheus-server"`
`nova.logLevel` | The klog log-level to use when running Nova | `3`
`pluto.targetVersions` | The versions to target, e.g. `k8s=1.21.0` | Defaults to current Kubernetes version
`awscosts.secretName` | Kubernetes Secret name where AWS creds will be stored | ""
`awscosts.awsAccessKeyId` | AWS access Key ID for AWS costs | ""
`awscosts.awsSecretAccessKey` | AWS access key secrect for AWS costs | ""
`awscosts.region` | AWS region where costs was defined | ""
`awscosts.database` | AWS database where Athena table was created | ""
`awscosts.table` | AWS database Athena table for AWS costs | ""
`awscosts.catalog` | AWS database catalog for AWS costs | ""
`awscosts.serviceAccount.annotations` | Annotations to add to the awscosts service account, e.g. `eks.amazonaws.com/role-arn: arn:aws:iam::ACCOUNT_ID:role/IAM_ROLE_NAME` for accessing aws | nil
`awscosts.tagkey` | Tag used to identify cluster nodes. Example: Kops uses 'kubernetes_cluster'.  | ""
`awscosts.tagvalue` | Tag value used to identify a cluster given a tag key. | ""
`awscosts.workgroup` | Athena work group that used to run the queries | ""

## Breaking Changes

### Version 2.0
The 2.0 release of insights-agent contains several breaking changes to help simplify the installation
and adoption of new tools.

#### Configuration changes
You'll need to change your `values.yaml` to accommodate these changes.
-   Some report names in `values.yaml` have been renamed:
    -   `resourcemetrics` is now `prometheus-metrics`
    -   `kubehunter` is now `kube-hunter`
    -   `rbacreporter` is now `rbac-reporter`
    -   `kubebench` is now `kube-bench`
    -   `rightsizer` is now `right-sizer`
-   `prometheus-metrics` will now install a prometheus server by default. If you'd like to use an existing server, set `prometheus-metrics.installPrometheusServer=false`
-   The `kubesec` report has been deprecated, and should be removed from your values.yaml
-   The `falcosecurity` subchart has been removed. If you want to continue using Falco with Fairwinds Insights, you'll need to install and configure the [Falco chart](https://github.com/falcosecurity/charts/tree/master/falco) separately
    -   we recommend these values:

```yaml
resources:
  requests:
    cpu: 100m
    memory: 256Mi
  limits:
    cpu: 200m
    memory: 512Mi
falco:
  jsonOutput: true
ebpf:
  enabled: false # You can enable this on newer nodes that support eBPF
falcosidekick:
  enabled: true
  fullfqdn: true
  config:
    webhook:
      address: "http://falco-agent.insights-agent:3031/data"
```

#### Behavior changes
No action is required here, but be aware:

-   The `polaris` checks `runAsRootAllowed` and `hostNetwork` have had their severity level increased - they will now block in CI and Admission control after updating to 2.0
-   The Admission Controller will now default to `failureMode=Ignore`
    -   This option determines what the Admission Controller should do when it is experiencing problems or cannot reach the Insights API to make a decision. It can either reject all requests (`failureMode=Fail`) or accept all requests (`failureMode=Ignore`)
    -   The new default will help to make the Admission Controller less disruptive for folks using it in `Passive Mode`
    -   If you are using the Admission Controller as a security measure, and would like to reject requests when there's a problem, you should add `insights-admission.webhookConfig.failurePolicy=Fail` to your `values.yaml`
-   Newer versions of Admission Controller and CI will block on `severity >= 0.7` (CRITICAL or HIGH severity). Previously the threshold was `0.67`
-   The CRDs for OPA have been removed. If you had added any `CustomCheck` or `CustomCheckInstance` resources directly to your cluster, they will be deleted.

