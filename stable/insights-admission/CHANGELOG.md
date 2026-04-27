# Changelog

## 1.12.3
* Pinned CI test image to `python:3.14.4-alpine3.23` (latest `library/python` patch + Alpine variant on Docker Hub)

## 1.12.2
* Bumped CI test image default to `python:3.13-alpine`

## 1.12.1
* Bumped CI test image default from `python:3.10-alpine` to `python:3.12-alpine`

## 1.12.0
* Set explicit `spec.privateKey.rotationPolicy` on the cert-manager Certificate for cert-manager v1.18.0+ compatibility (configurable via `privateKeyRotationPolicy`).

## 1.11.2
* Bumped admission

## 1.11.1
* Bumped admission

## 1.11.0
* remove support to OPA v1

## 1.10.2
* Add GKE instructions

## 1.10.1
* Add support to polaris config

## 1.10.0
* Bump insights-admission to version 1.18

## 1.9.4
* Bump insights-admission to version 1.17

## 1.9.3
* Bump insights-admission to version 1.16

## 1.9.2
* Bump insights-admission to version 1.15

## 1.9.1
* Bump insights-admission to version 1.14

## 1.9.0
* Bump insights-admission to version 1.13

## 1.8.4
* Start testing on 1.26 and 1.27

## 1.8.3
* Set kubeVersion in chart manifest

## 1.8.2
* Fix cert duration to not trigger ArgoCD out-of-sync

## 1.8.1
* Add explicit default cert duration.
## 1.8.0
* Bump insights-admission to version 1.11
* See [changelog](https://github.com/FairwindsOps/insights-plugins/blob/main/plugins/admission/CHANGELOG.md) for details on new polaris checks and severities, which may block deployments

## 1.7.0
* Bump insights-admission to version 1.10

## 1.6.4
* Fix HPA metric definition for autoscaling/v2

## 1.6.3
* Patch bump for updating chart CI

## 1.6.2
* Update HPA apiVersion to autoscaling/v2

## 1.6.1
* Add an apiVersion override for cert-manager apiVersions

## 1.6.0
* Add the ability to use a custom SSL certificate to validate communication with a self-hosted Insights API.

## 1.5.2
* Add default topologySpreadConstraints

## 1.5.1
* Update testing versions

## 1.5.0
* Bump insights-admission to version 1.9

## 1.4.3
* Add a MutatingWebhookConfiguration resource, enabled via the `webhookConfig.mutating.enable` chart value.

## 1.4.2
* Add CHANGELOG

## 1.4.1
* Add support for ignoring some service accounts, including `system:addon-manager` by default.
