# Changelog

## 2.20.0
* Update polaris to 8.0 and admission to 1.7

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
* Add workload annotion for right-sizer

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
