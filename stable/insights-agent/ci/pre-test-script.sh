#! /usr/bin/env sh
helm repo add jetstack https://charts.jetstack.io
helm repo update
kubectl create namespace cert-manager || echo "Namespace already exists"
helm get notes -n cert-manager cert-manager || helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --version v1.11.0 \
  --set installCRDs=true \
  --wait

kubectl delete jobs "kubectl get jobs -o custom-columns=:.metadata.name"