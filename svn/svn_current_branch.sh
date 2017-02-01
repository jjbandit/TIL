#! /bin/bash

URL=$(svn info | grep --color=never -P "^URL:" | sed 's/%20/ /g' )

BranchType=$(echo "$URL" | grep --color=never -Po "(\d{5}|trunk|sprints)")


case "$BranchType" in

	"sprints") echo $(echo "$URL" | grep --color=never -Po "(sprints).*$" | cut -d"/" -f 2) ;;

	"trunk") echo "trunk" ;;

	[0-9]*) echo "$BranchType" ;;

	*)
		echo ""
		;;

esac
