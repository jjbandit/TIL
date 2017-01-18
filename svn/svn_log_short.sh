#! /bin/bash

svn info > /dev/null 2>&1
[ $? -ne 0 ] && echo "Not a valid svn working copy, exiting" && exit 1

. ~/til/svn/svn_wc_base_url.sh

if [ $# -eq 0 ]; then
	BranchNumber="$(svn_current_branch.sh)"
else
	BranchNumber="$1"
	shift
fi

# This sets a variable called SvnWcBaseUrl
GetWcBaseUrl

if [ $BranchNumber = "trunk" ]; then
	TargetUrl="$SvnWcBaseUrl/trunk"

else
	TargetUrl="$SvnWcBaseUrl/branches/FS%20$BranchNumber"
fi


echo "$TargetUrl"

LOG=$(svn log --stop-on-copy -l 40 $TargetUrl "$@" \
	| grep -A 2 "^r[0-9]\+" \
	| sed -n '1~2p' \
)

REV=$(echo "$LOG" \
	| cut -d"|" -f 1 \
	| sed -n '1~2p' \
	| sed 's/^\s*//g' \
	| sed 's/\s*$//g'
)

USER=$(echo "$LOG" \
	| cut -d"|" -f 2 \
	| sed -n '1~2p' \
	| sed 's/^\s*//g' \
	| sed 's/\s*$//g'
)

MESSAGE=$(echo "$LOG" \
	| sed -n '0~2p'
)

if [ "$1" != "--nocolor" ]; then
	REV=$( echo "$REV" \
		| sed -e 's/.*/ '$(echo -e "\033[33m")'\0'$(echo -e "\033[37m")'/'
	)

	USER=$(echo "$USER" \
	| sed -e 's/.*/ '$(echo -e "\033[32m")'\0'$(echo -e "\033[37m")'	/'
	)
fi

echo -e "$REV"      > .rev
echo -e "$USER"     > .user
echo -e "$MESSAGE"  > .message

paste -d " " .rev .user .message \
	| sed 's/\s\{2,\}/  |  /g'
