# LogEntries Helm Chart

This chart will install the LogEntries Kubernetes agent.


## Configuration

| Required? | Parameter | Description | Default |
|-----------|-----------|-------------|---------|
| Y | logentries.token | The api token the service will use. | |
| N | image.args | list of optional args to provide.  See the [docker hub documentation](https://hub.docker.com/r/logentries/docker-logentries/) for details. | |
