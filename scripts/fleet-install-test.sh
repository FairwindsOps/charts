#!/bin/sh

set -o errexit
set -o nounset
set -x

# Check whether insights-agent is part of the changed charts
cd /charts

# Log diagnostic information before running ct list-changed
echo "================================================================================"
echo "DIAGNOSTIC INFORMATION - FLEET INSTALL TEST"
echo "================================================================================"
echo "Current directory: $(pwd)"
echo "User: $(whoami 2>&1 || echo 'N/A')"
echo "System info: $(uname -a 2>&1 || echo 'N/A')"
echo "Memory info:"
free -h 2>&1 || echo "  free command not available"
echo "Disk space:"
df -h . 2>&1 || echo "  df command failed"
echo ""
echo "Chart-testing version: $(ct version 2>&1 || echo 'ct version command failed')"
echo "Chart-testing binary location: $(command -v ct 2>&1 || echo 'ct not in PATH')"
CT_BINARY=$(command -v ct 2>&1 || echo '')
if [ -n "$CT_BINARY" ]; then
    echo "Chart-testing binary info: $(file "$CT_BINARY" 2>&1 || echo 'N/A')"
else
    echo "Chart-testing binary info: N/A (binary not found)"
fi
echo ""
echo "Git branch: $(git branch --show-current 2>&1 || echo 'N/A')"
echo "Git commit: $(git rev-parse HEAD 2>&1 || echo 'N/A')"
echo "Git remote origin URL: $(git remote get-url origin 2>&1 || echo 'N/A')"
echo "Git remotes:"
git remote -v 2>&1 || echo "  git remote failed"
echo "Git status:"
git status --short 2>&1 || echo "git status failed"
echo "Git log (last 3 commits):"
git log --oneline -3 2>&1 || echo "git log failed"
echo ""
echo "CT configuration (./scripts/ct.yaml):"
cat ./scripts/ct.yaml 2>&1 || echo "  Failed to read ct.yaml"
echo ""
echo "Target branch from ct.yaml: $(grep -E '^target-branch:' ./scripts/ct.yaml 2>&1 || echo 'N/A')"
echo "Chart directories: $(grep -E '^chart-dirs:' -A 10 ./scripts/ct.yaml 2>&1 | grep -E '^\s+-' || echo 'N/A')"
echo ""
echo "Checking git diff capability (this is what ct uses internally):"
echo "  - Testing git diff against target branch:"
TARGET_BRANCH=$(grep -E '^target-branch:' ./scripts/ct.yaml | sed 's/^target-branch: *//' || echo "master")
echo "    Target branch: $TARGET_BRANCH"
git fetch origin "$TARGET_BRANCH" 2>&1 | head -5 || echo "    git fetch failed"
git diff --name-only "origin/$TARGET_BRANCH" 2>&1 | head -20 || echo "    git diff failed"
echo "================================================================================"
echo "Running ct list-changed command..."
echo "Command: ct list-changed --config ./scripts/ct.yaml --print-config"
echo "================================================================================"

# Capture both stdout and stderr separately
CHANGED_OUTPUT=""
CHANGED_ERROR=""
set +o errexit  # Temporarily disable errexit to capture the error
CHANGED_OUTPUT=$(ct list-changed --config ./scripts/ct.yaml --print-config 2> /tmp/ct-list-changed-fleet.stderr)
CT_EXIT_CODE=$?
CHANGED_ERROR=$(cat /tmp/ct-list-changed-fleet.stderr 2>&1 || echo "")
set -o errexit  # Re-enable errexit

echo "================================================================================"
echo "CT LIST-CHANGED OUTPUT (stdout):"
echo "================================================================================"
echo "$CHANGED_OUTPUT"
echo "================================================================================"
echo "CT LIST-CHANGED ERROR OUTPUT (stderr):"
echo "================================================================================"
echo "$CHANGED_ERROR"
echo "================================================================================"
echo "CT LIST-CHANGED EXIT CODE: $CT_EXIT_CODE"
echo "================================================================================"

# Check if the command failed
if [ $CT_EXIT_CODE -ne 0 ]; then
    echo "ERROR: ct list-changed failed with exit code $CT_EXIT_CODE"
    echo "This may indicate a segmentation fault or other critical error."
    echo ""
    echo "Additional debugging information:"
    echo "  - Checking if target branch exists:"
    TARGET_BRANCH=$(grep -E '^target-branch:' ./scripts/ct.yaml | sed 's/^target-branch: *//' || echo "master")
    echo "    Target branch: $TARGET_BRANCH"
    git ls-remote --heads origin "$TARGET_BRANCH" 2>&1 || echo "    Could not find target branch in remote"
    echo ""
    echo "  - Checking git diff capability:"
    git diff --name-only HEAD~1 2>&1 | head -20 || echo "    git diff failed"
    echo ""
    echo "  - Checking for large files that might cause issues:"
    find . -type f -size +10M -not -path './.git/*' 2>&1 | head -10 || echo "    No large files found"
    echo ""
    echo "  - Checking for binary files in chart directories:"
    find stable incubator -type f -exec file {} \; 2>&1 | grep -E "(binary|executable)" | head -10 || echo "    No obvious binary files found"
    echo ""
    echo "  - Checking git repository size:"
    du -sh .git 2>&1 || echo "    Could not check .git size"
    echo ""
    echo "  - Checking for corrupted git objects:"
    git fsck --no-full 2>&1 | head -20 || echo "    git fsck failed or found no issues"
    exit 1
fi

# Check if output contains error messages
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
