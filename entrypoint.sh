#!/bin/bash
set -e

pandoc -t scripts/panvimdoc.lua $INPUTS_MARKDOWN -o $INPUTS_VIMDOC
