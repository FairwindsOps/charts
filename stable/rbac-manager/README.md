# RBAC Manager

[RBAC Manager](https://fairwindsops.github.io/rbac-manager/) was designed to simplify authorization in Kubernetes. This is an operator that supports declarative configuration for RBAC with new custom resources. Instead of managing role bindings or service accounts directly, you can specify a desired state and RBAC Manager will make the necessary changes to achieve that state.

This project has three main goals:

1. Provide a declarative approach to RBAC that is more approachable and scalable.
2. Reduce the amount of configuration required for great auth.
3. Enable automation of RBAC configuration updates with CI/CD.

More information about RBAC Manager is available on [GitHub](https://github.com/FairwindsOps/rbac-manager) as well as from the [official documentation](https://fairwindsops.github.io/rbac-manager/).

## Installation

We recommend installing rbac-manager in its own namespace and a simple release name:

```
helm repo add fairwinds-stable https://charts.fairwinds.com/stable
helm install rbac-manager fairwinds-stable/rbac-manager --namespace rbac-manager
```

## Prerequisites

Kubernetes 1.8+, Helm 2.10+

## Configuration

| Parameter                   | Description                                 | Default                            |
| --------------------------- | --------------------------------------------| ---------------------------------- |
| `image.repository`          | Docker image repo                           | `quay.io/reactiveops/rbac-manager` |
| `image.tag`                 | Docker image tag                            | `0.7.0`                            |
| `image.pullPolicy`          | Docker image pull policy                    | `Always`                           |
| `image.imagePullSecrets`    | Docker registry credentials                 | `[]`                               |
| `resources.requests.cpu`    | CPU resource request                        | `100m`                             |
| `resources.requests.memory` | Memory resource request                     | `128Mi`                            |
| `resources.limits.cpu`      | CPU resource limit                          | `100m`                             |
| `resources.limits.memory`   | Memory resource limit                       | `128Mi`                            |
| `nodeSelector`              | Deployment nodeSelector                     | `{}`                               |
| `tolerations`               | Deployment tolerations                      | `[]`                               |
| `affinity`                  | Deployment affinity                         | `{}`                               |
| `priorityClassName`         | Priority Class of the pod                   | `""`                               |
| `podAnnotations`            | Annotations to add to the Deployment's pods | `{}`            |
| `podLabels`                 | Labels to add to the Deployment's pods      | `{}`                 |

## Upgrading to Chart Version 1.0.0

The upgrade to version 1.0.0 of this chart removes support for installing RBAC Definitions as part of the chart values. This change was made to simplify CRD installation with Helm. We recommend installing RBAC Definitions separately from the chart.

For backwards compatibility with the chart originally included in the rbac-manager repository, we've removed the Helm `install-crd` hook from this chart. Unfortunately as part of improving backwards compatibility with the chart in the rbac-manager repository, we have made it more difficult to upgrade from the inital versions of the charts here.

Some quirks in Helm make the upgrade process from 0.x of this chart to 1.x challenging due to the potential of the RBAC Definition CRD getting deleted. In most cases, reinstalling the chart will be the best path forward.

If either of the following apply and you are upgrading from an earlier version of the chart found in this repository, keep on reading:

1. A momentary lapse in access granted by RBAC Definitions is unacceptable
2. You're using auth tokens from Service Accounts created by RBAC Manager

The following process has worked repeatedly for us to upgrade from an older version of this chart to 1.0.0. These steps worked with Helm and Tiller 2.12.3 for us, but due to the absurdity of this process, we can't guarantee it will work for you.

1. Install rbac-manager with chart that uses install-crd hook (fairwinds-stable/rbac-manager@0.2.1)
2. Upgrade to rbac-manager chart that doesn't use install-crd hook (fairwinds-stable/rbac-manager@1.0.0) - this upgrade fails but is important later
3. Upgrade to original rbac-manager chart that uses install-crd hook (fairwinds-stable/rbac-manager@0.2.1) - this works
4. Rollback to revision 2 - this fails
5. Rollback to revision 2 - this works

In the above workflow, an RBAC Definition installed between revision 1 and 2 should persist through to revision 5. This process is admittedly quite strange, and in our testing the second rollback (step 5) is indeed required for this process to work.
