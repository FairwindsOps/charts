#!/bin/sh

set -o errexit
set -o nounset
set -x

# Check whether insights-agent is part of the changed charts
cd /charts

# Helper function to get changed charts using git directly (fallback when ct fails)
get_changed_charts_git() {
  TARGET_BRANCH="${1:-origin/master}"
  CHART_DIRS="${2:-stable incubator}"
  
  # Get merge base
  MERGE_BASE=$(git merge-base "$TARGET_BRANCH" HEAD 2>/dev/null || echo "")
  if [ -z "$MERGE_BASE" ]; then
    return 1
  fi
  
  # Get changed files in chart directories
  # Compare MERGE_BASE to HEAD (not working directory)
  # Note: CHART_DIRS is intentionally unquoted to allow word splitting for git diff
  # shellcheck disable=SC2086
  CHANGED_FILES=$(git diff --find-renames --name-only "$MERGE_BASE" HEAD -- $CHART_DIRS 2>/dev/null || echo "")
  
  if [ -z "$CHANGED_FILES" ]; then
    # Return empty string (not exit code 0) to indicate no changes
    return 0
  fi
  
  # Extract unique chart directories
  # Output the chart directories, one per line (matching ct list-changed format)
  printf "%s\n" "$CHANGED_FILES" | \
    grep -E "^($(echo "$CHART_DIRS" | tr ' ' '|'))/[^/]+/" | \
    sed -E 's|^([^/]+/[^/]+)/.*|\1|' | \
    sort -u | \
    tr '\n' ' ' | \
    sed 's/[[:space:]]*$//'
}

# Capture both stdout and stderr, temporarily disable errexit to handle failures gracefully
# Note: Explicitly specifying --target-branch may help avoid segmentation faults
set +o errexit
CHANGED="$(ct list-changed --config ./scripts/ct.yaml --target-branch master 2>&1)"
CT_EXIT_CODE=$?
set -o errexit

# Check if ct list-changed failed
if [ $CT_EXIT_CODE -ne 0 ] || echo "$CHANGED" | grep -qE "(Error|error|failed|segmentation|fault)"; then
  printf "Warning: ct list-changed failed. Using git-based fallback...\n"
  CHANGED="$(get_changed_charts_git origin/master "stable incubator")"
  GIT_FALLBACK_EXIT=$?
  
  if [ $GIT_FALLBACK_EXIT -ne 0 ] || [ -z "$CHANGED" ]; then
    printf "No changed charts detected. Skipping fleet install test.\n"
    exit 0
  fi
  
  printf "Changed charts detected via git: %s\n" "$CHANGED"
fi

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
