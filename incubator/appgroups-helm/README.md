# appgroups-helm

This chart is an example of how an end-user might use Helm to template a large
number of appGroups and policyMappings. It uses helm templates with yaml anchors
in the values file to pre-define groups of labels or clusters, and then uses a
{{with}} block to allow defining all the appGroups and policyMappings in one place

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| appGroups | object | `{"dev":[{"clusters":["us-east1-dev*","us-east2-dev*"],"labels":[{"foo":"bar"},{"key":"value"}],"name":"appGroup_ddev-one","namespaceLabels":[{"fargle":"bargle"}]},{"clusters":["us-east1-dev*","us-east2-dev*"],"name":"appGroup_dev-two"}],"prod":[{"clusters":["us-east1-prod*","us-east2-prod*"],"labels":[{"env":"prod"}],"name":"appGroup_prod-one"}]}` | All of the appGroups |
| appGroups.dev | list | `[{"clusters":["us-east1-dev*","us-east2-dev*"],"labels":[{"foo":"bar"},{"key":"value"}],"name":"appGroup_ddev-one","namespaceLabels":[{"fargle":"bargle"}]},{"clusters":["us-east1-dev*","us-east2-dev*"],"name":"appGroup_dev-two"}]` | dev policy mappings |
| appGroups.dev[0] | object | `{"clusters":["us-east1-dev*","us-east2-dev*"],"labels":[{"foo":"bar"},{"key":"value"}],"name":"appGroup_ddev-one","namespaceLabels":[{"fargle":"bargle"}]}` | dev-one |
| appGroups.dev[1] | object | `{"clusters":["us-east1-dev*","us-east2-dev*"],"name":"appGroup_dev-two"}` | dev-two |
| appGroups.prod | list | `[{"clusters":["us-east1-prod*","us-east2-prod*"],"labels":[{"env":"prod"}],"name":"appGroup_prod-one"}]` | The list of prod appGroups |
| appGroups.prod[0] | object | `{"clusters":["us-east1-prod*","us-east2-prod*"],"labels":[{"env":"prod"}],"name":"appGroup_prod-one"}` | prod-one |
| policyMappings | object | `{"dev":[{"appGroups":["dev-one"],"block":true,"name":"policyMapping_dev-blocking","policies":["polaris.procMount"]},{"appGroups":["dev-one"],"block":false,"name":"policyMapping_dev-audit","policies":["polaris.tagNotSpecified","polaris.runAsPrivileged","polaris.runAsRootAllowed","polaris.privilegeEscalationAllowed","polaris.hostPIDSet","polaris.hostIPCSet","polaris.dangerousCapabilities","polaris.topologySpreadConstraint","polaris.pdbMinAvailableGreaterThanHPAMinReplicas","polaris.pdbDisruptionsIsZero","polaris.hpaMinAvailability","polaris.hpaMaxAvailability","polaris.readinessProbeMissing","polaris.livenessProbeMissing","polaris.pullPolicyNotAlways","polaris.procMount","polaris.notReadOnlyRootFilesystem","polaris.missingPodDisruptionBudget","polaris.metadataAndInstanceMismatched","polaris.metadataAndNameMismatched","polaris.memoryRequestsMissing","polaris.memoryLimitsMissing","polaris.cpuRequestsMissing","polaris.linuxHardening","polaris.hostPathSet","polaris.hostNetworkSet","polaris.hostProcess","polaris.hostPortSet","polaris.automountServiceAccountToken"]}]}` | All of the policyMappings |
| policyMappings.dev | list | `[{"appGroups":["dev-one"],"block":true,"name":"policyMapping_dev-blocking","policies":["polaris.procMount"]},{"appGroups":["dev-one"],"block":false,"name":"policyMapping_dev-audit","policies":["polaris.tagNotSpecified","polaris.runAsPrivileged","polaris.runAsRootAllowed","polaris.privilegeEscalationAllowed","polaris.hostPIDSet","polaris.hostIPCSet","polaris.dangerousCapabilities","polaris.topologySpreadConstraint","polaris.pdbMinAvailableGreaterThanHPAMinReplicas","polaris.pdbDisruptionsIsZero","polaris.hpaMinAvailability","polaris.hpaMaxAvailability","polaris.readinessProbeMissing","polaris.livenessProbeMissing","polaris.pullPolicyNotAlways","polaris.procMount","polaris.notReadOnlyRootFilesystem","polaris.missingPodDisruptionBudget","polaris.metadataAndInstanceMismatched","polaris.metadataAndNameMismatched","polaris.memoryRequestsMissing","polaris.memoryLimitsMissing","polaris.cpuRequestsMissing","polaris.linuxHardening","polaris.hostPathSet","polaris.hostNetworkSet","polaris.hostProcess","polaris.hostPortSet","polaris.automountServiceAccountToken"]}]` | dev policy mappings |
| x-clusters | object | `{"devClusters":["us-east1-dev*","us-east2-dev*"],"prodClusters":["us-east1-prod*","us-east2-prod*"],"testClusters":["us-east1-test*","us-east2-test*"]}` | pre-defined cluster groups |
| x-labelSelectors | object | `{"prodLabels":[{"env":"prod"}]}` | labels to use when selecting production stuff |
| x-policiesAudit[0] | string | `"polaris.tagNotSpecified"` |  |
| x-policiesAudit[10] | string | `"polaris.hpaMinAvailability"` |  |
| x-policiesAudit[11] | string | `"polaris.hpaMaxAvailability"` |  |
| x-policiesAudit[12] | string | `"polaris.readinessProbeMissing"` |  |
| x-policiesAudit[13] | string | `"polaris.livenessProbeMissing"` |  |
| x-policiesAudit[14] | string | `"polaris.pullPolicyNotAlways"` |  |
| x-policiesAudit[15] | string | `"polaris.procMount"` |  |
| x-policiesAudit[16] | string | `"polaris.notReadOnlyRootFilesystem"` |  |
| x-policiesAudit[17] | string | `"polaris.missingPodDisruptionBudget"` |  |
| x-policiesAudit[18] | string | `"polaris.metadataAndInstanceMismatched"` |  |
| x-policiesAudit[19] | string | `"polaris.metadataAndNameMismatched"` |  |
| x-policiesAudit[1] | string | `"polaris.runAsPrivileged"` |  |
| x-policiesAudit[20] | string | `"polaris.memoryRequestsMissing"` |  |
| x-policiesAudit[21] | string | `"polaris.memoryLimitsMissing"` |  |
| x-policiesAudit[22] | string | `"polaris.cpuRequestsMissing"` |  |
| x-policiesAudit[23] | string | `"polaris.linuxHardening"` |  |
| x-policiesAudit[24] | string | `"polaris.hostPathSet"` |  |
| x-policiesAudit[25] | string | `"polaris.hostNetworkSet"` |  |
| x-policiesAudit[26] | string | `"polaris.hostProcess"` |  |
| x-policiesAudit[27] | string | `"polaris.hostPortSet"` |  |
| x-policiesAudit[28] | string | `"polaris.automountServiceAccountToken"` |  |
| x-policiesAudit[2] | string | `"polaris.runAsRootAllowed"` |  |
| x-policiesAudit[3] | string | `"polaris.privilegeEscalationAllowed"` |  |
| x-policiesAudit[4] | string | `"polaris.hostPIDSet"` |  |
| x-policiesAudit[5] | string | `"polaris.hostIPCSet"` |  |
| x-policiesAudit[6] | string | `"polaris.dangerousCapabilities"` |  |
| x-policiesAudit[7] | string | `"polaris.topologySpreadConstraint"` |  |
| x-policiesAudit[8] | string | `"polaris.pdbMinAvailableGreaterThanHPAMinReplicas"` |  |
| x-policiesAudit[9] | string | `"polaris.pdbDisruptionsIsZero"` |  |
| x-policiesBlocking | list | `["polaris.procMount"]` | blocking policies |

## Usage

You may want to change the `-o` to a different directory.

`helm template .  | kubectl slice -f - -o /tmp -t "{{ .name }}.yaml"`

This uses https://github.com/patrickdappollonio/kubectl-slice to split the files into separate outputs.

## Generating This Doc

This is generated from README.md.gotmpl using https://github.com/norwoodj/helm-docs
