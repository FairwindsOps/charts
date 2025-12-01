#!/bin/sh

set -o errexit
set -o nounset
set -x

# Check whether insights-agent is part of the changed charts
cd /charts

# Try ct first, fall back to git if it fails
set +o errexit
CHANGED="$(ct list-changed --config ./scripts/ct.yaml --target-branch master 2>&1)"
CT_EXIT=$?
set -o errexit

if [ $CT_EXIT -ne 0 ] || echo "$CHANGED" | grep -qE "(Error|error|failed|segmentation|fault)"; then
  # Fallback to git-based detection
  MERGE_BASE=$(git merge-base origin/master HEAD 2>/dev/null || echo "")
  if [ -n "$MERGE_BASE" ]; then
    CHANGED_FILES=$(git diff --find-renames --name-only "$MERGE_BASE" HEAD -- stable incubator 2>/dev/null || echo "")
    if [ -n "$CHANGED_FILES" ]; then
      CHANGED=$(echo "$CHANGED_FILES" | grep -E "^(stable|incubator)/[^/]+/" | sed -E 's|^([^/]+/[^/]+)/.*|\1|' | sort -u | tr '\n' ' ' | sed 's/[[:space:]]*$//')
    fi
  fi
fi

# Filter out any config output, keep only chart paths
CHANGED=$(echo "$CHANGED" | grep -E "^(stable|incubator)/[^/]+$" | tr '\n' ' ' | sed 's/[[:space:]]*$//')

case "$CHANGED" in 
  *insights-agent*)
    printf "The changed charts include insights-agent. Running fleet install test\n"

    # We use the stable-main server to do the test. This is a server that gets deployed once every night
    # Here we check to make sure that the server is up
    URL="https://stable-main.k8s.insights.fairwinds.com" 
    retry=0
    while ! curl -k --no-progress-meter $URL; do
      printf "Server is not up yet. Waiting for it to start...\n";
      sleep 20

      retry=$(( retry + 1 ))
      if [ $retry -gt 30 ]; then
        printf "Unable to curl the server. Giving up on it.\n"
        exit 1
      fi
    done

    # Install insights-agent using the fleet install method
    random_number=$(shuf -i 0-500 -n1)
    cluster_name="test-fleet-$random_number"
    printf "\nServer is up. Running Fleet install for cluster %s\n" "$cluster_name"
    
    helm dependency build ./stable/insights-agent
    retry=0
    while ! helm upgrade --install insights-agent ./stable/insights-agent -f ./stable/insights-agent/ci/fleet-install-test.yaml \
      --namespace insights-agent \
      --create-namespace \
      --set insights.cluster="$cluster_name"; do
        random_number=$(shuf -i 15-60 -n1)
        printf "Helm installation of Insights using the fleet install method failed, will retry in %d seconds...\n" "${random_number}";
        sleep "${random_number}"
        retry=$(( retry + 1 ))
        if [ $retry -gt 1 ]; then
          printf "Unable to install Insights using the fleet install method after %d attempts. Giving up on it.\n" "${retry}"
          exit 1
        fi
    done

    kubectl wait --for=condition=complete job/fleet-installer --timeout=120s --namespace insights-agent
    kubectl wait --for=condition=complete job/polaris --timeout=120s --namespace insights-agent
    kubectl wait --for=condition=complete job/workloads --timeout=120s --namespace insights-agent
    ;;
esac
