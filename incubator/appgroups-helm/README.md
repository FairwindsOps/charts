# appgroups-helm

This chart is an example of how an end-user might use Helm to template a large
number of appGroups and policyMappings. It uses helm templates with yaml anchors
in the values file to pre-define groups of labels or clusters, and then uses a
{{with}} block to allow defining all the appGroups and policyMappings in one place

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| appGroups | object | `{"dev":[{"clusters":["us-east1-dev*","us-east2-dev*"],"labels":[{"foo":"bar"},{"key":"value"}],"name":"appGroup_dev-one","namespaceLabels":[{"fargle":"bargle"}]},{"clusters":["us-east1-dev*","us-east2-dev*"],"name":"appGroup_dev-two"}],"prod":[{"clusters":["us-east1-prod*","us-east2-prod*"],"labels":[{"env":"prod"}],"name":"appGroup_prod-one"}]}` | All of the appGroups |
| appGroups.dev | list | `[{"clusters":["us-east1-dev*","us-east2-dev*"],"labels":[{"foo":"bar"},{"key":"value"}],"name":"appGroup_dev-one","namespaceLabels":[{"fargle":"bargle"}]},{"clusters":["us-east1-dev*","us-east2-dev*"],"name":"appGroup_dev-two"}]` | dev policy mappings |
| appGroups.dev[0] | object | `{"clusters":["us-east1-dev*","us-east2-dev*"],"labels":[{"foo":"bar"},{"key":"value"}],"name":"appGroup_dev-one","namespaceLabels":[{"fargle":"bargle"}]}` | dev-one |
| appGroups.dev[1] | object | `{"clusters":["us-east1-dev*","us-east2-dev*"],"name":"appGroup_dev-two"}` | dev-two |
| appGroups.prod | list | `[{"clusters":["us-east1-prod*","us-east2-prod*"],"labels":[{"env":"prod"}],"name":"appGroup_prod-one"}]` | The list of prod appGroups |
| appGroups.prod[0] | object | `{"clusters":["us-east1-prod*","us-east2-prod*"],"labels":[{"env":"prod"}],"name":"appGroup_prod-one"}` | prod-one |
| policyMappings | object | `{"dev":[{"appGroups":["dev-one"],"block":true,"name":"policyMapping_dev-blocking","policies":["polaris.procMount"]},{"appGroups":["dev-one"],"block":false,"name":"policyMapping_dev-audit","policies":["polaris.tagNotSpecified","polaris.runAsPrivileged","polaris.runAsRootAllowed","polaris.privilegeEscalationAllowed","polaris.hostPIDSet","polaris.hostIPCSet","polaris.dangerousCapabilities"]}]}` | All of the policyMappings |
| policyMappings.dev | list | `[{"appGroups":["dev-one"],"block":true,"name":"policyMapping_dev-blocking","policies":["polaris.procMount"]},{"appGroups":["dev-one"],"block":false,"name":"policyMapping_dev-audit","policies":["polaris.tagNotSpecified","polaris.runAsPrivileged","polaris.runAsRootAllowed","polaris.privilegeEscalationAllowed","polaris.hostPIDSet","polaris.hostIPCSet","polaris.dangerousCapabilities"]}]` | dev policy mappings |
| x-clusters | object | `{"devClusters":["us-east1-dev*","us-east2-dev*"],"prodClusters":["us-east1-prod*","us-east2-prod*"],"testClusters":["us-east1-test*","us-east2-test*"]}` | pre-defined cluster groups |
| x-labelSelectors | object | `{"prodLabels":[{"env":"prod"}]}` | labels to use when selecting production stuff |
| x-policiesAudit[0] | string | `"polaris.tagNotSpecified"` |  |
| x-policiesAudit[1] | string | `"polaris.runAsPrivileged"` |  |
| x-policiesAudit[2] | string | `"polaris.runAsRootAllowed"` |  |
| x-policiesAudit[3] | string | `"polaris.privilegeEscalationAllowed"` |  |
| x-policiesAudit[4] | string | `"polaris.hostPIDSet"` |  |
| x-policiesAudit[5] | string | `"polaris.hostIPCSet"` |  |
| x-policiesAudit[6] | string | `"polaris.dangerousCapabilities"` |  |
| x-policiesBlocking | list | `["polaris.procMount"]` | blocking policies |

## Usage

You may want to change the `-o` to a different directory.

`helm template .  | kubectl slice -f - -o /tmp -t "{{ .name }}.yaml"`

This uses https://github.com/patrickdappollonio/kubectl-slice to split the files into separate outputs.

## Generating This Doc

This is generated from README.md.gotmpl using https://github.com/norwoodj/helm-docs
