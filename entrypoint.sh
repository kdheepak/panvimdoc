#!/bin/bash
set -e

pandoc -t $GITHUB_WORKSPACE/scripts/panvimdoc.lua $1 -o $2
