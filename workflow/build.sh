#! /bin/bash

# By default just build Websmart
if [ $# -eq 0 ]; then
	devenv.com "UnitTester/UnitTester.sln" /build  | \
	tee /dev/tty | \
	sed 's/\\/\//g' | \
	sed 's/[0-9]>\s*//g' | \
	sed 's/c:\/users\/jhughes/\n\n~/g' | \
	sed -e "s/error C[0-9]\+:\s*/\\n/"
fi
