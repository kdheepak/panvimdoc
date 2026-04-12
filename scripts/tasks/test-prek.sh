#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/../.." &> /dev/null && pwd)"

cd "$REPO_ROOT"

mkdir -p /tmp/prek-home
PREK_HOME=/tmp/prek-home prek validate-manifest .pre-commit-hooks.yaml

tmpdir="$(mktemp -d)"

cleanup() {
  rm -rf "$tmpdir"
}

trap cleanup EXIT

git -C "$tmpdir" init -q
mkdir -p "$tmpdir/doc"
printf '# sample\n' > "$tmpdir/README.md"
git -C "$tmpdir" add README.md

cat > "$tmpdir/.pre-commit-config.yaml" <<EOF
repos:
- repo: local
  hooks:
  - id: panvimdoc-local
    name: panvimdoc local
    entry: ${REPO_ROOT}/panvimdoc.pre-commit.sh
    language: system
    files: ^README\\.md$
    args:
      - --project-name
      - sample
      - --input-file
      - README.md
      - --scripts-dir
      - ${REPO_ROOT}/scripts
    pass_filenames: false
EOF

(
  cd "$tmpdir"
  "$REPO_ROOT/panvimdoc.sh" --project-name sample --input-file README.md --scripts-dir "$REPO_ROOT/scripts" >/dev/null
)

PREK_HOME=/tmp/prek-home PREK_COLOR=never prek run --config "$tmpdir/.pre-commit-config.yaml" --all-files -C "$tmpdir"

printf '\nMore text\n' >> "$tmpdir/README.md"

if PREK_HOME=/tmp/prek-home PREK_COLOR=never prek run --config "$tmpdir/.pre-commit-config.yaml" --all-files -C "$tmpdir"; then
  echo "expected prek to fail when generated documentation is stale"
  exit 1
fi

rg -q 'More text' "$tmpdir/doc/sample.txt"
