#! /bin/bash

if [[ $# -eq 0 ]]; then
	echo "Please provide a valid task number, exiting"
	exit 1
fi

branch_path=^/websmart/branches/FS\ $1

from_rev=$(svn log --stop-on-copy "$branch_path" | grep -P "^r\d\d+" | cut -d" " -f 1 | tail -n 1 | sed 's/r//')

echo "From: $from_rev"

trunk_head=$(svn info ^/websmart/trunk | grep "Revision" | cut -d" " -f2)

echo "Trunk is at: $trunk_head"

svn merge -r$from_rev:$trunk_head "$branch_path"
