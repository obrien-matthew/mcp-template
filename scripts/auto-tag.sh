#!/usr/bin/env bash
set -euo pipefail

# Skip if HEAD is already tagged
if git describe --exact-match HEAD &>/dev/null; then
    echo "HEAD already tagged ($(git describe --exact-match HEAD)), skipping."
    exit 0
fi

# Get latest tag, default to v0.0.0 if none exist
latest=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")

# Parse major.minor.patch
version="${latest#v}"
IFS='.' read -r major minor patch <<< "$version"

# Bump patch
patch=$((patch + 1))
new_tag="v${major}.${minor}.${patch}"

git tag "$new_tag"
echo "Tagged $new_tag (was $latest)"
