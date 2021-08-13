#!/bin/bash
set -e

pandoc --metadata=project:$1 --lua-filter scripts/include-files.lua -t scripts/panvimdoc.lua $2 -o $1.txt
