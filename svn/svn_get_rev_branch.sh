#! /bin/bash

[[ $# -eq 0 ]] && echo "Please supply a revision number" && exit 1

REPO_ROOT=$(svn info | grep "Repository Root" | grep -o "http.*$")

svn log -v -q -l 1 $REPO_ROOT -c "$@"
