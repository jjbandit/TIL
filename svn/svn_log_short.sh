#! /bin/bash

LOG=$(svn log --stop-on-copy | \
	grep -A 2 "^r[0-9]\+" | \
	sed -n '1~2p' | \
	cut -d"|" -f 1 | \
	sed 'N;s/\n/- /'
)

echo "$LOG" | \
	sed -e 's/^r[0-9]\+/'$(echo -e "\033[33m")'\0'$(echo -e "\033[37m")'/' | \
	sed -e 's/r/ /'
