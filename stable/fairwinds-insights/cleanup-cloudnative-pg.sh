#!/bin/bash

set -e

echo "Cleaning up existing CloudNativePG resources that might conflict..."

# Check and list existing CloudNativePG resources
echo "Checking for existing CloudNativePG resources..."

# List and delete specific webhook configurations that conflict
if kubectl get MutatingWebhookConfiguration cnpg-mutating-webhook-configuration 2>/dev/null; then
    echo "Found existing cnpg-mutating-webhook-configuration, deleting..."
    kubectl delete MutatingWebhookConfiguration cnpg-mutating-webhook-configuration --ignore-not-found=true
else
    echo "No existing cnpg-mutating-webhook-configuration found"
fi

if kubectl get ValidatingWebhookConfiguration cnpg-validating-webhook-configuration 2>/dev/null; then
    echo "Found existing cnpg-validating-webhook-configuration, deleting..."
    kubectl delete ValidatingWebhookConfiguration cnpg-validating-webhook-configuration --ignore-not-found=true
else
    echo "No existing cnpg-validating-webhook-configuration found"
fi

# List existing CloudNativePG CRDs
echo "Checking for existing CloudNativePG CRDs..."
for crd in clusters.postgresql.cnpg.io backups.postgresql.cnpg.io scheduledbackups.postgresql.cnpg.io poolers.postgresql.cnpg.io; do
    if kubectl get crd $crd 2>/dev/null; then
        echo "Found existing CRD: $crd"
        # Check if there are any resources using this CRD
        if kubectl get $crd --all-namespaces 2>/dev/null | grep -v "No resources found" > /dev/null; then
            echo "WARNING: CRD $crd has existing resources. Listing them:"
            kubectl get $crd --all-namespaces
            echo "Skipping deletion of CRD $crd to avoid data loss"
        else
            echo "CRD $crd has no resources, deleting..."
            kubectl delete crd $crd --ignore-not-found=true
        fi
    else
        echo "No existing CRD: $crd"
    fi
done

echo "Cleanup completed successfully"
echo ""