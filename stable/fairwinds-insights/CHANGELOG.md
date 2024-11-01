# Changelog

## 2.5.1
* Update application version to 16.3. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 2.5.0
* Adds `cronjobs.app_groups_cves_statistics` - inserts CVEs statistics by App Group

## 2.4.0
* Adds `cronjobs.sync-action-items-iac-files` definition - this cronjob is responsible for linking action-items and IaC Files

## 2.3.0
* Adds `useReadReplica` to cronjobs to enable `postgresql.readReplica` injection instead of primary database

## 2.2.7
* Update application version to 16.2. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 2.2.6
* bumped insights agent chart target version

## 2.2.5
* upgrade bitnami postgres chart dependency and postgres-partman version

## 2.2.4
* bumped insights plugins target version

## 2.2.3
* Update application version to 16.1. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 2.2.2
* `rbac.serviceAccount.annotations` are now applied to all Insights related service-accounts
* fix `serviceAccountName` on Insights cronjobs templates

## 2.2.1
* Update application version to 16.0. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 2.2.0
* Add `cronjobs.image-vulns-refresh` support

## 2.1.4
* Update application version to 15.6. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 2.1.3
* Update agent version to 4.x

## 2.1.2
* Update agent version to 3.x

## 2.1.1
* Update application version to 15.5. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 2.1.0
* Updated cronjob close-tickets to update-tickets

## 2.0.4
* Update application version to 15.4. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 2.0.3
* Update application version to 15.3. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 2.0.2
* Update application version to 15.2. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 2.0.1
* Bumped CI plugin to 5.4

## 2.0.0
* Bumped postgres charts to 14.0.5

## 1.0.11
* Update application version to 15.0. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 1.0.10
* Add `cronjobs.move-health-scores-to-ts` support

## 1.0.9
* Update application version to 14.13. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 1.0.8
* Update application version to 14.12. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 1.0.7
* Update `repoScanJob.insightsCIVersion` to `5.3` which provides a better best-effort on scanning 

## 1.0.6
* Update application version to 14.11. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 1.0.5
* Trigger rebuild with new timescale subchart

## 1.0.4
* Update timescale subchart. Timescale version is the same, but some changes were made to the chart.

## 1.0.3
* Update application version to 14.10. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 1.0.2
* Update application version to 14.9. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 1.0.1
* Fix for multiple CronJobs

## 1.0.0
* Refactor logic for creating and modifying CronJobs

## 0.21.8
* Allow additional chars in the URL prefix

## 0.21.7
* Update application version to 14.7. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.21.6
* Update application version to 14.6. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.21.5
* Update application version to 14.5. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.21.4
* Update application version to 14.4. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)
## 0.21.3
* Refine liveness and readiness probes to make them more robust

## 0.21.2
* Update application version to 14.3. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.21.1
* Update application version to 14.2. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.21.0
* Add `terminationGracePeriodSeconds` to insights report job deployment spec

## 0.20.0
* Add `slackChannelsLocalRefresherCronjob` to `stable/fairwinds-insights`.

## 0.19.8
* Update application version to 14.1. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.19.7
* Update application version to 14.0. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.19.6
* Update application version to 13.13. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.19.5
* Updated self hosted agent version to 2.24

## 0.19.4
* Update application version to 13.12. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.19.3
* Update application version to 13.11. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.19.2
* Update application version to 13.10. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.19.1
* Fixed Action Items Statistics schedule

## 0.19.0
* Added job for Action Items Statistics

## 0.18.15
* Update application version to 13.9. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.18.14
* Update application version to 13.8. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.18.13
* Update application version to 13.7. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.18.12
* Update application version to 13.6. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.18.11
* Updated postgres with partman

## 0.18.10
* Update application version to 13.5. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.18.9
* Update application version to 13.4. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.18.8
* Updated self hosted agent version to 2.23

## 0.18.7
* Start testing on 1.26 and 1.27

## 0.18.6
* Update application version to 13.3. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.18.5
* Set kubeVersion in chart manifest

## 0.18.4
* Update application version to 13.2. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.18.3
* Update application version to 13.1. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.18.2
* Update application version to 13.0. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.18.1
* Updated self hosted agent version to 2.21

## 0.18.0
* Bump minio subchart to 5.0.10

## 0.17.3
* Bumped Timescale charts to 0.30.1

## 0.17.2
* Update application version to 12.17. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.17.1
* Update application version to 12.16. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.17.0
* Add support for read replica to hubspot cronjob

## 0.16.0
* Removed old metrics jobs

## 0.15.2
* Update application version to 12.15. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.15.1
* Update application version to 12.14. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.15.0
* Add postMigrate option for the database

## 0.14.0
* Update `repoScanJob.insightsCIVersion` to `5.1` which will add new polaris findings 

## 0.13.0
* Added cloud costs update cron job

## 0.12.26
* Update application version to 12.13. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.12.25
* Updated self hosted agent version to 2.19

## 0.12.24
* Update application version to 12.12. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.12.23
* Update application version to 12.11. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.12.22
* Patch bump for charts CI update

## 0.12.21
* Update application version to 12.10. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.12.20
* Update application version to 12.9. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.12.19
* Update application version to 12.8. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.12.18
* Updated self hosted agent version to 2.17

## 0.12.17
* Update application version to 12.7. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.12.16
* Update application version to 12.6. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

## 0.12.15
* Update application version to 12.5. [See the release notes for more details](https://insights.docs.fairwinds.com/release-notes)

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
