# appgroups-helm

A Helm chart for Kubernetes

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| devAppGroups | list | `[{"labels":[{"foo":"bar"},{"key":"value"}],"name":"dev-one","namespaceLabels":[{"fargle":"bargle"}]},{"name":"dev-two"}]` | The list of dev appGroups |
| devAppGroups[0] | object | `{"labels":[{"foo":"bar"},{"key":"value"}],"name":"dev-one","namespaceLabels":[{"fargle":"bargle"}]}` | dev-one |
| devAppGroups[1] | object | `{"name":"dev-two"}` | dev-two |
| prodAppGroups | list | `[{"name":"prod-one"}]` | The list of prod appGroups |
| prodLabels | list | `[{"env":"prod"}]` | labels to use when selecting production stuff |

## Usage

You may want to change the `-o` to a different directory.

`helm template .  | kubectl slice -f - -o /tmp -t "{{ .name }}.yaml"`

This uses https://github.com/patrickdappollonio/kubectl-slice to split the files into separate outputs.

## Generating This Doc

This is generated from README.md.gotmpl using https://github.com/norwoodj/helm-docs
