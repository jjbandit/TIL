#! /bin/bash

if [ $# -eq 0 ]; then
	svn diff > stash.patch && svn_revert_all.sh
	exit 0
fi

svn patch stash.patch && rm stash.patch
exit 0

