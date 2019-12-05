# Fairwinds Insights Agent

The Fairwinds Insights Agent is a collection of reporting tools, which send data back
to [Fairwinds Insights](https://insights.fairwinds.com). If you'd like access
to Fairwinds Insights, contact `opensource@reactiveops.com`

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

## Configuration
Parameter | Description | Default
--------- | ----------- | -------
`insights.organization` | The name of the organization to upload data to | ""
`insights.cluster` | The name of the cluster the data is coming from | ""
`insights.base64token` | Your cluster's base64-encoded auth token provided by Insights | ""
`insights.tokenSecretName` | If you don't provide a `base64token`, you can specify the name of a secret to pull the token from | ""
`insights.host` | The location of the Insights server | https://insights.fairwinds.com
`uploader.image.repository`  | The repository to pull the uploader script from | quay.io/fairwinds/insights-uploader
`uploader.image.tag` | The tag to use for the uploader script | 0.1
`cronjobs.backoffLimit` | Backoff limit to use for each report CronJob | 1
`cronjobs.failedJobsHistoryLimit` | Number of failed jobs to keep in history for each report | 2
`cronjobs.successfulJobHistoryLimit` | Number of successful jobs to keep in history for each report | 2
`polaris.enabled` | Enable Polaris reports | true
`polaris.schedule` | Cron expression for running Polaris | `rand * * * *`
`polaris.timeout` | Maximum time in seconds to wait for the report | 60
`polaris.image.repository` | Repository to use for the Polaris image | quay.io/reactiveops/polaris
`polaris.image.tag` | Image tag to use for the Polaris image | 0.5.0
`kubehunter.enabled` | Enable Kube Hunter reports | true
`kubehunter.schedule` | Cron expression for running Kube Hunter | `rand * * * *`
`kubehunter.timeout` | Maximum time in seconds to wait for the report | 60
`kubehunter.image.repository` | Repository to use for the Kube Hunter image | quay.io/reactiveops/kube-hunter
`kubehunter.image.tag` | Image tag to use for the Kube Hunter image | 1.0.0
`kubesec.enabled` | Enable Kubesec reports | true
`kubesec.schedule` | Cron expression for running Kubesec | `rand * * * *`
`kubesec.timeout` | Maximum time in seconds to wait for the report | 120
`kubesec.image.repository` | Repository to use for the Kubesec image | aquasec/kube-hunter
`kubesec.image.tag` | Image tag to use for the Kubesec image | 501
`goldilocks.enabled` | Enable Goldilocks reports | true
`goldilocks.schedule` | Cron expression for running Goldilocks | `rand * * * *`
`goldilocks.timeout` | Maximum time in seconds to wait for the report | 60
`goldilocks.image.repository` | Repository to use for the Goldilocks image | quay.io/fairwinds/goldilocks
`goldilocks.image.tag` | Image tag to use for the Workloads image | v1.3.0
`workloads.enabled` | Enable Workloads reports | true
`workloads.schedule` | Cron expression for running the workloads report | `rand * * * *`
`workloads.timeout` | Maximum time in seconds to wait for the report | 60
`workloads.image.repository` | Repository to use for the workload image | quay.io/fairwinds/workloads
`workloads.image.tag` | Image tag to use for the workloads image | 1.0
`trivy.enabled` | Enable Trivy container scanning reports | true
`trivy.schedule` | Cron expression for running the Trivy report | `rand * * * *`
`trivy.timeout` | Maximum time in seconds to wait for the report | 3600
`trivy.image.repository` | Repository to use for the Trivy image | quay.io/fairwinds/fw-trivy
`trivy.image.tag` | Image tag to use for the Trivy image | 0.0
