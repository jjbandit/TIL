#! /bin/bash

LOG=$(svn log --stop-on-copy -l 40 \
	| grep -A 2 "^r[0-9]\+" \
	| sed -n '1~2p' \
)

REV=$(echo "$LOG" \
	| cut -d"|" -f 1 \
	| sed -n '1~2p' \
	| sed -e 's/.*/ '$(echo -e "\033[33m")'\0'$(echo -e "\033[37m")'/'
)

USER=$(echo "$LOG" \
	| cut -d"|" -f 2 \
	| sed -n '1~2p' \
	| sed -e 's/.*/ '$(echo -e "\033[32m")'\0'$(echo -e "\033[37m")'	/'
)

MESSAGE=$(echo "$LOG" \
	| sed -n '0~2p'
)

echo -e "$REV"      > .rev
echo -e "$USER"     > .user
echo -e "$MESSAGE"  > .message

paste -d " " .rev .user .message
