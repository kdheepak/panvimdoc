#!/bin/bash
set -e

ARGS=(
"--metadata=project:$1"
"--metadata=vimversion:$3"
"--metadata=toc:$4"
"--metadata=description:$5"
"--metadata=dedupsubheadings:$6"
"--metadata=treesitter:$7"
"--lua-filter=/scripts/skip-blocks.lua"
"--lua-filter=/scripts/include-files.lua"
)

if [ "$6" = "true" ]; then
  ARGS+=(
  "--lua-filter=/scripts/remove-emojis.lua"
  )
fi

ARGS+=(
"-t"
"/scripts/panvimdoc.lua"
)

echo pandoc "${ARGS[@]}" "$2" -o "doc/$1.txt"
pandoc "${ARGS[@]}" "$2" -o "doc/$1.txt"
