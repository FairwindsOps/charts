# Changelog

## 4.4.19
* bumped prometheus charts to 25.30.1

## 4.4.18
* bumped Polaris to 9.6

## 4.4.17
* bumped Polaris to 9.5

## 4.4.16
* bump VPA to 4.7.1

## 4.4.15
* bump trivy to 0.31

## 4.4.14
* Add fallback OCI repositories for trivy (ghcr, ecr and docker)

## 4.4.13
* Add support for `SERVICE_ACCOUNT_ANNOTATIONS` environment variable on trivy

## 4.4.12
* bumped nova to 3.11

## 4.4.11
* bumped polaris to 9.4

## 4.4.10
* bumped trivy to 0.30

## 4.4.9
* bumped kube-bench to 0.5

## 4.4.8
* bumped kyverno to 0.3

## 4.4.7
* bumped poalris to 9.3

## 4.4.6
* bumped plugins version

## 4.4.5
* fixed docs

## 4.4.4
* bumped opa version

## 4.4.3
* bumped polaris version

## 4.4.2
* bumped prometheus version

## 4.4.1
* added Fairwinds VPA Admission Controller

## 4.4.0
* added prometheus flag to skip non zero validation

## 4.3.1
* bumped plugins version

## 4.3.0
* bumped plugins version

## 4.2.2
* prometheus cluster name parameter

## 4.2.1
* prometheus service account

## 4.2.0
* Collecting Idle usage from prometheus plugin

## 4.1.1
* Fixed cloud costs data conversion

## 4.1.0
* Bumped cloud costs to 0.2

## 4.0.6
* Added days parameter to cloud costs

## 4.0.5
* update kyverno to v0.2

## 4.0.4
* Fix guard against installing oom-detector unless right-sizer is enabled

## 4.0.3
* add `enableClosedBeta` flag to the `right-sizer` chart, also make it the condition for the VPA subchart

## 4.0.2
* update nova to v3.8.0

## 4.0.1
* add documentation on custom VPA recommender, default min-replicas for vpa updater to 1 for right-sizer

## 4.0.0
* `right-sizer` has been renamed to `oom-detection`, which is a component of the new Insights right-sizer. The `right-sizer` prior to this release will be referred to as `oom-detection` going forward. These binaries may be further consolidated in a future release to avoid confusion. Configuration for `right-sizer` in your `values.yaml` will now be under `right-sizer.oom-detection`. e.g.:

```yaml
# old
right-sizer:
  enabled: true
  schedule: "rand * * * *"
  timeout: 300
# new
right-sizer:
  enabled: true
  oom-detection:
    enabled: true
    schedule: "rand * * * *"
    timeout: 300
```

## 3.1.7
* Updated changelog

## 3.1.6
* Update plugin versions

## 3.1.5
* Fix bug in cloud-costs chart

## 3.1.4
* Fix support for IRSA in cloud-costs

## 3.1.3
* Increase default memory for trivy

## 3.1.2
* Added parameter mountTmp=true as default for aws and cloud costs

## 3.1.1
* use `insights-uploader:0.5` as default (remove fixed patch version) 

## 3.1.0
* upgraded aws costs and cloud costs to support tagprefix parameter

## 3.0.0
> If you're using the prometheus packaged with the Insights Agent, you'll need to run `helm delete insights-agent -n insights-agent` before installing 3.x

* upgrade prometheus helm chart to 25.8.2 and remove pinned kube-state-metrics image. Important note for migration: the following values have been changed in the upstream prometheus chart: `prometheus.nodeExporter` -> `prometheus.prometheus-node-exporter`, `prometheus.pushgateway` -> `prometheus.prometheus-pushgateway`

## 2.26.2
* unset awscosts aws keys in install-reporter configmap 

## 2.26.1
* Cloud Costs - removed gcloud auth and secret

## 2.26.0
* Add TTL option for install-reporter to better support Argo deployment

## 2.25.3
* Cloud costs - added nested ifs to workaround a bug on some helm versions

