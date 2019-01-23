# Custom IPTables Rules

In order to connect to memorystore in GKE, you need to add some custom iptables rules to route traffic.

A chart to install [custom iptables](https://github.com/bowei/k8s-custom-iptables/blob/master/run.sh)

Referenced in [GKE docuementation](https://cloud.google.com/memorystore/docs/redis/connect-redis-instance-gke)


## Values

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `image.repository` | Image repository | `gcr.io/google_containers/k8s-custom-iptables` |
| `image.tag` | Image Tag | `1.0` |
| `targets` | IP Range(s) of MemoryStore Instance | `"203.0.113.0/24 198.51.100.0/24"` |
