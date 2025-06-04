#!/bin/sh

# This will label the first node that is returned by kubectl get nodes so that we can test
# the `topologySpreadConstraints` with `topologyKey: topology.kubernetes.io/zone`
FIRST_NODE="$(kubectl get nodes -o name | head -n 1)"
kubectl label "$FIRST_NODE" topology.kubernetes.io/zone=test-zone-a
