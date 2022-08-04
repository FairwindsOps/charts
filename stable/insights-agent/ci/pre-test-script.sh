#! /usr/bin/env sh
helm repo add jetstack https://charts.jetstack.io
helm repo update
kubectl create namespace cert-manager || echo "Namespace already exists"
helm get notes -n cert-manager cert-manager || helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --version v1.0.1 \
  --set installCRDs=true \
  --wait

# Fake secret to test pull secrets functionality
kubectl create secret fake-docker-registry regcred \
  --docker-server=fairwinds.com \
  --docker-username=johndoe \
  --docker-password=totallynotsecret \
  --docker-email=johndoe@fairwinds.com
