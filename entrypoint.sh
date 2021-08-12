#!/bin/bash
set -e

pandoc --lua-filter scripts/include-files.lua -t scripts/panvimdoc.lua $1 -o $2
