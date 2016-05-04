#! /bin/bash

[ $# = 0 ] && echo "Please pass a revision" && exit 1

svn merge -r $(head_rev.sh):$1 .
