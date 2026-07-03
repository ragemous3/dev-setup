#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
image_name="dev-setup-test-ubuntu"

docker build -f "$repo_root/test/docker/ubuntu.Dockerfile" -t "$image_name" "$repo_root"
docker run --rm \
  -v "$repo_root:/home/tester/dev-setup:ro" \
  "$image_name" \
  bash -lc "printf 'n\nn\nn\nn\ny\ny\nn\nn\n' | ./setup-ubuntu.sh 'Test User' tester@example.com && ./test/verify-login-shell.sh"
