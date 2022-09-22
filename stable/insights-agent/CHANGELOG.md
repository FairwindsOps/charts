# Changelog
## 2.6.12
* Update CronJob Executor to support arm64 architecture

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
