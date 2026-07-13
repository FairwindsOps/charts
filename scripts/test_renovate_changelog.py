#!/usr/bin/env python3
"""Unit tests for renovate changelog helpers (stdlib unittest only)."""
from __future__ import annotations

import importlib.util
import unittest
from pathlib import Path


def _load(name: str, filename: str):
    path = Path(__file__).resolve().parent / filename
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec and spec.loader
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


hdc = _load("helm_diff_changelog", "helm-diff-changelog.py")
fallback = _load("renovate_pr_fallback", "renovate-pr-fallback.py")


class TestChartYaml(unittest.TestCase):
    def test_temporal_dep_and_insights_api_app_version(self):
        old = """apiVersion: v2
name: fairwinds-insights
version: 5.0.0
appVersion: "18.3.63"
dependencies:
  - name: temporal
    version: 1.4.0
    repository: https://example.com
"""
        new = """apiVersion: v2
name: fairwinds-insights
version: 5.0.1
appVersion: "18.3.64"
dependencies:
  - name: temporal
    version: 1.5.0
    repository: https://example.com
"""
        self.assertEqual(
            hdc.bullets_from_chart_yaml(old, new, "stable/fairwinds-insights"),
            [
                "Bumped `temporal` to `1.5.0`",
                "Bumped `insights-api` to `18.3.64`",
            ],
        )

    def test_app_version_generic_label(self):
        old = 'appVersion: "1.0.0"\n'
        new = 'appVersion: "1.0.1"\n'
        self.assertEqual(
            hdc.bullets_from_chart_yaml(old, new, "stable/insights-agent"),
            ["Bumped `appVersion` to `1.0.1`"],
        )


class TestValuesYaml(unittest.TestCase):
    def test_tag_change_with_adjacent_repository(self):
        old = """openApiImage:
  repository: swaggerapi/swagger-ui
  tag: v5.32.7
"""
        new = """openApiImage:
  repository: swaggerapi/swagger-ui
  tag: v5.32.8
"""
        self.assertEqual(
            hdc.bullets_from_values_yaml(old, new),
            ["Bumped `swaggerapi/swagger-ui` to `v5.32.8`"],
        )

    def test_tag_change_repository_far_from_tag(self):
        """Full-file parse still associates repo even when far from tag."""
        old = """image:
  repository: alpine/kubectl
  pullPolicy: IfNotPresent
  # many lines
  resources:
    limits:
      cpu: 100m
  tag: "1.36.0"
"""
        new = """image:
  repository: alpine/kubectl
  pullPolicy: IfNotPresent
  # many lines
  resources:
    limits:
      cpu: 100m
  tag: "1.36.1"
"""
        self.assertEqual(
            hdc.bullets_from_values_yaml(old, new),
            ["Bumped `alpine/kubectl` to `1.36.1`"],
        )

    def test_gadget_version(self):
        old = 'gadgetVersion: "v0.53.1"\n'
        new = 'gadgetVersion: "v0.53.2"\n'
        self.assertEqual(
            hdc.bullets_from_values_yaml(old, new),
            ["Bumped `gadget` to `v0.53.2`"],
        )

    def test_python_quoted_tag(self):
        old = """image:
  repository: "python"
  tag: "3.9-alpine"
"""
        new = """image:
  repository: "python"
  tag: "3.14-alpine"
"""
        self.assertEqual(
            hdc.bullets_from_values_yaml(old, new),
            ["Bumped `python` to `3.14-alpine`"],
        )

    def test_empty_tags_ignored(self):
        old = """apiImage:
  repository: us-docker.pkg.dev/fairwinds-ops/insights/insights-api
  tag:
"""
        new = old
        self.assertEqual(hdc.bullets_from_values_yaml(old, new), [])

    def test_tag_with_trailing_comment(self):
        text = "tag: v5.32.8  # NOTE: look at templates\n"
        match = hdc.TAG_RE.match(text.strip())
        assert match is not None
        self.assertEqual(match.group(1), "v5.32.8")

    def test_parse_values_versions_skips_app_version_key(self):
        _, custom = hdc.parse_values_versions('appVersion: "9.0"\ngadgetVersion: "v1"\n')
        self.assertNotIn("appVersion", custom)
        self.assertEqual(custom["gadgetVersion"], "v1")


class TestPrFallback(unittest.TestCase):
    def test_title_helm_release(self):
        self.assertEqual(
            fallback.bullets_from_pr("Update Helm release temporal to v1.5.0", ""),
            ["Bumped `temporal` to `1.5.0`"],
        )

    def test_title_docker_tag(self):
        self.assertEqual(
            fallback.bullets_from_pr(
                "Update us-docker.pkg.dev/fairwinds-ops/insights/insights-api Docker tag to v18.3.64",
                "",
            ),
            [
                "Bumped `us-docker.pkg.dev/fairwinds-ops/insights/insights-api` to `18.3.64`"
            ],
        )

    def test_table_body(self):
        body = """
| Package | Type | Update |
| --- | --- | --- |
| [swaggerapi/swagger-ui](https://example.com) | docker | `v5.32.7` → `v5.32.8` |
"""
        self.assertEqual(
            fallback.bullets_from_pr("chore(deps): Update something", body),
            ["Bumped `swaggerapi/swagger-ui` to `v5.32.8`"],
        )

    def test_short_name_pkg_dev(self):
        self.assertEqual(
            fallback.short_name(
                "us-docker.pkg.dev/fairwinds-ops/insights/insights-api"
            ),
            "insights/insights-api",
        )


if __name__ == "__main__":
    unittest.main()
