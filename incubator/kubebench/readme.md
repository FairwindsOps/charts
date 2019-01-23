# kubebench Helm Chart (Beta)
This chart installs a CronJob that will run kube-bench on a regular basis and upload the event to datadog.

** Note: This chart is still beta - proceed with caution! **

## Configuration

| Parameter      | Description                | Default    |
|:---------------|:---------------------------|:-----------|
| image.repository | kube-bench docker repo | aquasec/kube-bench |
| image.tag | kube-bench image tag | latest |
| image.pullPolicy | pull policy for the kubebench image | Always |
| cron.schedule | Cron schedule to run kube-bench | `30 8 * * 1` |
| exporter.image.repository | docker repo for the exporter that exports the results to datadog | quay.io/reactiveops/kubebench-exporter |
| exporter.image.tag | exporter image tag | v1.0 |
| datadog.api_key | datadog api key for your account | `foo` |
| datadog.app_key | datadog app key for your account | `foo` |
| kubernetes.version | Kubernetes version of your cluster.  Note that only a few versions are supported by kube-bench.  You can see the supported versions to use [here](https://github.com/aquasecurity/kube-bench/tree/master/cfg).  If your version isn't defined set it to the closest version available.  | 1.11 |

## Datadog
The following is an example monitor definition that can be used to monitor the audit events emitted from this chart.

```
{
	"name": "Kubebench - Audit Failure",
	"type": "event alert",
	"query": "events('priority:all status:error \"kubebench\"').rollup('count').last('5m') > 0",
	"message": "Kubebench Audit Failures!\nEvent Id: {{event.id}} \n\n{{event.text}} \n@slack-alerts ",
	"tags": [],
	"options": {
		"renotify_interval": 0,
		"timeout_h": 0,
		"thresholds": {},
		"notify_no_data": false,
		"no_data_timeframe": 2,
		"notify_audit": false
	}
}
```
