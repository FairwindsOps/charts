# v2.0.1 January 3, 2020
- bugfix for dnsNames selector failing if matching a wildcard with an asterisk (Helm YAML -> JSON error)

# v1.2.1 December 3, 2019
- Updating apiVersion for ClusterIssuer to `cert-manager.io/v1alpha2` from `certmanager.k8s.io/v1alpha1`
- Changed appVersion to 0.11.1 to match the intended corresponding cert-manager release
- Changed ci/pre-test-script.sh to match 0.11.1 installation procedure that shouldn't affect previous versions.
