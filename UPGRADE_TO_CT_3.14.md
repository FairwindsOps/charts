# Upgrading Chart-Testing to v3.14.0

## Changes Made

### Updated Files
1. **`.circleci/config.yml`**: Updated all chart-testing references from v3.13.0 → v3.14.0
   - `kind_configuration_helm3.command_runner_image`
   - `lint-charts` job docker image
   - `sync` job docker image

2. **`CONTRIBUTING.md`**: Updated example command to use v3.14.0

3. **`ROOT_CAUSE_ANALYSIS.md`**: Added v3.14.0 to test matrix

## Why v3.14.0?

- **Released**: October 8, 2025
- **Git Version in Docker**: 2.49.1 (newer than v3.12.0's 2.43.5)
- **Potential Fix**: May have been compiled against newer git, fixing compatibility with git 2.51.2/2.52.0

## Testing

### In Docker (Recommended)
```bash
# Test ct list-changed
docker run --rm -v $(pwd):/charts -w /charts \
  quay.io/helmpack/chart-testing:v3.14.0 \
  ct list-changed --config scripts/ct.yaml --target-branch master

# Test ct install
docker run --rm -v $(pwd):/charts -w /charts \
  quay.io/helmpack/chart-testing:v3.14.0 \
  ct install --config scripts/ct.yaml --target-branch master --debug
```

### Local Testing (if ct is installed)
```bash
# If you have ct installed locally, test with git 2.52.0
ct list-changed --config scripts/ct.yaml --target-branch master
```

## Expected Outcomes

1. ✅ **Works**: v3.14.0 is compatible with git 2.52.0 - problem solved!
2. ❌ **Still segfaults**: Same incompatibility - git fallback still needed
3. ⚠️ **Different error**: May indicate progress or new issue

## Rollback Plan

If v3.14.0 causes issues, revert to v3.13.0:
```bash
git checkout .circleci/config.yml CONTRIBUTING.md
# Or manually change v3.14.0 back to v3.13.0
```

## Notes

- The git fallback in our scripts will still work if v3.14.0 has issues
- CI will use v3.14.0 for all chart-testing operations
- Docker images are cached, so first run may be slower

