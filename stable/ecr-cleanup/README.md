# ECR Cleanup

Cleans up unused ECR images using [this](https://github.com/danielfm/kube-ecr-cleanup-controller)

## Config

| Parameter | Description | Default | Required |
| --------- | ----------- | ------- | -------- |
| `controller.dryRun` | Don't delete any images, just scan and log.  | `false` | yes |
| `controller.interval` | How frequently the scan runs.  | `60` | yes |
| `controller.maxImages` | Maximum number of images to keep in ECR.  | `900` | yes |
| `controller.namespaces` | Namespaces to check for running images. | `default` | yes |
| `controller.region` | Region that the ECR repo is in.  | `us-east-1` | yes |
| `controller.repos` | ECR repo names to delete from.  | `sudermanjr-test` | yes |
| `controller.registryID` | Account ID (registry ID) to use if it is not the default.  | `""` | no |
| `controller.verbosity` | Log verbosity.  | `1` | yes |
| `controller.keep_filters` | comma-separated list of filters or regexes that when matched will preserve the matching images. | | no |
| `fullnameOverride` |  | ` ` | no |
| `image.pullPolicy` | Leave this like this.  | `Always` | no |
| `image.repository` | Docker repo to use.  | `danielfm/kube-ecr-cleanup-controller` | no |
| `image.tag` | Image version  | `0.1.5` | no |
| `nameOverride` |  | ` ` | no |
| `nodeSelector` |  | `{}` | no |
| `rbac.create` | If `True`, create rbac resources for the controller.  | `True` | no |
| `replicaCount` | Should always be 1.  Why run multiple?  | `1` | no |
| `resources.limits.cpu` | CPU limit.  | `100m` | no |
| `resources.limits.memory` | Memory limit.  | `128Mi` | no |
| `resources.requests.cpu` | CPU request  | `100m` | no |
| `resources.requests.memory` | Memory request.  | `128Mi` | no |
| `tolerations` | Tolerations on controller pod.  | `[]` | no |
| `affinity` | Affinity on controller pod.  | `{}` | no |

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
