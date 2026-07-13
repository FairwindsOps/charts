#! /usr/bin/env bash
# Update CHANGELOG.md on Renovate dependency PRs (CircleCI).
# Runs only if the latest commit is by renovate[bot].
# Requires GITHUB_TOKEN (repo scope) in project env or a context (e.g. org-global).
#
# Same pattern as insights-plugins: CI derives changelog bullets from
# scripts/helm-diff-changelog.py. The PR title is only a fallback message.
set -euo pipefail

if ! command -v python3 >/dev/null 2>&1; then
  sudo apt-get update -qq
  sudo apt-get install -y -qq python3 >/dev/null
fi

AUTHOR=$(git log -1 --format='%an')
if [[ "$AUTHOR" != "renovate[bot]" ]]; then
  echo "Latest commit author is not renovate[bot] (got '${AUTHOR}'); skipping bump."
  exit 0
fi

GITHUB_TOKEN="${GITHUB_TOKEN:-${GH_TOKEN:-${GITHUB_ACCESS_TOKEN:-}}}"
if [[ -z "$GITHUB_TOKEN" ]]; then
  echo "GITHUB_TOKEN is not set. Vault repo/global/env should expose GITHUB_TOKEN, GH_TOKEN, or GITHUB_ACCESS_TOKEN."
  exit 1
fi
export GITHUB_TOKEN

git fetch --no-tags origin +refs/heads/master:refs/remotes/origin/master 2>/dev/null || \
  git fetch origin master --depth=500

# CIRCLE_PR_NUMBER is only set for forked PRs; Renovate opens same-repo PRs.
PR_NUMBER="${CIRCLE_PR_NUMBER:-}"
if [[ -z "$PR_NUMBER" && -n "${CIRCLE_PULL_REQUEST:-}" ]]; then
  PR_NUMBER="${CIRCLE_PULL_REQUEST##*/}"
fi

MSG="Bump dependencies"
if [[ -n "${CIRCLE_PROJECT_USERNAME:-}" && -n "${CIRCLE_PROJECT_REPONAME:-}" ]]; then
  if [[ -z "$PR_NUMBER" && -n "${CIRCLE_BRANCH:-}" ]]; then
    pr_resp=$(curl -fsSL \
      -H "Accept: application/vnd.github+json" \
      -H "Authorization: Bearer ${GITHUB_TOKEN}" \
      "https://api.github.com/repos/${CIRCLE_PROJECT_USERNAME}/${CIRCLE_PROJECT_REPONAME}/pulls?head=${CIRCLE_PROJECT_USERNAME}:${CIRCLE_BRANCH}&state=open" 2>/dev/null) || pr_resp=""
    if [[ -n "$pr_resp" ]]; then
      PR_NUMBER=$(printf '%s' "$pr_resp" | python3 -c "import sys,json; ps=json.load(sys.stdin); print(ps[0]['number'] if ps else '')" 2>/dev/null || true)
    fi
  fi

  if [[ -n "$PR_NUMBER" ]]; then
    resp=$(curl -fsSL \
      -H "Accept: application/vnd.github+json" \
      -H "Authorization: Bearer ${GITHUB_TOKEN}" \
      "https://api.github.com/repos/${CIRCLE_PROJECT_USERNAME}/${CIRCLE_PROJECT_REPONAME}/pulls/${PR_NUMBER}" 2>/dev/null) || resp=""
    if [[ -n "$resp" ]] && command -v python3 >/dev/null 2>&1; then
      raw_title=$(printf '%s' "$resp" | python3 -c "import sys,json; print(json.load(sys.stdin).get('title','Bump dependencies'))" 2>/dev/null || echo "Bump dependencies")
      MSG=$(printf '%s' "$raw_title" | sed -e 's/^[Cc]hore(deps):[[:space:]]*//' -e 's/^chore(deps):[[:space:]]*//')
    fi
  fi
fi

./scripts/bump-changed-renovate.sh "$MSG"

if git diff --quiet; then
  echo "No changelog updates needed."
  exit 0
fi

git config --global user.name "Charts CI"
git config --global user.email insights@fairwinds.com

git add stable/insights-agent/CHANGELOG.md stable/fairwinds-insights/CHANGELOG.md stable/insights-admission/CHANGELOG.md
git commit -m "chore: bump CHANGELOG.md for changed charts"

git remote set-url origin "https://x-access-token:${GITHUB_TOKEN}@github.com/${CIRCLE_PROJECT_USERNAME}/${CIRCLE_PROJECT_REPONAME}.git"
git push origin "HEAD:${CIRCLE_BRANCH}"
