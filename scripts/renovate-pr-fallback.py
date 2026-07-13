#!/usr/bin/env python3
"""Derive changelog fallback lines from a GitHub PR JSON payload (stdin).

Used only when helm-diff-changelog.py produces no bullets for a chart.
"""
from __future__ import annotations

import json
import re
import sys


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


def bullets_from_pr(title: str, body: str) -> list[str]:
    title = re.sub(r"^chore\(deps\):\s*", "", title or "", flags=re.IGNORECASE).strip()
    if not title:
        title = "Bump dependencies"
    body = body or ""

    upgrades: list[tuple[str, str]] = []
    seen: set[tuple[str, str]] = set()
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
        return [f"Bumped `{pkg}` to `{ver}`" for pkg, ver in upgrades]

    patterns = [
        (r"^Update Helm release (.+) to v?(.+)$", r"Bumped `\1` to `\2`"),
        (r"^Update (.+) Docker tag to v?(.+)$", r"Bumped `\1` to `\2`"),
        (r"^Update dependency (.+) to v?(.+)$", r"Bumped `\1` to `\2`"),
        (r"^Update (.+) to v?(.+)$", r"Bumped `\1` to `\2`"),
    ]
    for pat, repl in patterns:
        if re.match(pat, title):
            return [re.sub(pat, repl, title)]

    return [title]


def main() -> int:
    try:
        pr = json.load(sys.stdin)
    except json.JSONDecodeError as e:
        print(f"renovate-pr-fallback.py: invalid JSON on stdin: {e}", file=sys.stderr)
        return 1
    for line in bullets_from_pr(pr.get("title") or "", pr.get("body") or ""):
        print(line)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
