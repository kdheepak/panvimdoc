#!/bin/bash
set -e

pandoc -t $GITHUB_WORKSPACE/scripts/panvimdoc.lua $GITHUB_WORKSPACE/$INPUTS_PANDOC -o $GITHUB_WORKSPACE/$INPUTS_VIMDOC
