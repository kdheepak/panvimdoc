#!/bin/bash
set -e

pandoc -t scripts/panvimdoc.lua $INPUTS_PANDOC -o $INPUTS_VIMDOC
