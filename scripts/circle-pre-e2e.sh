#!/bin/bash

# Ensure git remote and master branch are available for ct list-changed
git remote add ro https://github.com/fairwindsops/charts || true
git fetch ro master

docker cp "$(pwd)" e2e-command-runner:/charts
