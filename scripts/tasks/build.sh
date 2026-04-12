#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/../.." &> /dev/null && pwd)"

cd "$REPO_ROOT"

./panvimdoc.sh \
  --project-name panvimdoc \
  --input-file doc/panvimdoc.md \
  --toc true \
  --description 'Convert Markdown docs to Vimdoc' \
  --title-date-pattern '%Y %B %d' \
  --dedup-subheadings true \
  --demojify false \
  --treesitter true \
  --ignore-rawblocks true \
  --doc-mapping false \
  --doc-mapping-project-name true \
  --shift-heading-level-by 0 \
  --increment-heading-level-by 0
