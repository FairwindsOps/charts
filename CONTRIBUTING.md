# Contributing

## Guidelines on Contributing

* Lint your changes:
  * `docker run --rm -it -v ${PWD}:/charts -w /charts quay.io/helmpack/chart-testing:v2.4.0 ct lint --chart-yaml-schema scripts/schema.yaml --chart-dirs incubator --chart-dirs stable`
* End-to-end test your changes:
  * Install [kind 0.7.0+](https://github.com/kubernetes-sigs/kind/releases)
  * Install [chart-testing (ct)](https://github.com/helm/chart-testing/releases)
  * `scripts/e2e-test.sh setup` to set up Kubernetes in Docker
  * `scripts/e2e-test.sh test` to test your local changes until they pass
  * `scripts/e2e-test.sh teardown` when you are done testing to delete your cluster
* Submit a PR
* Follow the [Chart Guidelines](#Chart Guidelines)
* Make sure your chart passes a `helm lint`

## Pre-commit

There is a `.pre-commit-config.yaml` in this repo. If you use [pre-commit](https://pre-commit.com/), then you can just run `pre-commit install` to automatically run the linter on modified charts.

## Chart Guidelines

### Immutability

Chart releases must be immutable. Any change to a chart warrants a chart version bump even if it is only changes to the documentation.

### Chart Metadata

The `Chart.yaml` should be as complete as possible. The following fields are mandatory:

* name (same as chart's directory)
* home
* version
* appVersion
* description
* maintainers (name should be Github username)

### Dependencies

Stable charts should not depend on charts in incubator.

### Names and Labels

#### Metadata
Resources and labels should follow some conventions. The standard resource metadata (`metadata.labels` and `spec.template.metadata.labels`) should be this:

```yaml
name: {{ include "myapp.fullname" . }}
labels:
  app.kubernetes.io/name: {{ include "myapp.name" . }}
  app.kubernetes.io/instance: {{ .Release.Name }}
  app.kubernetes.io/managed-by: {{ .Release.Service }}
  helm.sh/chart: {{ include "myapp.chart" . }}
```

If a chart has multiple components, a `app.kubernetes.io/component` label should be added (e. g. `app.kubernetes.io/component: server`). The resource name should get the component as suffix (e. g. `name: {{ include "myapp.fullname" . }}-server`).

Note that templates have to be namespaced. With Helm 2.7+, `helm create` does this out-of-the-box. The `app.kubernetes.io/name` label should use the `name` template, not `fullname` as is still the case with older charts.

#### Deployments, StatefulSets, DaemonSets Selectors

`spec.selector.matchLabels` must be specified should follow some conventions. The standard selector should be this:

```yaml
selector:
  matchLabels:
    app.kubernetes.io/name: {{ include "myapp.name" . }}
    app.kubernetes.io/instance: {{ .Release.Name }}
```

If a chart has multiple components, a `component` label should be added to the selector (see above).

`spec.selector.matchLabels` defined in `Deployments`/`StatefulSets`/`DaemonSets` `>=v1/beta2` **must not** contain `helm.sh/chart` label or any label containing a version of the chart, because the selector is immutable.
The chart label string contains the version, so if it is specified, whenever the the Chart.yaml version changes, Helm's attempt to change this immutable field would cause the upgrade to fail.

##### Fixing Selectors

###### For Deployments, StatefulSets, DaemonSets apps/v1beta1 or extensions/v1beta1

- If it does not specify `spec.selector.matchLabels`, set it
- Remove `helm.sh/chart` label in `spec.selector.matchLabels` if it exists
- Bump patch version of the Chart

###### For Deployments, StatefulSets, DaemonSets >=apps/v1beta2

- Remove `helm.sh/chart` label in `spec.selector.matchLabels` if it exists
- Bump major version of the Chart as it is a breaking change

#### Service Selectors

Label selectors for services must have both `app.kubernetes.io/name` and `app.kubernetes.io/instance` labels.

```yaml
selector:
  app.kubernetes.io/name: {{ include "myapp.name" . }}
  app.kubernetes.io/instance: {{ .Release.Name }}
```

If a chart has multiple components, a `app.kubernetes.io/component` label should be added to the selector (see above).

#### Persistence Labels

##### StatefulSet

In case of a `Statefulset`, `spec.volumeClaimTemplates.metadata.labels` must have both `app.kubernetes.io/name` and `app.kubernetes.io/instance` labels, and **must not** contain `helm.sh/chart` label or any label containing a version of the chart, because `spec.volumeClaimTemplates` is immutable.

```yaml
labels:
  app.kubernetes.io/name: {{ include "myapp.name" . }}
  app.kubernetes.io/instance: {{ .Release.Name }}
```

If a chart has multiple components, a `app.kubernetes.io/component` label should be added to the selector (see above).

##### PersistentVolumeClaim

In case of a `PersistentVolumeClaim`, unless special needs, `matchLabels` should not be specified
because it would prevent automatic `PersistentVolume` provisioning.

### Formatting

* Yaml file should be indented with two spaces.
* List indentation style should be consistent.
* There should be a single space after `{{` and before `}}`.

### Configuration

* Docker images should be configurable. Image tags should use stable versions.

```yaml
image:
  repository: myapp
  tag: 1.2.3
  pullPolicy: IfNotPresent
```

* The use of the `default` function should be avoided if possible in favor of defaults in `values.yaml`.
* It is usually best to not specify defaults for resources and to just provide sensible values that are commented out as a recommendation, especially when resources are rather high. This makes it easier to test charts on small clusters or Minikube. Setting resources should generally be a conscious choice of the user.

### Persistence

* Persistence should be enabled by default
* PVCs should support specifying an existing claim
* Storage class should be empty by default so that the default storage class is used
* All options should be shown in README.md
* Example persistence section in values.yaml:

```yaml
persistence:
  enabled: true
  ## If defined, storageClassName: <storageClass>
  ## If set to "-", storageClassName: "", which disables dynamic provisioning
  ## If undefined (the default) or set to null, no storageClassName spec is
  ##   set, choosing the default provisioner.  (gp2 on AWS, standard on
  ##   GKE, AWS & OpenStack)
  ##
  storageClass: ""
  accessMode: ReadWriteOnce
  size: 10Gi
  # existingClaim: ""
```

* Example pod spec within a deployment:

```yaml
volumes:
  - name: data
  {{- if .Values.persistence.enabled }}
    persistentVolumeClaim:
      claimName: {{ .Values.persistence.existingClaim | default (include "myapp.fullname" .) }}
  {{- else }}
    emptyDir: {}
  {{- end -}}
```

* Example pvc.yaml:

```yaml
{{- if and .Values.persistence.enabled (not .Values.persistence.existingClaim) }}
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: {{ include "myapp.fullname" . }}
  labels:
    app.kubernetes.io/name: {{ include "myapp.name" . }}
    app.kubernetes.io/instance: {{ .Release.Name }}
    app.kubernetes.io/managed-by: {{ .Release.Service }}
    helm.sh/chart: {{ include "myapp.chart" . }}
spec:
  accessModes:
    - {{ .Values.persistence.accessMode | quote }}
  resources:
    requests:
      storage: {{ .Values.persistence.size | quote }}
{{- if .Values.persistence.storageClass }}
{{- if (eq "-" .Values.persistence.storageClass) }}
  storageClassName: ""
{{- else }}
  storageClassName: "{{ .Values.persistence.storageClass }}"
{{- end }}
{{- end }}
{{- end }}
```

### AutoScaling / HorizontalPodAutoscaler

* Autoscaling should be disabled by default
* All options should be shown in README.md

* Example autoscaling section in values.yaml:

```yaml
autoscaling:
  enabled: false
  minReplicas: 1
  maxReplicas: 5
  targetCPUUtilizationPercentage: 50
  targetMemoryUtilizationPercentage: 50
```

* Example hpa.yaml:

```yaml
{{- if .Values.autoscaling.enabled }}
apiVersion: autoscaling/v2beta1
kind: HorizontalPodAutoscaler
metadata:
  name: {{ include "myapp.fullname" . }}
  labels:
    app.kubernetes.io/name: {{ include "myapp.name" . }}
    app.kubernetes.io/instance: {{ .Release.Name }}
    app.kubernetes.io/managed-by: {{ .Release.Service }}
    helm.sh/chart: {{ include "myapp.chart" . }}
    app.kubernetes.io/component: "{{ .Values.name }}"
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: {{ include "myapp.fullname" . }}
  minReplicas: {{ .Values.autoscaling.minReplicas }}
  maxReplicas: {{ .Values.autoscaling.maxReplicas }}
  metrics:
    - type: Resource
      resource:
        name: cpu
        targetAverageUtilization: {{ .Values.autoscaling.targetCPUUtilizationPercentage }}
    - type: Resource
      resource:
        name: memory
        targetAverageUtilization: {{ .Values.autoscaling.targetMemoryUtilizationPercentage }}
{{- end }}
```

### Ingress

* See the [Ingress resource documentation](https://kubernetes.io/docs/concepts/services-networking/ingress/) for a broader concept overview
* Ingress should be disabled by default
* Example ingress section in values.yaml:

```yaml
ingress:
  enabled: false
  annotations: {}
    # kubernetes.io/ingress.class: nginx
    # kubernetes.io/tls-acme: "true"
  path: /
  hosts:
    - chart-example.test
  tls: []
  #  - secretName: chart-example-tls
  #    hosts:
  #      - chart-example.test
```

* Example ingress.yaml:

```yaml
{{- if .Values.ingress.enabled -}}
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: {{ include "myapp.fullname" }}
  labels:
    app.kubernetes.io/name: {{ include "myapp.name" . }}
    app.kubernetes.io/instance: {{ .Release.Name }}
    app.kubernetes.io/managed-by: {{ .Release.Service }}
    helm.sh/chart: {{ include "myapp.chart" . }}
{{- with .Values.ingress.annotations }}
  annotations:
{{ toYaml . | indent 4 }}
{{- end }}
spec:
{{- if .Values.ingress.tls }}
  tls:
  {{- range .Values.ingress.tls }}
    - hosts:
      {{- range .hosts }}
        - {{ . | quote }}
      {{- end }}
      secretName: {{ .secretName }}
  {{- end }}
{{- end }}
  rules:
  {{- range .Values.ingress.hosts }}
    - host: {{ . | quote }}
      http:
        paths:
          - path: {{ .Values.ingress.path }}
            backend:
              serviceName: {{ include "myapp.fullname" }}
              servicePort: http
  {{- end }}
{{- end }}
```

* Example prepend logic for getting an application URL in NOTES.txt:

```
{{- if .Values.ingress.enabled }}
{{- range .Values.ingress.hosts }}
  http{{ if $.Values.ingress.tls }}s{{ end }}://{{ . }}{{ $.Values.ingress.path }}
{{- end }}
```

### Documentation

`README.md` and `NOTES.txt` are mandatory. `README.md` should contain a table listing all configuration options. `NOTES.txt` should provide accurate and useful information how the chart can be used/accessed.

### helm-docs
If you would like to use
[helm-docs](https://github.com/norwoodj/helm-docs)
to autogenerate your README.md, you'll need to do the following:

* In `values.yaml`, add comments with descriptions
* Add a `README.md.gotmpl`
* Install helm-docs (`brew install norwoodj/tap/helm-docs`)
* Run `helm-docs` in your chart's directory

See the Goldilocks chart for a good example.

If you'd like to manage your README manually, add your chart to the `.helmdocsignore` file.

### Stable Criteria

These are the criteria for a chart to be considered for stable. This list is not definitive, but it is intended to provide a guideline. As always, the final decision to move is up to the CODEOWNERS.

* README.md - preferably generated using helm-docs
* NOTES.txt that provides helpful tips to the end-user
* CODEOWNERS must be defined, and maintainers must be listed in the chart
* Resource requests and limits are set with recommendations
* Must pass CI
* Must be a Fairwinds product, or a tool that we use on a regular basis

### CODEOWNERS

Please create a github-style CODEOWNERS file in your chart folder and add your name to it.  This will ensure that you are asked to review PRs that involve your chart.
