#!/bin/sh

# This will label the first ndoe that is returned by kubectl get nodes so that we can test
# the topologySpreadConstraints with `topologyKey: topology.kubernetes.io/zone`
kubectl label $(kubectl get nodes -o name | head -n 1) topology.kubernetes.io/zone=test-zone-a
