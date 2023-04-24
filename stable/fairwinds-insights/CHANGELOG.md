# Changelog

## 0.12.15
* Added cloud costs update job to Insights.

## 0.12.14
* Update application version to 12.4. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.12.13
* Update application version to 12.3. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.12.12
* Update application version to 12.2. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.12.11
* Update application version to 12.1. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.12.10
* Update application version to 12.0. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.12.9
* Update application version to 11.13. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.12.8
* Update application version to 11.12. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.12.7
* Update application version to 11.11. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.12.6
* Update application version to 11.10. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.12.5
* Update application version to 11.9. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.12.4
* Enable `automatedPullRequestJob` by default and update `repoScanJob.insightsCIVersion` to `5.0` which contains manifests `filename` fix 

## 0.12.3
* Update application version to 11.8. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.12.2
* Adds `CRON_JOB_IMAGE_REPOSITORY` to `stable/fairwinds-insights` deployments environment variables

## 0.12.1
* Fix service-account ref. for automated-pr-jobs deployment

## 0.12.0
* Add `automatedPullRequestJob` support to `stable/fairwinds-insights`.

## 0.11.0
* Change default timescale options to better support the default installation

## 0.10.2
* Update application version to 11.7. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.10.1
* Updated self hosted agent version to 2.10

## 0.10.0
* Add `actionItemsFiltersRefresherCronJob` to `stable/fairwinds-insights`.

## 0.9.12
* Update application version to 11.6. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.9.11
* Update testing versions

## 0.9.10
* Update application version to 11.5. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.9.9
* Update application version to 11.4. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.9.8
* Update application version to 11.3. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.9.7
* Bump CI to 4.2, for auto-scan.

## 0.9.6
* Update application version to 11.2. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.9.5
* Fixed Timescale pod and service name

## 0.9.4
* Bumped Timescale charts to 0.30.0

## 0.9.3
* Update application version to 11.1. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.9.2
* Update application version to 11.0. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.9.1
* Update application version to 10.12. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.9.0
* BREAKING: Upgrading minio to new charts

## 0.8.1
* Bug fix for timescale secret

## 0.8.0
* BREAKING: Bumping postgres to bitnami chart 12.1.6, and postgres version 14. See README for changes to `postgresql` Helm values, or view the [full options](https://github.com/bitnami/charts/tree/main/bitnami/postgresql) in the downstream chart.

## 0.7.11
* Update application version to 10.10. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.7.10
* Update default version of Insights Agent to 2.9.4

## 0.7.9
* Update application version to 10.9. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.7.8
* Add resource limits for overprovisioning deployment

## 0.7.7
* Add secrets RBAC capabilities (get/create/delete) to repo-scan-job service-account

## 0.7.6
* Update application version to 10.8. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.7.5
* Disable weekly digest emails

## 0.7.4
* Update application version to 10.7. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.7.3
* Update application version to 10.6. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.7.2
* Added PDB to Timescale DB

## 0.7.1
* Update application version to 10.5. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.7.0
* Update timescale subchart

## 0.6.24
* Update application version to 10.4. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.6.23
* Bumped cpu and memory for recommendations job

## 0.6.22
* Introduce CHANGELOG
