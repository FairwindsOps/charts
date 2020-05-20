# Changelog

All notable changes to this Helm chart will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this chart adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## 1.0.0
Updated to Polaris 1.0.

In addition to changes needed for Polaris 1.0, there are some chart changes:
* RBAC has been simplified to remove duplication
* `config` now uses the built-in Polaris config by default
* `ingress` is now attached to the dashboard values
* only a single `image` is specified for the entire chart

## 0.6.0

### Fixed

* The validating webhook pod no longer crashes when using  a Helm release name other than _polaris_ ([Polaris issue #211](https://github.com/FairwindsOps/polaris/issues/211)) Note that upgrading the Helm release will return the error:

   ```
   UPGRADE FAILED
   Error: kind Secret with the name "polaris-webhook" already exists in the cluster and wasn't defined in the previous release. Before upgrading, please either delete the resource from the cluster or remove it from the chart
   ```
Delete the _polaris-webhook_ secret from the namespace where Polaris is installed, and the Helm upgrade will succeed. When the Polaris webhook pod restarts it will populate the _polaris-webhook_ secret.
* The Polaris dashboard and webhook pods now restart when the ConfigMap has been changed.

### Changed

* The Secret used by the Polaris webhook is now named _polaris-webhook_ instead of using the Helm release name. This has been done to match the static secret name that the Polaris webhook pod populates.

### Added

* This changelog has been added to help track updates to this Helm chart.
