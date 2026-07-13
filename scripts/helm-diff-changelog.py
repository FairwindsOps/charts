#!/usr/bin/env python3
"""Parse git diffs for a Helm chart dir vs origin/master; emit changelog bullet lines.

Mirrors insights-plugins/scripts/gomod-diff-changelog.py for Chart.yaml dependencies,
appVersion, and values.yaml image tags / *Version fields.
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


def _git_diff(*paths: str) -> str:
    p = subprocess.run(
        ["git", "diff", BASE_REF, "--", *paths],
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


def bullets_from_values_diff(diff_text: str) -> list[str]:
    """Emit bullets for image tag / *Version changes in a values.yaml unified diff."""
    out: list[str] = []
    seen: set[tuple[str, str]] = set()
    current_repo = "image"
    # repo -> removed tag (awaiting matching add)
    pending_tag: dict[str, str] = {}
    pending_custom: dict[str, str] = {}

    for line in diff_text.splitlines():
        if not line or line.startswith(("---", "+++", "@@")):
            continue
        sign = line[0]
        if sign not in " +-":
            continue
        body = line[1:].strip()
        if not body or body.startswith("#"):
            continue

        m = REPO_RE.match(body)
        if m:
            current_repo = m.group(1)
            continue

        m = TAG_RE.match(body)
        if m:
            tag = m.group(1)
            if sign == "-":
                pending_tag[current_repo] = tag
            elif sign == "+":
                old = pending_tag.pop(current_repo, None)
                if old != tag:
                    key = (current_repo, tag)
                    if key not in seen:
                        seen.add(key)
                        out.append(f"Bumped `{current_repo}` to `{tag}`")
            continue

        m = CUSTOM_VER_RE.match(body)
        if m:
            key_name, ver = m.group(1), m.group(2)
            if key_name in ("appVersion",):  # handled via Chart.yaml
                continue
            if sign == "-":
                pending_custom[key_name] = ver
            elif sign == "+":
                old = pending_custom.pop(key_name, None)
                if old != ver:
                    key = (key_name, ver)
                    if key not in seen:
                        seen.add(key)
                        # Prefer a short label: gadgetVersion -> gadget
                        label = re.sub(r"[Vv]ersion$", "", key_name) or key_name
                        out.append(f"Bumped `{label}` to `{ver}`")
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
        diff = _git_diff(values_yaml)
        if diff.strip():
            bullets.extend(bullets_from_values_diff(diff))

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
