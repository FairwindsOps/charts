# Testing Git 2.52.0 Compatibility

## Current Status
- **Previous Git**: 2.51.2 (caused segfault with chart-testing v3.12.0)
- **Current Git**: 2.52.0 ✅ **UPGRADED** (released Nov 17, 2025)
- **Chart-Testing**: v3.12.0

## Test Plan

### Step 1: Upgrade Git ✅ COMPLETED
```bash
brew upgrade git
git --version  # Verified: git version 2.52.0
```

### Step 2: Test ct list-changed
```bash
cd /Users/james/git/charts
ct list-changed --config scripts/ct.yaml --target-branch master
```

**Expected Outcomes:**
- ✅ **Works**: Git 2.52.0 is compatible - problem solved!
- ❌ **Still segfaults**: Git 2.52.0 has same issue - need to downgrade or use docker
- ⚠️ **Different error**: May indicate progress or new issue

### Step 3: Test ct install
```bash
ct install --config scripts/ct.yaml --target-branch master --debug
```

### Step 4: If Still Fails
1. **Downgrade git**: `brew install git@2.50` (if available)
2. **Use docker**: Run ct commands in docker container
3. **Keep git fallback**: Our scripts already handle this

## Analysis

**Why Git 2.52.0 Might Help:**
- Git may have improved ABI compatibility
- Could have fixed issues introduced in 2.51.x

**Why Git 2.52.0 Might Not Help:**
- Chart-testing v3.12.0 was compiled against git 2.43.5 (in docker)
- Binary compatibility issues are usually not fixed by upgrading the incompatible library
- The ct binary needs to be recompiled against newer git

**Recommendation:**
Test it, but don't expect it to fix the issue. The git fallback in our scripts is the reliable solution.

