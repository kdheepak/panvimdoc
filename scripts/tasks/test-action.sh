#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/../.." &> /dev/null && pwd)"

cd "$REPO_ROOT"

tmpdir="$(mktemp -d)"
image_tag="panvimdoc-action-test-$$"

cleanup() {
  rm -rf "$tmpdir"
  docker image rm -f "$image_tag" >/dev/null 2>&1 || true
}

trap cleanup EXIT

mkdir -p "$tmpdir/doc"
cp tests/fixtures/action/input.md "$tmpdir/input.md"
cp tests/fixtures/action/expected.txt "$tmpdir/expected.txt"

docker build -t "$image_tag" "$REPO_ROOT"
docker run --rm -w /github/workspace -v "$tmpdir:/github/workspace" "$image_tag" \
  --project-name action-smoke \
  --input-file input.md \
  --vim-version 'NVIM v0.8.0' \
  --toc true \
  --description 'Action Test' \
  --title-date-pattern 'ACTION TEST DATE' \
  --dedup-subheadings false \
  --demojify false \
  --treesitter true \
  --ignore-rawblocks true \
  --doc-mapping true \
  --doc-mapping-project-name true \
  --shift-heading-level-by 0 \
  --increment-heading-level-by 0

diff -u "$tmpdir/expected.txt" "$tmpdir/doc/action-smoke.txt"
