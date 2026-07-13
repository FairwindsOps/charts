#!/usr/bin/env python3
"""Parse Helm chart files vs origin/master; emit changelog bullet lines.

Mirrors insights-plugins/scripts/gomod-diff-changelog.py for Chart.yaml dependencies,
appVersion, and values.yaml image tags / *Version fields.

Compares full old/new file contents (not unified diffs) so repository/tag association
does not depend on git hunk context.
"""
from __future__ import annotations

import os
import re
import subprocess
import sys

BASE_REF = os.environ.get("BASE_REF", "origin/master")

DEP_NAME_RE = re.compile(r"^-\s+name:\s*['\"]?([^'\"#\s]+)['\"]?")
DEP_VER_RE = re.compile(r"^version:\s*['\"]?([^'\"#\s]+)['\"]?")
APP_VER_RE = re.compile(r"^appVersion:\s*['\"]?([^'\"#\s]+)['\"]?", re.MULTILINE)
REPO_RE = re.compile(r"^repository:\s*['\"]?([^'\"#\s]+)['\"]?")
TAG_RE = re.compile(r"^tag:\s*['\"]?([^'\"#\s]+)['\"]?")
# e.g. gadgetVersion: v0.53.2 (custom.regex / values keys)
CUSTOM_VER_RE = re.compile(r"^([A-Za-z][\w]*[Vv]ersion):\s*['\"]?([^'\"#\s]+)['\"]?")


def _git_show(path: str) -> str:
    p = subprocess.run(
        ["git", "show", f"{BASE_REF}:{path}"],
        capture_output=True,
        text=True,
    )
    if p.returncode != 0:
        return ""
    return p.stdout


def _read(path: str) -> str:
    try:
        with open(path, encoding="utf-8") as f:
            return f.read()
    except OSError:
        return ""


def parse_chart_deps(text: str) -> dict[str, str]:
    """Map dependency name -> version from Chart.yaml dependencies: section."""
    deps: dict[str, str] = {}
    in_deps = False
    current: str | None = None
    for raw in text.splitlines():
        line = raw.rstrip()
        if line.startswith("dependencies:"):
            in_deps = True
            current = None
            continue
        if not in_deps:
            continue
        if line and not line[0].isspace() and not line.startswith("#"):
            break
        stripped = line.lstrip()
        m = DEP_NAME_RE.match(stripped)
        if m:
            current = m.group(1)
            continue
        m = DEP_VER_RE.match(stripped)
        if m and current:
            deps[current] = m.group(1)
    return deps


def bullets_from_chart_yaml(old: str, new: str, chart_dir: str = "") -> list[str]:
    out: list[str] = []
    old_deps, new_deps = parse_chart_deps(old), parse_chart_deps(new)
    for name in sorted(set(old_deps) | set(new_deps)):
        if name not in new_deps:
            continue
        new_ver = new_deps[name]
        old_ver = old_deps.get(name)
        if old_ver == new_ver:
            continue
        out.append(f"Bumped `{name}` to `{new_ver}`")

    old_app = APP_VER_RE.search(old)
    new_app = APP_VER_RE.search(new)
    if new_app and (not old_app or old_app.group(1) != new_app.group(1)):
        # fairwinds-insights appVersion tracks the insights-api image (see renovate.json).
        label = "insights-api" if chart_dir.rstrip("/").endswith("fairwinds-insights") else "appVersion"
        out.append(f"Bumped `{label}` to `{new_app.group(1)}`")
    return out


def parse_values_versions(text: str) -> tuple[dict[str, str], dict[str, str]]:
    """Parse values.yaml into (repository -> tag, customVersionKey -> version)."""
    repo_tags: dict[str, str] = {}
    custom: dict[str, str] = {}
    current_repo: str | None = None

    for raw in text.splitlines():
        stripped = raw.strip()
        if not stripped or stripped.startswith("#"):
            continue

        m = REPO_RE.match(stripped)
        if m:
            current_repo = m.group(1)
            continue

        m = TAG_RE.match(stripped)
        if m and current_repo is not None:
            repo_tags[current_repo] = m.group(1)
            continue

        m = CUSTOM_VER_RE.match(stripped)
        if m:
            key_name, ver = m.group(1), m.group(2)
            if key_name == "appVersion":
                continue
            custom[key_name] = ver

    return repo_tags, custom


def bullets_from_values_yaml(old: str, new: str) -> list[str]:
    """Emit bullets for image tag / *Version changes between two values.yaml texts."""
    out: list[str] = []
    old_repos, old_custom = parse_values_versions(old)
    new_repos, new_custom = parse_values_versions(new)

    for repo in sorted(set(old_repos) | set(new_repos)):
        if repo not in new_repos:
            continue
        new_tag = new_repos[repo]
        if old_repos.get(repo) == new_tag:
            continue
        out.append(f"Bumped `{repo}` to `{new_tag}`")

    for key_name in sorted(set(old_custom) | set(new_custom)):
        if key_name not in new_custom:
            continue
        new_ver = new_custom[key_name]
        if old_custom.get(key_name) == new_ver:
            continue
        label = re.sub(r"[Vv]ersion$", "", key_name) or key_name
        out.append(f"Bumped `{label}` to `{new_ver}`")

    return out


def bullets_for_chart(chart_dir: str) -> list[str]:
    chart_dir = chart_dir.rstrip("/")
    chart_yaml = f"{chart_dir}/Chart.yaml"
    values_yaml = f"{chart_dir}/values.yaml"

    bullets: list[str] = []
    if os.path.isfile(chart_yaml):
        bullets.extend(
            bullets_from_chart_yaml(
                _git_show(chart_yaml), _read(chart_yaml), chart_dir=chart_dir
            )
        )

    if os.path.isfile(values_yaml):
        old_values = _git_show(values_yaml)
        new_values = _read(values_yaml)
        if old_values != new_values:
            bullets.extend(bullets_from_values_yaml(old_values, new_values))

    # Dedupe while preserving order
    seen: set[str] = set()
    unique: list[str] = []
    for b in bullets:
        if b not in seen:
            seen.add(b)
            unique.append(b)
    return unique


def main() -> int:
    if len(sys.argv) < 2:
        print("usage: helm-diff-changelog.py <stable/chart-dir>", file=sys.stderr)
        return 2
    chart_dir = sys.argv[1]
    for line in bullets_for_chart(chart_dir):
        print(line)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
