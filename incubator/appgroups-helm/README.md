# appgroups-helm

A Helm chart for Kubernetes

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| devAppGroups | list | `[{"clusters":["us-east1-dev*","us-east2-dev*"],"labels":[{"foo":"bar"},{"key":"value"}],"name":"dev-one","namespaceLabels":[{"fargle":"bargle"}]},{"clusters":["us-east1-dev*","us-east2-dev*"],"name":"dev-two"}]` | The list of dev appGroups |
| devAppGroups[0] | object | `{"clusters":["us-east1-dev*","us-east2-dev*"],"labels":[{"foo":"bar"},{"key":"value"}],"name":"dev-one","namespaceLabels":[{"fargle":"bargle"}]}` | dev-one |
| devAppGroups[1] | object | `{"clusters":["us-east1-dev*","us-east2-dev*"],"name":"dev-two"}` | dev-two |
| prodAppGroups | list | `[{"clusters":["us-east1-prod*","us-east2-prod*"],"labels":[{"env":"prod"}],"name":"prod-one"}]` | The list of prod appGroups |
| x-clusters | object | `{"devClusters":["us-east1-dev*","us-east2-dev*"],"prodClusters":["us-east1-prod*","us-east2-prod*"],"testClusters":["us-east1-test*","us-east2-test*"]}` | pre-defined cluster groups |
| x-labelSelectors | object | `{"prodLabels":[{"env":"prod"}]}` | labels to use when selecting production stuff |

## Usage

You may want to change the `-o` to a different directory.

`helm template .  | kubectl slice -f - -o /tmp -t "{{ .name }}.yaml"`

This uses https://github.com/patrickdappollonio/kubectl-slice to split the files into separate outputs.

## Generating This Doc

This is generated from README.md.gotmpl using https://github.com/norwoodj/helm-docs
