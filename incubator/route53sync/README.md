# Chart - route53sync

This chart will sync two route53 zones.  Helpful if you have multiple internal zones you need to sync.

## Configuration

The following table lists the configurable parameters of the route53sync chart and their default values.

| Parameter | Description | Default | Required |
| --------- | ----------- | ------- | -------- |
| `image.repository` | Image repository | `python` | no |
| `image.tag` | Image tag | `3.7-alpine` | no |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` | no |
| `sync.schedule` | The cron schedule to run the sync on. | `"*/30 * * * *"` | no |
| `sync.suspend` | Whether or not to suspend the cron | `'false'` | no |
| `sync.logLevel` | Logging level of the script | `'INFO'` | no |
| `sync.source_zone_id` | The Route53 Zone ID of the source | `''` | yes |
| `sync.dest_zone_id` | The Route53 Zone ID of the destination | `''` | yes |
| `sync.check_dest_tag` | Whether or not the script should verify a tag on the destination zone. | `"False"` | no |
| `sync.dest_tag` | If sync.check_dest_tag is True, this tag will be required on the destination zone in order to run the sync. | `"Author:Fairwinds"` | no |
