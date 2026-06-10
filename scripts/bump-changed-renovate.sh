#!/usr/bin/env bash
set -eo pipefail

# Add CHANGELOG.md entries for charts changed on a Renovate PR branch.
# Chart.yaml versions are bumped by Renovate; this only updates changelogs enforced by CI.

message=$1
require_changelog=(insights-agent fairwinds-insights insights-admission)

if [[ -z $message ]]; then
  echo "Usage: ./scripts/bump-changed-renovate.sh 'Message to add to the changelog'"
  exit 1
fi

should_bump_renovate_ci() {
  local chart=$1
  local d="stable/$chart"

  if git diff --name-only --exit-code origin/master -- "$d" > /dev/null 2>&1; then
    return 1
  fi

  local version
  version=$(grep '^version:' "$d/Chart.yaml" | head -1 | awk '{print $2}' | tr -d "'\"")
  if grep -qxF "## ${version}" "$d/CHANGELOG.md" 2>/dev/null; then
    return 1
  fi
  return 0
}

bump_one_chart() {
  local chart=$1
  local d="stable/$chart"
  local fallback_msg=$2
  local version

  version=$(grep '^version:' "$d/Chart.yaml" | head -1 | awk '{print $2}' | tr -d "'\"")

  echo -e "# Changelog" > /tmp/CHANGELOG.md
  echo -e "\n## $version" >> /tmp/CHANGELOG.md
  echo -e "* $fallback_msg" >> /tmp/CHANGELOG.md
  tail -n+2 "$d/CHANGELOG.md" >> /tmp/CHANGELOG.md
  mv /tmp/CHANGELOG.md "$d/CHANGELOG.md"
}

for chart in "${require_changelog[@]}"; do
  if should_bump_renovate_ci "$chart"; then
    echo "stable/$chart"
    bump_one_chart "$chart" "$message"
  fi
done
