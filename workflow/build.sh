#! /bin/bash

TARGETS=

while [[ $# > 0 ]]
do 
	arg="$1"

	case $arg in
		-u|--tests-unicode)
			TARGETS="$TESTER_U"
			break
			;;
		-t|--tests)
			TARGETS="$TESTER"
			break
			;;
		-i|--ile)
			TARGETS="$ILE"
			break
			;;
		-p|--php)
			TARGETS="$PHP"
			break
			;;
		-a|--all)
			TARGETS="$TESTER_U $TESTER $PHP $ILE"
			break
			;;
	esac

	shift
done

trap CancelBuild INT

function CancelBuild() {
	echo "Cancelling build."
	taskkill.exe /im msbuild.exe /f /t
}

# By default just build Websmart
if [ $# -eq 0 ]; then
	devenv.com "WebsmartAll.sln" /build  | \
	tee /dev/tty | \
	sed 's/\\/\//g' | \
	sed 's/[0-9]>\s*//g' | \
	sed 's/c:\/users\/jhughes/\n\n~/g' | \
	sed -e "s/error C[0-9]\+:\s*/\\n/"
fi
