#!/bin/bash

# Copy the repository to the e2e container
# Include .git directory to preserve full git history
docker cp "$(pwd)/." e2e-command-runner:/charts

# Ensure git repository is properly initialized in the container
# This is needed for ct list-changed to work properly
# The issue is that docker cp might not preserve all git metadata properly
docker exec e2e-command-runner sh -c "cd /charts && \
  git config --global --add safe.directory /charts && \
  git config --global user.email 'ci@fairwinds.com' && \
  git config --global user.name 'CI' && \
  (git remote set-url origin https://github.com/fairwindsops/charts.git 2>/dev/null || \
   git remote add origin https://github.com/fairwindsops/charts.git) && \
  git fetch origin master 2>&1 || true && \
  CURRENT_BRANCH=\$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo 'HEAD') && \
  if [ \"\$CURRENT_BRANCH\" = 'HEAD' ] || ! git rev-parse --verify \$CURRENT_BRANCH >/dev/null 2>&1; then \
    git update-ref refs/heads/master origin/master 2>/dev/null || true && \
    git symbolic-ref HEAD refs/heads/master 2>/dev/null || true; \
  fi && \
  git reset --hard HEAD 2>/dev/null || true"