## 2.25.2
* Cloud costs - google credentials bug fix

## 2.25.1
* Cloud costs plugin bug fix

## 2.25.0
* Added cloud costs plugin

## 2.24.5
* Bumped `polaris` plugin version to `8.5`

## 2.24.4
* Added ingresses resource to `defaultTargetResources`

## 2.24.3
* Fix for adding additional rules for OPA via insights-admission

## 2.24.2
* bump `pluto` to version 5.18

## 2.24.1
* bump `insights-admission` to version '1.9.*' in requirements.yaml

## 2.24.0
* Bumped `opa` plugin version to `2.3`
* Bumped `right-sizer` plugin version to `0.5`
* Bumped `workloads` plugin version to `2.6`

## 2.23.8
* Add mountTmp flag to Kyverno job and default to true

## 2.23.7
* Added install-reporter serviceAccount
## 2.23.6
* Updated kyverno rbac
## 2.23.5
* Bumped `falco` plugin version to `0.3`

## 2.23.4
* Add get/list/watch perms for policy and clusterpolicy to kyverno rbac template

## 2.23.3
* Bumped `trivy` plugin version to `0.28`

## 2.23.2
* Start testing on 1.26 and 1.27

## 2.23.1
* Bumped `workloads` plugin version to `2.5` which exports controllers `PodLabels` and `PodAnnotations`

## 2.23.0
* Add labels for insights-agent

## 2.22.1
* Set kubeVersion in the chart manifest

## 2.22.0
* Add Kyverno plugin

## 2.21.6
* Update Polaris to 8.4

## 2.21.5
* Update insights-admission to 1.8.2

## 2.21.4
* Update insights-admission to 1.8.1
## 2.21.3
* set default runAsGroup for uploader container
## 2.21.2
* Update changelog

## 2.21.1
* Add default runAsGroup for cronjob templates

## 2.21.0
* Update admission controller to 1.8.0

## 2.20.6
* Add default runAsGroups for right-sizer and cronjob-executor

