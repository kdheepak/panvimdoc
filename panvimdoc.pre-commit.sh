#!/usr/bin/env bash
args=$#                          # number of command line args
for (( i=1; i<=$args; i+=2 ))    # loop from 1 to N (where N is number of args)
do
    j=$((i + 1 ))
    if [ "${!i}" == "--project-name" ] ; then
        PROJECT_NAME="${!j}"
        break;
    fi
done

# extract project name to determine file location
if [ -z "$PROJECT_NAME" ]; then
    echo "Error: argument --project-name is not set."
    exit 1
fi
# store hash to check whether documentation has changed
if [ -f "doc/$PROJECT_NAME.txt" ]; then
    DOC_HASH_PRE="$(md5sum doc/$PROJECT_NAME.txt)"
else
    DOC_HASH_PRE=""
fi
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source "$SCRIPT_DIR/panvimdoc.sh"
DOC_HASH_POST="$(md5sum doc/$PROJECT_NAME.txt)"
# send FAIL when doc has changed
if [ "$DOC_HASH_PRE" != "$DOC_HASH_POST" ] ; then
    echo ""
    echo 'Updated documentation "doc/$PROJECT_NAME.txt"'
    echo 'Use "git add doc/$PROJECT_NAME.txt" to stage the changes'
    exit 1
fi
