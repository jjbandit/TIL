#! /bin/bash

# Merge arbitrary branch number to the working copy at PWD

if [[ $# -eq 0 ]]; then
	echo "Please provide a valid task number, exiting"
	exit 1
fi

project=$(svn info | grep --color=never Relative | grep -o "\^/\w*\?/" | sed 's/[/^]//g')

branch_path=^/$project/branches/FS\ $1

from_rev=$(svn log --stop-on-copy "$branch_path" | grep -P "^r\d\d+" | cut -d" " -f 1 | tail -n 1 | sed 's/r//')

echo "From: $branch_path@$from_rev"

wc_head=$(svn info | grep "Revision" | cut -d" " -f2)

echo "Working Copy is at: $wc_head"

svn merge --ignore-ancestry -r$from_rev:$wc_head "$branch_path" && svn_commit.sh $1
