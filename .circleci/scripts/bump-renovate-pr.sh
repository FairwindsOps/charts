#! /usr/bin/env bash
# Update CHANGELOG.md on Renovate dependency PRs (CircleCI).
# Runs only if the latest commit is by renovate[bot].
# Requires GITHUB_TOKEN (repo scope) in project env or a context (e.g. org-global).
#
# Same pattern as insights-plugins: CI derives changelog bullets from the git diff
# (scripts/helm-diff-changelog.py). The PR title/body is only a fallback message.
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
    if [[ -n "$resp" ]]; then
      # Fallback only: helm-diff-changelog.py usually supplies package + version.
      MSG=$(printf '%s' "$resp" | python3 -c '
import json, re, sys

pr = json.load(sys.stdin)
title = pr.get("title") or "Bump dependencies"
title = re.sub(r"^chore\(deps\):\s*", "", title, flags=re.IGNORECASE)
body = pr.get("body") or ""

def strip_md_link(text: str) -> str:
    m = re.match(r"\[([^\]]+)\]\([^)]+\)", text.strip())
    if m:
        return m.group(1).strip()
    return text.strip()

def short_name(pkg: str) -> str:
    pkg = strip_md_link(pkg)
    pkg = re.sub(r"\s*\(.*\)$", "", pkg).strip()
    if "/" in pkg and not pkg.startswith("http"):
        parts = [p for p in pkg.split("/") if p]
        if len(parts) >= 3 and ("." in parts[0] or "pkg.dev" in pkg):
            return "/".join(parts[-2:])
    return pkg

upgrades = []
seen = set()
row_re = re.compile(
    r"^\|\s*(.+?)\s*\|\s*[^|]*\|\s*`([^`]+)`\s*(?:→|->)\s*`([^`]+)`",
    re.MULTILINE,
)
for m in row_re.finditer(body):
    pkg = short_name(m.group(1))
    new_ver = m.group(3).strip()
    if not pkg or pkg.lower() in ("package", "---"):
        continue
    key = (pkg, new_ver)
    if key in seen:
        continue
    seen.add(key)
    upgrades.append((pkg, new_ver))

if upgrades:
    print("\n".join(f"Bumped `{pkg}` to `{ver}`" for pkg, ver in upgrades))
    sys.exit(0)

patterns = [
    (r"^Update Helm release (.+) to v?(.+)$", r"Bumped `\1` to `\2`"),
    (r"^Update (.+) Docker tag to v?(.+)$", r"Bumped `\1` to `\2`"),
    (r"^Update dependency (.+) to v?(.+)$", r"Bumped `\1` to `\2`"),
    (r"^Update (.+) to v?(.+)$", r"Bumped `\1` to `\2`"),
]
for pat, repl in patterns:
    if re.match(pat, title):
        print(re.sub(pat, repl, title))
        sys.exit(0)

print(title)
')
    fi
  fi
fi

echo "Fallback changelog message(s):"
printf '%s\n' "$MSG"

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
