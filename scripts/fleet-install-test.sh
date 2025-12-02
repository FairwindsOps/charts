#!/bin/sh

set -o errexit
set -o nounset
set -x

# Check whether insights-agent is part of the changed charts
cd /charts

# Workaround for partial clone + SSH authentication issues
# Convert SSH remote to HTTPS if needed to prevent promisor remote errors
PARTIAL_CLONE=$(git config --get remote.origin.partialclonefilter 2>&1 || echo "")
CURRENT_REMOTE=$(git remote get-url origin 2>&1)
if [ -n "$PARTIAL_CLONE" ] && echo "$CURRENT_REMOTE" | grep -q 'git@github.com:'; then
    NEW_REMOTE=$(echo "$CURRENT_REMOTE" | sed 's|git@github.com:\(.*\)|https://github.com/\1|')
    if git remote set-url origin "$NEW_REMOTE" 2>&1; then
        # Verify the conversion took effect
        git remote get-url origin 2>&1 | grep -q 'https://' || echo "Warning: Remote conversion may not have taken effect"
    fi
fi

# Capture ct list-changed output and check for errors
# Use a temporary file to capture stderr separately
TMP_STDERR=$(mktemp)
set +o errexit
CHANGED_OUTPUT=$(ct list-changed --config ./scripts/ct.yaml --print-config 2>"$TMP_STDERR")
CT_EXIT_CODE=$?
CT_STDERR=$(cat "$TMP_STDERR" 2>&1 || echo "")
rm -f "$TMP_STDERR"
set -o errexit

# Check for segfault or other errors
if [ $CT_EXIT_CODE -ne 0 ]; then
    echo "ERROR: ct list-changed failed with exit code $CT_EXIT_CODE"
    echo "STDOUT: $CHANGED_OUTPUT"
    echo "STDERR: $CT_STDERR"
    exit 1
fi

# Check if output contains error messages (even if exit code was 0)
if echo "$CHANGED_OUTPUT" | grep -qi "failed\|error\|segmentation\|core dumped"; then
    echo "ERROR: ct list-changed output contains error indicators"
    echo "Output: $CHANGED_OUTPUT"
    exit 1
fi

CHANGED="$CHANGED_OUTPUT"

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
