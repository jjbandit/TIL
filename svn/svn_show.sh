#! /bin/bash

[[ $# -eq 0 ]] && echo "Please supply a revision number" && exit 1

svn_diff.sh -c "$@"
