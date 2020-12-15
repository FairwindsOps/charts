#! /usr/bin/env sh
helm repo add jetstack https://charts.jetstack.io
helm repo update
kubectl create namespace cert-manager && helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --version v1.0.1 \
  --set installCRDs=true \
  --wait
