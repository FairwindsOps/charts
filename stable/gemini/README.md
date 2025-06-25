<div align="center">
<a href="https://github.com/FairwindsOps/gemini"><img src="logo.png" height="150" alt="Gemini" style="padding-bottom: 20px" /></a>
<br>
</div>

## Intro

This is a Helm chart for the Fairwinds
[Gemini project](https://github.com/FairwindsOps/gemini).
It provides a Kubernetes CRD and operator for managing `VolumeSnapshots`, allowing you
to back up your `PersistentVolumes` on a regular schedule, retire old backups, and restore
backups with minimal downtime.

See the [Gemini README](https://github.com/FairwindsOps/gemini) for more information.

## Installation
```bash
helm repo add fairwinds-stable https://charts.fairwinds.com/stable
helm install gemini fairwinds-stable/gemini --namespace gemini --create-namespace
```
## Requirements

Your cluster must support the [VolumeSnapshot API](https://kubernetes.io/docs/concepts/storage/volume-snapshots/)

## Upgrading to V2
Version 2.0 of Gemini updates the CRD from `v1beta1` to `v1`. There are no substantial
changes, but `v1` adds better support for PersistentVolumeClaims on Kubernetes 1.25.

If you want to keep the v1beta1 CRD available, you can run:
```
kubectl apply -f https://raw.githubusercontent.com/FairwindsOps/gemini/main/pkg/types/snapshotgroup/v1beta1/crd-with-beta1.yaml
```
before upgrading, and add `--skip-crds` when running `helm install`.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| image.pullPolicy | string | `"Always"` | imagePullPolicy - Highly recommended to leave this as `Always` |
| image.repository | string | `"quay.io/fairwinds/gemini"` | Repository for the gemini image |
| image.tag | string | `nil` | The gemini image tag to use. Defaults to .Chart.appVersion |
| rbac.create | bool | `true` | If true, create a new ServiceAccount and attach permissions |
| rbac.serviceAccountName | string | `nil` |  |
| verbosity | int | `5` | How verbose the controller logs should be |
| resources | object | `{"limits":{"cpu":"200m","memory":"512Mi"},"requests":{"cpu":"25m","memory":"64Mi"}}` | The resources block for the controller pods |
| tolerations | list | `[]` | Taint tolerations for nodes |
| nodeSelector | object | `{}` | Select nodes to deploy which matches the following labels |
| affinity | object | `{}` | Pod affinity and pod anti-affinity allow you to specify rules about how pods should be placed relative to other pods. |
| additionalPodLabels | object | `{}` | Additional labels added on pod |
| additionalPodAnnotations | object | `{}` | Additional annotations added on pod |
| extraManifests | list | `[]` | A list of extra manifests to be installed with this chart. This is useful for installing additional resources that are not part of the chart |
