#! /bin/bash
# Scans all container images referenced by the stable/fairwinds-insights Helm chart
# (including subcharts: temporal, timescale) and chart-defined images (e.g. RustFS) for CRITICAL/HIGH vulnerabilities using Trivy.
#
# Usage: ./scripts/scan-fairwinds-insights-images.sh
# Requires: helm, trivy (or TRIVY_IMAGE), docker. Run from repo root.
set -eo pipefail

# Use Trivy via Docker when TRIVY_IMAGE is set (e.g. CI) or when trivy is not in PATH
run_trivy() {
  if [[ -n "${TRIVY_IMAGE:-}" ]]; then
    docker run --rm -v /var/run/docker.sock:/var/run/docker.sock "$TRIVY_IMAGE" image "$@"
  elif command -v trivy &>/dev/null; then
    trivy image "$@"
  else
    docker run --rm -v /var/run/docker.sock:/var/run/docker.sock "${TRIVY_IMAGE:-aquasec/trivy:v0.69.3}" image "$@"
  fi
}

REPO_ROOT="${REPO_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
CHART_DIR="$REPO_ROOT/stable/fairwinds-insights"
MARKER_FILE="${SCAN_VULNS_MARKER_FILE:-.scan-found-vulns}"
LIST_FILE="${SCAN_VULNS_LIST_FILE:-.scan-vulns-list}"

cd "$REPO_ROOT"
if [[ ! -d "$CHART_DIR" ]]; then
  echo "Chart not found: $CHART_DIR" >&2
  exit 1
fi

echo "Adding Helm repos for chart dependencies..."
helm repo add minio https://charts.min.io/ --force-update
helm repo add fairwinds-incubator https://charts.fairwinds.com/incubator --force-update
helm repo add temporal https://go.temporal.io/helm-charts --force-update
helm repo add rustfs https://charts.rustfs.com/ --force-update
helm repo update

echo "Building chart dependencies and rendering manifests..."
cd "$CHART_DIR"
helm dependency build
# Render with default values so we get temporal, postgres, openapi, etc.
RENDERED=$(helm template release . --namespace fwinsights 2>/dev/null)
# RustFS and the bucket-creation hook are behind rustfs.install (default false); render again
RENDERED_RUSTFS=$(helm template release . --namespace fwinsights --set rustfs.install=true 2>/dev/null)
cd "$REPO_ROOT"

echo "Extracting image references..."
# Extract image: and imageName: values; trim leading/trailing whitespace and quotes
IMAGES=$(printf '%s\n%s\n' "$RENDERED" "$RENDERED_RUSTFS" | grep -E '^\s+(image|imageName):' | sed -E 's/^[[:space:]]*(image|imageName):[[:space:]]*//' | sed -E 's/^["'\'']|["'\'']$//g' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | sort -u)
if [[ -z "$IMAGES" ]]; then
  echo "No images found in rendered chart" >&2
  exit 1
fi

IMAGE_COUNT=$(echo "$IMAGES" | wc -l)
echo "Scanning $IMAGE_COUNT unique images for CRITICAL/HIGH vulnerabilities..."

# Optional: log in to registries if credentials are present (e.g. for private images)
if [[ -n "${QUAY_ROBOT_USER:-}" && -n "${QUAY_ROBOT_TOKEN:-}" ]]; then
  echo "$QUAY_ROBOT_TOKEN" | docker login -u "$QUAY_ROBOT_USER" --password-stdin quay.io || true
fi

have_vulns=()
while IFS= read -r image; do
  [[ -z "$image" ]] && continue
  echo "Scanning $image"
  if ! docker pull "$image" 2>/dev/null; then
    echo "Warning: could not pull $image (may be private or invalid), skipping"
    continue
  fi
  set +e
  run_trivy --exit-code 123 --severity CRITICAL,HIGH "$image"
  exitcode=$?
  set -e
  if [[ $exitcode -eq 123 ]]; then
    have_vulns+=("$image")
  fi
  echo "Done with $image"
done <<< "$IMAGES"

# Write markers for CI: notify step uses this when job fails (no job requires this one)
if (( ${#have_vulns[@]} != 0 )); then
  echo "The following images have vulnerabilities:"
  : > "$LIST_FILE"
  for img in "${have_vulns[@]}"; do
    echo "- $img" >> "$LIST_FILE"
    echo "$img"
  done
  touch "$MARKER_FILE"
  exit 1
fi

echo "All fairwinds-insights chart images passed Trivy scan."
