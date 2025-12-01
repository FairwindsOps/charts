#!/bin/bash

# Ensure git remote and master branch are available for ct list-changed
# Unshallow if needed and fetch master branch
git fetch --unshallow origin master 2>/dev/null || git fetch origin master

docker cp "$(pwd)" e2e-command-runner:/charts
