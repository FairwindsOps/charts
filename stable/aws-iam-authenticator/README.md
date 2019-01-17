# aws-iam-authenticator

Runs the AWS Iam Authenticator as a daemonset on master nodes in order to authenticate your users with AWS IAM.  This requires additional setup on your cluster to work.  See the [docs](https://github.com/kubernetes-sigs/aws-iam-authenticator) for more information.

## Configuration

### Configuration
Please change the values.yaml according to your setup

Parameter | Description | Default | Required
--- | --- | --- | ---
`configMap` | The configmap that the authenticator will use.  | see [values.yaml](values.yaml) | no
`volumes.output.mountPath` | Place to mount the host dir for output.  | `/etc/kubernetes/aws-iam-authenticator/` | yes
`volumes.output.hostPath` | Place on the host that the output files will live | `/srv/kubernetes/aws-iam-authenticator/` | yes
`volumes.state.mountPath` | Place to mount the host dir for state. | `/var/aws-iam-authenticator/` | yes
`volumes.state.hostPath` | Place on the host that the state lives. | `/srv/kubernetes/aws-iam-authenticator/` | yes
`config.mountPath` | Where to mount the config | `/etc/aws-iam-authenticator/` | yes
