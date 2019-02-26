# ECR Cleanup

Cleans up unused ECR images using [this](https://github.com/danielfm/kube-ecr-cleanup-controller)

## Config

| Parameter | Description | Default | Required |
| --------- | ----------- | ------- | -------- |
| `controller.dryRun` |  | `false` | yes |
| `controller.interval` |  | `60` | yes |
| `controller.maxImages` |  | `900` | yes |
| `controller.namespaces` |  | `default` | yes |
| `controller.region` |  | `us-east-1` | yes |
| `controller.repos` |  | `sudermanjr-test` | yes |
| `controller.verbosity` |  | `1` | yes |
| `fullnameOverride` |  | ` ` | no |
| `image.pullPolicy` |  | `Always` | no |
| `image.repository` |  | `danielfm/kube-ecr-cleanup-controller` | no |
| `image.tag` |  | `0.1.3` | no |
| `nameOverride` |  | ` ` | no |
| `nodeSelector` |  | `{}` | no |
| `rbac.create` |  | `True` | no |
| `replicaCount` |  | `1` | no |
| `resources.limits.cpu` |  | `100m` | no |
| `resources.limits.memory` |  | `128Mi` | no |
| `resources.requests.cpu` |  | `100m` | no |
| `resources.requests.memory` |  | `128Mi` | no |
| `tolerations` |  | `[]` | no |
| `affinity` |  | `{}` | no |

## AWS Policy

The following IAM policy is needed for the controller to work.
```
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "${POLICYNAME}",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::${ACCOUNT_ID}:role/${ROLENAME}"
        ]
      },
      "Action": [
        "ecr:BatchDeleteImage",
        "ecr:BatchGetImage",
        "ecr:DescribeImages",
        "ecr:ListImages"
      ]
    }
  ]
}
```
