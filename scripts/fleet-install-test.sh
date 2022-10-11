#!/bin/sh

set -o errexit
set -o nounset
set -x

# Check whether insights-agent is part of the changed charts
cd /charts
CHANGED="$(ct list-changed --config ./scripts/ct.yaml)"

case "$CHANGED" in 
  *insights-agent*)
    printf "The changed charts include insights-agent. Running fleet install test\n"

    # We use the be-main server to do the test. This is not ideal but will suffice for now
    # Here we check to make sure that the server is up
    URL="https://be-main.k8s.insights.fairwinds.com" 
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
