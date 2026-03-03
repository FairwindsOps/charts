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
* `cloudcosts` (AWS, GCP, or Azure; optional FOCUS format)

See below for configuration details.

## Fleet Installation
If you're installing the Insights Agent across a large fleet of clusters,
it can be tedious to use the UI to create each cluster, then copy out the
cluster's access token.

To better serve customers with a large number of clusters, we've created a flow
that allows you to easily deploy the Insights Agent across your fleet.
[Read more here](https://insights.docs.fairwinds.com/features/in-cluster-scanning/#fleet-installation)

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
`uploader.image.tag` | The tag to use for the uploader script | 0.5
`uploader.resources` | CPU/memory requests and limits for the uploader script |
`uploader.sendFailures` | Send logs of failure to Insights when a job fails. | true
`uploader.env` | Set extra environment variables for the uploader script | []
`installReporter.ttl` | Set to -1 to prevent install reporter job from cleaning up after itself | 300
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
`prometheus-metrics.bearerToken` | Bearer token for Prometheus authentication (not recommended for production, use bearerTokenSecretName instead) | `""`
`prometheus-metrics.bearerTokenSecretName` | Name of an existing Secret containing the bearer token for Prometheus authentication | `""`
`prometheus-metrics.bearerTokenSecretKey` | Key within the secret containing the bearer token | `"token"`
`prometheus-metrics.tenantId` | Tenant ID for multi-tenant Prometheus backends like Grafana Mimir (sets `X-Scope-OrgID` header) | `""`
`nova.logLevel` | The klog log-level to use when running Nova | `3`
`pluto.targetVersions` | The versions to target, e.g. `k8s=1.21.0` | Defaults to current Kubernetes version
`cloudcosts.enabled` | Enable the cloud-costs report (AWS, GCP, or Azure) | false
`cloudcosts.provider` | Cloud provider: `aws`, `gcp`, or `azure` | aws
`cloudcosts.secretName` | Kubernetes Secret name for provider credentials (AWS only; Azure uses Workload Identity, no secret) | ""
`cloudcosts.tagkey` | Tag key to filter resources (e.g. kubernetes-cluster) | ""
`cloudcosts.tagvalue` | Tag value to filter resources | ""
`cloudcosts.format` | Output format: `standard` or `focus` (AWS/GCP only; Azure always uses FOCUS) | standard
`cloudcosts.days` | Number of days to query | 5
`cloudcosts.aws.region` | AWS region for Athena | ""
`cloudcosts.aws.database` | Athena database name | ""
`cloudcosts.aws.table` | Athena table name | ""
`cloudcosts.aws.catalog` | Athena catalog | ""
`cloudcosts.aws.workgroup` | Athena workgroup | ""
`cloudcosts.aws.tagprefix` | Tag prefix for AWS CUR (e.g. resource_tags_user_) | resource_tags_user_
`cloudcosts.gcp.projectname` | GCP project name | ""
`cloudcosts.gcp.dataset` | BigQuery dataset name | ""
`cloudcosts.gcp.billingaccount` | GCP billing account ID | ""
`cloudcosts.gcp.table` | BigQuery table path (optional) | ""
`cloudcosts.gcp.focusview` | BigQuery FOCUS view name (required when format is focus) | ""
`cloudcosts.azure.subscription` | Azure subscription ID (required when provider is azure) | ""
`cloudcosts.azure.workloadIdentity.clientId` | Azure AD Workload Identity: client ID of the Azure AD app or user-assigned managed identity (required when provider is azure) | ""
`cloudcosts.azure.workloadIdentity.tenantId` | Azure AD Workload Identity: tenant ID (required when provider is azure) | ""
`cloudcosts.serviceAccount.annotations` | Annotations for the cloud-costs service account, e.g. `eks.amazonaws.com/role-arn` for IRSA (AWS) | nil
`insights-event-watcher.enabled` | Enable the insights-event-watcher component | `true`
`insights-event-watcher.image.repository` | Repository for the insights-event-watcher image | `quay.io/fairwinds/insights-event-watcher`
`insights-event-watcher.image.tag` | Tag for the insights-event-watcher image | `0.1`
`insights-event-watcher.logLevel` | Log level for the watcher (debug, info, warn, error) | `info`
`insights-event-watcher.eventBufferSize` | Size of the event processing buffer | `1000`
`insights-event-watcher.httpTimeoutSeconds` | HTTP client timeout in seconds | `30`
`insights-event-watcher.rateLimitPerMinute` | Maximum API calls per minute | `60`
`insights-event-watcher.consoleMode` | Print events to console instead of sending to Insights (useful for debugging) | `false`
`insights-event-watcher.auditLogPath` | Path to Kubernetes audit log file (optional). Used in local mode | `"/var/log/kubernetes/kube-apiserver-audit.log"`
`insights-event-watcher.cloudwatch.enabled` | Enable CloudWatch log processing for EKS clusters | `false`
`insights-event-watcher.cloudwatch.logGroupName` | CloudWatch log group name for EKS audit logs | `"/aws/eks/production-eks/cluster"`
`insights-event-watcher.cloudwatch.region` | AWS region for CloudWatch logs | `"us-west-2"`
`insights-event-watcher.cloudwatch.filterPattern` | CloudWatch filter pattern for log events | `"{ $.stage = \"ResponseComplete\" && $.responseStatus.code >= 400 }"`
`insights-event-watcher.cloudwatch.batchSize` | Number of log events to process in each batch | `100`
`insights-event-watcher.cloudwatch.pollInterval` | Interval between CloudWatch log polls | `"30s"`
`insights-event-watcher.cloudwatch.maxMemoryMB` | Maximum memory usage in MB for CloudWatch processing | `512`
`insights-event-watcher.serviceAccount.annotations` | Annotations to add to the service account, e.g. `eks.amazonaws.com/role-arn: arn:aws:iam::ACCOUNT_ID:role/IAM_ROLE_NAME` for IRSA | `nil`
`insights-event-watcher.resources` | CPU/memory requests and limits for the watcher | See values.yaml

### Azure Workload Identity: Creating the federated credential (cloud-costs)

When `cloudcosts` uses `provider: azure`, the chart uses [Azure AD Workload Identity](https://learn.microsoft.com/en-us/azure/aks/workload-identity-overview). Azure trusts a token from your AKS cluster only if the app has a **federated identity credential** whose **issuer** exactly matches that cluster’s OIDC issuer. If the issuer does not match (e.g. wrong cluster, or cluster was recreated), authentication will fail even when your Helm values are correct.

**Terminology:**

- **Application (client) ID** — Used in Helm as `cloudcosts.azure.workloadIdentity.clientId` and in `--assignee` for RBAC. Shown in Azure Portal under the app’s “Overview”.
- **Object ID** — The app’s object ID in Entra ID. Required by `az ad app federated-credential create --id`. Not the same as client ID. Get it with: `az ad app show --id <client-id> --query id -o tsv`.
- **OIDC issuer** — A unique URL per AKS cluster (e.g. `https://eastus.oic.prod-aks.azure.com/.../.../`). The federated credential’s **Issuer** field must match this value exactly (including trailing slash if the cluster returns one).

**Steps**

1. **Create an App registration** (or use an existing one) in [Microsoft Entra ID](https://portal.azure.com/#view/Microsoft_AAD_RegisteredApps/ApplicationsListBlade). From the app’s **Overview**, note:
   - **Application (client) ID** → `cloudcosts.azure.workloadIdentity.clientId`
   - **Directory (tenant) ID** → `cloudcosts.azure.workloadIdentity.tenantId`

2. **Enable Workload Identity on the AKS cluster** where you will install the chart (if not already enabled). The cluster needs both OIDC issuer and Workload Identity so pods can receive the federated token.

   ```bash
   az aks update --name <cluster-name> --resource-group <resource-group> \
     --enable-oidc-issuer --enable-workload-identity
   ```

   Wait for the update to finish. For new clusters, use `az aks create` with `--enable-oidc-issuer` and `--enable-workload-identity`.

3. **Get the OIDC issuer URL for that same cluster.** Use the exact string (including or excluding a trailing slash exactly as returned).

   ```bash
   az aks show --name <cluster-name> --resource-group <resource-group> \
     --query "oidcIssuerProfile.issuerUrl" -o tsv
   ```

4. **Create a federated identity credential** on the app, so Azure trusts tokens from this cluster for this service account.

   - **In Azure Portal:** **App registrations** → your app → **Certificates & secrets** → **Federated credentials** → **Add credential**. Set Issuer = URL from step 3, Subject and Audiences as below.
   - **With Azure CLI:** You must pass the app’s **Object ID** to `--id` (not the client ID). Example, replacing `<cluster-name>`, `<resource-group>`, and `<client-id>`:

   ```bash
   # Get the app's Object ID (replace <client-id> with your Application (client) ID)
   APP_OBJECT_ID=$(az ad app show --id <client-id> --query id -o tsv)

   # Get the cluster's OIDC issuer (same cluster where you will install the chart)
   ISSUER_URL=$(az aks show --name <cluster-name> --resource-group <resource-group> \
     --query "oidcIssuerProfile.issuerUrl" -o tsv)

   # Create the federated credential
   az ad app federated-credential create \
     --id "$APP_OBJECT_ID" \
     --parameters "{
       \"name\": \"insights-agent-cloudcosts-<cluster-name>\",
       \"issuer\": \"$ISSUER_URL\",
       \"subject\": \"system:serviceaccount:insights-agent:insights-agent-cloudcosts\",
       \"description\": \"AKS workload identity for insights-agent cloud-costs\",
       \"audiences\": [\"api://AzureADTokenExchange\"]
     }"
   ```

   **Federated credential fields:**

   | Field      | Value |
   |-----------|--------|
   | **Subject** | `system:serviceaccount:insights-agent:insights-agent-cloudcosts` (default namespace `insights-agent`). If you install in another namespace, use `system:serviceaccount:<namespace>:insights-agent-cloudcosts`. |
   | **Issuer**  | The URL from step 3, character-for-character (including trailing slash if present). **Each AKS cluster has a different issuer.** You need one federated credential per cluster; reuse the same app but add a new credential with that cluster’s issuer. |
   | **Audiences** | `api://AzureADTokenExchange` |

5. **Assign RBAC** so the identity can read cost data. Use the **client ID** (not Object ID) as `--assignee`:

   ```bash
   az role assignment create --role "Reader" \
     --assignee <client-id> --scope /subscriptions/<subscription-id>
   az role assignment create --role "Cost Management Reader" \
     --assignee <client-id> --scope /subscriptions/<subscription-id>
   ```

   Use the same **client ID** as `cloudcosts.azure.workloadIdentity.clientId` and the subscription ID as `cloudcosts.azure.subscription`.

**Verify (if cloud-costs fails to authenticate):**

- Confirm the app has a federated credential whose **Issuer** exactly matches the cluster where the chart is installed: run step 3 for that cluster and compare to the credential in **App registrations** → app → **Federated credentials**.
- Confirm **Subject** matches your install: `system:serviceaccount:<namespace>:insights-agent-cloudcosts` (default namespace is `insights-agent`).
- Confirm Helm values use **Application (client) ID** and **Directory (tenant) ID** from the app’s Overview, and that RBAC was granted for that client ID on the subscription.

### GPU metrics (dcgm-exporter, amd-device-metrics-exporter) on clusters with mixed or no GPU nodes

You can use **nodeSelector**, **node affinity** (`affinity.nodeAffinity`), and **tolerations**—alone or together—to control where the GPU exporter runs. The default **nodeSelector** uses **Azure AKS**-friendly labels: **NVIDIA** `accelerator: nvidia` (common on AKS GPU node pools). Use **node affinity** for advanced scheduling (e.g. multiple node selector terms or preferred rules). Use **tolerations** when your GPU nodes have taints. Example with **nodeAffinity**:

```yaml
dcgm-exporter:
  enabled: true
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
          - matchExpressions:
              - key: accelerator
                operator: In
                values:
                  - nvidia
```

**NVIDIA (dcgm-exporter)** — Override `nodeSelector` for your cloud:
- **Azure AKS:** `accelerator: nvidia` (default)
- **GKE:** `cloud.google.com/gke-accelerator: "true"`
- **EKS:** `k8s.amazonaws.com/accelerator: nvidia` (or your GPU type label)
- **Other / NVIDIA device plugin:** `nvidia.com/gpu.present: "true"`

```yaml
dcgm-exporter:
  enabled: true
  nodeSelector:
    accelerator: nvidia   # Azure AKS (default). GKE: cloud.google.com/gke-accelerator: "true". EKS: k8s.amazonaws.com/accelerator: nvidia. NVIDIA device plugin: nvidia.com/gpu.present: "true"
  # affinity: {}   # optional: node affinity (e.g. nodeAffinity) for advanced scheduling
  # tolerations: []   # required if GPU nodes have taints
```

**AMD (amd-device-metrics-exporter)** — Default `nodeSelector`: `amd.com/gpu: "true"`. For GKE (AMD GPU nodes) use `feature.node.kubernetes.io/amd-gpu: "true"`. Override if your AMD GPU nodes use a different label:

```yaml
amd-device-metrics-exporter:
  enabled: true
  nodeSelector:
    amd.com/gpu: "true"   # GKE (AMD): feature.node.kubernetes.io/amd-gpu: "true"
  # affinity: {}   # optional: node affinity (e.g. nodeAffinity) for advanced scheduling
  # tolerations: []   # required if GPU nodes have taints
```

Only apply the GPU label to nodes that actually have the driver installed; otherwise pods will crash.

### Version 4.0
The 4.0 release of insights-agent contains breaking changes to `right-sizer`. This component has been rebranded to refer to Insights automated right sizing. The `right-sizer` prior to this release will be referred to as `oom-detection` going forward. These will be further consolidated in a future release to avoid confusion.

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

