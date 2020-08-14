# gemini

![Version: 0.0.1](https://img.shields.io/badge/Version-0.0.1-informational?style=flat-square) ![AppVersion: 0.0.1](https://img.shields.io/badge/AppVersion-0.0.1-informational?style=flat-square)

Automated backup and restore of PersistentVolumes using the  VolumeSnapshot API

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| rbren | robertb@fairwinds.com |  |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| image.repository | string | `"quay.io/fairwinds/gemini"` |  |
| image.tag | string | `"build_134"` |  |
| resources.limits.cpu | string | `"200m"` |  |
| resources.limits.memory | string | `"512Mi"` |  |
| resources.requests.cpu | string | `"100m"` |  |
| resources.requests.memory | string | `"128Mi"` |  |
