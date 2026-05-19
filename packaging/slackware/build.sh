#!/usr/bin/env bash
#
# Convenience wrapper: build the Slackware/unRAID .txz inside Docker.
# Resulting package lands in ./dist/ at the repo root.

set -euo pipefail

REPO_ROOT=$(cd "$(dirname "$0")/../.." && pwd)
IMAGE=${IMAGE:-ipmitool-slackbuild}
PLATFORM=${PLATFORM:-linux/amd64}
DIST=$REPO_ROOT/dist

mkdir -p "$DIST"

echo "==> Building image $IMAGE ($PLATFORM)"
docker build --platform "$PLATFORM" -t "$IMAGE" \
    -f "$REPO_ROOT/packaging/slackware/Dockerfile" "$REPO_ROOT"

echo "==> Running SlackBuild (output -> $DIST)"
docker run --rm --platform "$PLATFORM" -v "$DIST:/out" "$IMAGE"

echo
echo "==> Built:"
ls -lh "$DIST"/*.txz
