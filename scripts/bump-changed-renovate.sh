#!/usr/bin/env bash
set -eo pipefail

# Add CHANGELOG.md entries for charts changed on a Renovate PR branch.
# Chart.yaml versions are bumped by Renovate; this only updates changelogs enforced by CI.
# Prefer package/version bullets from helm-diff-changelog.py (same idea as
# insights-plugins gomod-diff-changelog.py); fall back to the PR-derived message.

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

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
  local version bullets_tmp err_tmp py_out py_rc

  bullets_tmp=$(mktemp)
  err_tmp=$(mktemp)
  # Capture stderr; do not hide parser failures behind the PR fallback.
  set +e
  py_out=$(python3 "${SCRIPT_DIR}/helm-diff-changelog.py" "$d" 2>"$err_tmp")
  py_rc=$?
  set -e

  if [[ $py_rc -ne 0 ]]; then
    echo "helm-diff-changelog.py failed for $d (exit ${py_rc}); using PR-derived fallback." >&2
    if [[ -s "$err_tmp" ]]; then
      cat "$err_tmp" >&2
    fi
    printf '%s\n' "$fallback_msg" > "$bullets_tmp"
  elif [[ -n "$py_out" ]]; then
    printf '%s\n' "$py_out" > "$bullets_tmp"
  else
    echo "helm-diff-changelog.py produced no bullets for $d; using PR-derived fallback." >&2
    printf '%s\n' "$fallback_msg" > "$bullets_tmp"
  fi
  rm -f "$err_tmp"

  version=$(grep '^version:' "$d/Chart.yaml" | head -1 | awk '{print $2}' | tr -d "'\"")

  {
    echo -e "# Changelog"
    echo -e "\n## $version"
    while IFS= read -r line || [[ -n "$line" ]]; do
      [[ -z "$line" ]] && continue
      echo "* $line"
    done < "$bullets_tmp"
    tail -n+2 "$d/CHANGELOG.md"
  } > /tmp/CHANGELOG.md
  rm -f "$bullets_tmp"
  mv /tmp/CHANGELOG.md "$d/CHANGELOG.md"
}

for chart in "${require_changelog[@]}"; do
  if should_bump_renovate_ci "$chart"; then
    echo "stable/$chart"
    bump_one_chart "$chart" "$message"
  fi
done
