#!/usr/bin/env sh
# Verify opt-in PostgreSQL/Timescale role separation renders expected manifests.
set -o errexit
set -o nounset

chart_dir="$(cd "$(dirname "$0")/.." && pwd)"
values_file="${chart_dir}/ci/test-values-roles.yaml"
release_name="roles-ci-test"

render="$(helm template "$release_name" "$chart_dir" -f "$values_file" 2>&1)" || {
  printf '%s\n' "$render" >&2
  exit 1
}

assert_contains() {
  needle="$1"
  label="$2"
  if ! printf '%s' "$render" | grep -Fq "$needle"; then
    printf 'render-roles-test: expected %s to contain: %s\n' "$label" "$needle" >&2
    exit 1
  fi
}

assert_not_contains() {
  needle="$1"
  label="$2"
  if printf '%s' "$render" | grep -Fq "$needle"; then
    printf 'render-roles-test: expected %s NOT to contain: %s\n' "$label" "$needle" >&2
    exit 1
  fi
}

# CNPG bootstrap SQL and managed roles
assert_contains "CREATE ROLE insights_owner NOLOGIN" "postgres postInitSQL owner role"
assert_contains "CREATE ROLE insights_app LOGIN" "postgres postInitSQL app role"
assert_contains "CREATE ROLE ts_owner NOLOGIN" "timescale postInitSQL owner role"
assert_contains "CREATE ROLE ts_app LOGIN" "timescale postInitSQL app role"

# Ephemeral secrets
assert_contains "name: fwinsights-postgresql-migration" "postgres migration secret"
assert_contains "name: fwinsights-timescale-migration" "timescale migration secret"

# Migration job credentials (rendered in full chart output)
assert_contains "name: POSTGRES_OWNER_ROLE" "migration owner env"
assert_contains "value: insights_owner" "postgres owner role value"
assert_contains "value: insights_migrate" "postgres migration user"
assert_contains "name: fwinsights-postgresql-migration" "migration job secret ref"

# Default-path regression: standard CI values must not enable owner role
default_render="$(helm template "$release_name" "$chart_dir" -f "${chart_dir}/ci/test-values.yaml" 2>&1)" || {
  printf '%s\n' "$default_render" >&2
  exit 1
}
if printf '%s' "$default_render" | grep -Fq "POSTGRES_OWNER_ROLE"; then
  printf 'render-roles-test: default test-values must not set POSTGRES_OWNER_ROLE\n' >&2
  exit 1
fi

printf 'render-roles-test: OK\n'
