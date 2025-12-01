# Git 2.52.0 in CI Pipeline

## Changes Made

### Updated Files

1. **`.circleci/config.yml`**:
   - Added `install_git_2_52` reference that installs git 2.52.0 from source
   - Works for both Alpine Linux (chart-testing images) and Debian (ci-images)
   - Added to `lint-charts` job
   - Added to `sync` job

2. **`scripts/circle-e2e.sh`**:
   - Added git 2.52.0 upgrade at the start of e2e tests
   - Runs before any ct commands to ensure compatibility

## How It Works

### For Chart-Testing Jobs (Alpine Linux)
- Detects if git is not 2.52.0
- Installs build dependencies (build-base, curl-dev, expat-dev, etc.)
- Downloads git 2.52.0 source from GitHub
- Compiles and installs git 2.52.0
- Verifies installation

### For E2E Tests
- The `circle-e2e.sh` script runs in the `command_runner_image` (chart-testing:v3.14.0)
- Upgrades git to 2.52.0 before running any ct commands
- Ensures ct commands use git 2.52.0

## Current Git Versions in Images

| Image | Current Git | After Upgrade |
|-------|-------------|---------------|
| `quay.io/helmpack/chart-testing:v3.14.0` | 2.49.1 | 2.52.0 |
| `quay.io/reactiveops/ci-images:v14.1-bullseye` | 2.30.2 | 2.52.0 (if needed) |

## Jobs Affected

1. **lint-charts**: Uses chart-testing image, git upgraded to 2.52.0
2. **sync**: Uses chart-testing image, git upgraded to 2.52.0
3. **e2e tests** (all Kubernetes versions): Uses chart-testing as command_runner_image, git upgraded in circle-e2e.sh

## Performance Impact

- **First run**: ~2-3 minutes to compile git from source
- **Subsequent runs**: Faster if Docker layer caching works
- **Recommendation**: Consider creating a custom Docker image with git 2.52.0 pre-installed for faster CI runs

## Verification

After CI runs, check logs for:
```
Current git version: git version X.X.X
Upgrading git to 2.52.0...
Git version after upgrade: git version 2.52.0
```

## Rollback

If git 2.52.0 causes issues:
1. Remove `*install_git_2_52` from jobs
2. Remove git upgrade from `scripts/circle-e2e.sh`
3. The git fallback in scripts will still work

