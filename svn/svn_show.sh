#! /bin/bash

# SVN doesn't have built-in diff highlighting, so hack it on

[[ $# -eq 0 ]] && echo "Please supply a revision number" && exit 1

svn diff -c "$1" | diff-so-fancy | less -R
