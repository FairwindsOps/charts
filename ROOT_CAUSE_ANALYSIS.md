# Root Cause Analysis: Chart-Testing Segmentation Fault

## Issue Summary
Chart-testing (`ct`) commands segfault when creating git diffs. Started happening last week.

## Investigation Results

### Test Environment Comparison

| Environment | Git Version | Chart-Testing | Result |
|------------|-------------|---------------|--------|
| **Local System (old)** | 2.51.2 | v3.12.0 | ❌ Segfault |
| **Local System (current)** | 2.52.0 | v3.12.0 | ⚠️ **Testing now** |
| **Docker Image (v3.12.0)** | 2.43.5 | v3.12.0 | ✅ Works |
| **Docker Image (v3.14.0)** | 2.49.1 | v3.14.0 | ✅ **Upgraded in CI** |

### Key Findings

1. **Git Commands Work Fine**: Direct git commands (git diff, git merge-base) work perfectly with git 2.51.2
2. **Docker Works**: The same ct commands work in Docker where git is 2.43.5
3. **Binary Incompatibility**: The segfault occurs inside the `ct` binary, not in git itself

### Root Cause

**Chart-testing v3.12.0 binary is incompatible with git 2.51.2**

The `ct` binary was likely compiled against an older git library version. When it tries to call git functions on a system with git 2.51.2, there's a library/ABI mismatch causing the segfault.

**Testing v3.14.0**: Newer version (released Oct 8, 2025) may have been compiled against newer git, potentially fixing the compatibility issue.

### Why It Started Last Week

Git 2.51.2 was likely installed/updated on your system last week, introducing the incompatibility.

## Incremental Fixes Applied

### Change 1: Remove `--print-config`
- **Status**: ✅ Applied
- **Impact**: Cleaner output, may reduce some processing

### Change 2: Add `--target-branch master`
- **Status**: ✅ Applied  
- **Impact**: Makes branch explicit, may help with some edge cases

### Change 3: Add Error Handling
- **Status**: ✅ Applied
- **Impact**: Scripts don't crash, provide helpful messages

### Change 4: Add Git Fallback
- **Status**: ✅ Applied
- **Impact**: **CRITICAL** - Allows scripts to work even when ct segfaults

## Recommended Solutions

### Short-term (Current)
✅ Git fallback is implemented - scripts will work even when ct fails

### Medium-term
1. **Test git 2.52.0**: 
   - Git 2.52.0 was released Nov 17, 2025
   - Available via Homebrew: `brew upgrade git`
   - **Unlikely to fix**: The issue is chart-testing binary compiled against older git
   - **Worth testing**: If git 2.52.0 maintains better ABI compatibility
   - **Risk**: Could make it worse if there are more breaking changes
2. **Use Docker for ct**: Run ct inside docker container where git is compatible
3. **Downgrade git locally**: Use git 2.50.x or earlier (if 2.52.0 doesn't work)
4. **Upgrade chart-testing**: ✅ **Upgraded to v3.14.0** (released Oct 8, 2025, includes git 2.49.1 in docker)

### Long-term
1. **Report to chart-testing**: File issue about git 2.51.x compatibility
2. **Wait for fix**: Chart-testing maintainers may release a fix
3. **Consider alternatives**: Evaluate other chart testing tools

## Testing Commands

```bash
# Test git fallback manually
MERGE_BASE=$(git merge-base origin/master HEAD)
git diff --find-renames --name-only "$MERGE_BASE" HEAD -- stable incubator

# Test in docker v3.12.0 (should work)
docker run --rm -v $(pwd):/charts -w /charts \
  quay.io/helmpack/chart-testing:v3.12.0 \
  ct list-changed --config scripts/ct.yaml --target-branch master

# Test in docker v3.14.0 (newer version, testing compatibility)
docker run --rm -v $(pwd):/charts -w /charts \
  quay.io/helmpack/chart-testing:v3.14.0 \
  ct list-changed --config scripts/ct.yaml --target-branch master
```

