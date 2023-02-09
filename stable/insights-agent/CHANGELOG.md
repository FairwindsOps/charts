# Changelog

## 2.10.5
* Allow overriding cronjob apiVersion

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
