# Load Generation

A chart that uses k6 to generate load

## Values

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `image.pullPolicy` |  | `Always` |
| `image.repository` |  | `loadimpact/k6` |
| `image.tag` |  | `0.22.1` |
| `loadScript` | The js script that you want to generate the load.  | `import http from "k6/http";` | `SEE Values.yaml` |
| `replicaCount` | Number of load pods  | `1` |
| `resources.limits.cpu` |  | `500m` |
| `resources.limits.memory` |  | `256Mi` |
| `resources.requests.cpu` |  | `250m` |
| `resources.requests.memory` |  | `128Mi` |
| `k6.duration` | Duration of k6 test | `0` - infinite, keep running while pod runs |
| `k6.rps` | Max requests per second in each k6 pod | `1` |
| `k6.maxVUs` | Max number of k6 VUs per pod | `1` |
| `k6.VUs` | Actual number of running VUs at start. Must be less than maxVUs | `1` |
| `influx.eanbled` | Enable sending to an influxdb | `false` |
| `influx.dbName` | Name of influx database to keep data | `k6`  |
| `influx.insecure` | non-https influx | `true` |
| `influx.url` | URL of influx to send to | `"http://data-influxdb.tick:8086"` |
| `influx.retention` | Name of influx retention policy to use for data | `autogen` |
