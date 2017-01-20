#! /bin/bash

[[ $# -eq 0 ]] && echo "Please supply a revision number" && exit 1

svn log -c "$@" > tmp.diff
svn_diff.sh -c "$@" >> tmp.diff

cat tmp.diff | less -R

rm tmp.diff
