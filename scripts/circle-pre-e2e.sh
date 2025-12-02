#!/bin/bash

# Copy the repository to the e2e container
docker cp "$(pwd)" e2e-command-runner:/charts

# Ensure git repository is properly initialized in the container
# This is needed for ct list-changed to work properly
docker exec e2e-command-runner sh -c "cd /charts && \
  git config --global --add safe.directory /charts && \
  git remote set-url origin https://github.com/fairwindsops/charts.git 2>/dev/null || \
  git remote add origin https://github.com/fairwindsops/charts.git && \
  git fetch origin master || true"
