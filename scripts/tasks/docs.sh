#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/../.." &> /dev/null && pwd)"

cd "$REPO_ROOT"

pandoc \
  --katex \
  --from markdown+tex_math_single_backslash \
  --to html5+smart \
  --template=./scripts/template.html5 \
  --css=/panvimdoc/css/theme.css \
  --css=/panvimdoc/css/skylighting-solarized-theme.css \
  --toc \
  --wrap=none \
  --metadata title=panvimdoc \
  doc/panvimdoc.md \
  --lua-filter=scripts/include-files.lua \
  --lua-filter=scripts/skip-blocks.lua \
  -t html \
  -o public/index.html
