#! /bin/bash

[ $# -eq 0 ] && echo "Please supply a revision to revert to. Exiting." && exit 1

REV="$( echo "$1" | sed 's/r//g')"
HEAD=$(svn info | grep "Revision" | cut -d" " -f2)

svn merge -r$HEAD:$REV .