## 2.20.5
* Update trivy plugin to [v0.27](https://github.com/FairwindsOps/insights-plugins/blob/main/plugins/trivy/CHANGELOG.md#0270)

## 2.20.4
* Update polaris to 8.2

## 2.20.3
* Add configurable values and sensible defaults to install-reporter

## 2.20.2
* Adds test that deletes existing jobs upon `helm test`

## 2.20.1
* Fix an issue with readonly filesystem when awscosts with IRSA is used

## 2.20.0
* Update polaris to 8.0 and admission to 1.7
* New Polaris policies and changes to some default severities:
    * Includes a newer version of Polaris, which adds the following policies:
        * priorityClassNotSet
        * metadataAndNameMismatched
        * missingPodDisruptionBudget
        * automountServiceAccountToken
        * missingNetworkPolicy
    * Changes the default severity to High or Critical for the following existing Polaris policies:
        * sensitiveContainerEnvVar
        * sensitiveConfigmapContent
        * clusterrolePodExecAttach
        * rolePodExecAttach
        * clusterrolebindingPodExecAttach
        * rolebindingClusterRolePodExecAttach
        * rolebindingRolePodExecAttach
        * clusterrolebindingClusterAdmin
        * rolebindingClusterAdminClusterRole
        * rolebindingClusterAdminRole
    * While this provides even more visibility to the state of your Kubernetes health, the Policies that change the default severity to High or Critical may block some Admission Controller requests. If you need to mitigate this impact, Fairwinds recommends creating an Automation Rule that lowers the severity of those policies so it does not trigger blocking behavior. If you need assistance with this, please reach out to support@fairwinds.com.

## 2.19.0
* Update version of aws costs to 1.3

## 2.18.2
* Update version of insights-admission to 1.6.4

## 2.18.1
* Patch bump for updating charts CI

## 2.18.0
* Update prometheus subchart to latest minor version

## 2.17.4
* Update registry for kube-state-metrics

## 2.17.3
* Move duplicate volumes statement in kube-bench inside the if statement

## 2.17.2
* Fix issue with kube-bench volumes

## 2.17.1
* Fix duplicate key issue when using Kustomize/Flux

## 2.17.0
* Allow custom labels and annotations for each report

## 2.16.2
* Fix syntax errors around use of imagePullSecrets as part of Containers section of PodSpec to permit use of insights-agent with private container repos

## 2.16.1
* Add workload annotation for right-sizer

## 2.16.0
* Add namespace allowlist to trivy

## 2.15.1
* Fix env vars for install-reporter

## 2.15.0
* Update pluto, and detect in-cluster resources using the `last-applied-configuration` annotation.

## 2.14.2
* Add customWorkloadAnnotations for additional workload annotations
## 2.14.1
* Update Goldilocks chart version to 6.5.*

## 2.14.0
* Update versions for polaris, goldilocks, pluto, prometheus, trivy, and uploader

## 2.13.0
* Run fleet installer as part of normal setup instead of as a pre-install/pre-upgrade hook

This is a **breaking change** for users of fleet-installer on Kubernetes 1.21 and earlier.
Now, the fleet-installer Job uses a `ttl` to remove itself instead of a helm-hook. `ttl` is
only available as of 1.22.

## 2.12.0
* Add the ability to use a custom SSL certificate to validate communication with a self-hosted Insights API.

## 2.11.1
* Changed the backend for the fleet installer test

## 2.11.0
* Bumped AWS costs plugin for new Days parameter

## 2.10.6
* Fix CronJob version override for aws-costs and falco

## 2.10.5
* Allow overriding cronjob apiVersion and update goldilocks repository

## 2.10.4
* Update polaris, pluto, nova, goldilocks

## 2.10.3
* Update testing versions

## 2.10.2
* Revert v2.10.1

## 2.10.1
* Update Goldilocks, Nova, Pluto, and Polaris

## 2.10.0
* BUmp insights-admission to chart 1.5.* (to use app 1.9)
* Bump nova to 3.5

## 2.9.4
* Bumped workload version for saving Ingresses information

## 2.9.3
* Fix the goldilocks-controller to use the upstream chart supporting V4, and update its RBAC to allow access via the built-in view ClusterRole, matching the CronJob. See also, Goldilocks PR https://github.com/FairwindsOps/charts/pull/1034

## 2.9.2
* Bump versions for trivy, polaris, opa, nova, and goldilocks

## 2.9.1
* Add a `trivy.env` chart value to allow passing environment variables to the trivy container, as a map of `name: value`.

## 2.9.0
* Update Goldilocks to version 4.4.0

## 2.8.3
* Update pluto to 5.11

## 2.8.2
* Update changelog logic

## 2.8.1
* Add error messages when required values are not set for awscosts

## 2.8.0
* Update admission subchart to 1.4.1

## 2.7.0
* Support arm64 architecture (CronJob executor and insights-plugins)

## 2.6.11
* Update `nova` version to `v3.4`
* Use `nova find --helm --containers` to run `nova` - This way, both outdated/deprecated charts and containers will be reported to the output file

## 2.6.10
Update insights-admission dependency - reattempt of 2.6.9

## 2.6.9
Update insights-admission dependency (Now uses admission plugin 1.6)

## 2.6.8
Add Polaris RBAC permission to get and list ClusterRoles, ClusterRoleBindings, Roles, and RoleBindings. These permissions are required by new RBAC related Polaris checks:
* https://github.com/FairwindsOps/polaris/pull/820
* https://github.com/FairwindsOps/polaris/pull/823

## 2.6.7
* Fix for how report-specific securityContexts are handled

## 2.6.6
* Update nova version to 3.3

## 2.6.5
* Update plugin versions

## 2.6.4
* Update polaris to latest (7.0)

## 2.6.3
* Update some plugin versions

## 2.6.2
* Start requiring changelog for insights-agent
