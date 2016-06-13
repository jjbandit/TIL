#! /bin/bash

function CancelBuild() {
	echo "Cancelling build."
	taskkill.exe /im msbuild.exe /f /t
}


function BuildLastTargets() {
	echo "Running the last build configuration."

	if [ -f ~/.last_build ]; then
		TARGETS=$(cat ~/.last_build)
		echo $TARGETS

	else
		echo "No previous build target found, exiting."
		exit 1

	fi
}

TARGETS=""

TESTER="UnitTester/UnitTester.sln"
ILE="WebSmart ILE Only.sln"
UNICODE="WebSmartUnicode.sln"
ALL="WebSmartAll.sln"


# Run the last build target if we don't pass in an argument
[ $# -lt 1 ] && BuildLastTargets


while [[ $# > 0 ]]
do
	arg="$1"

	case $arg in
		-u|--unicode)
			TARGETS="$UNICODE"
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
		-a|--all)
			TARGETS="$ALL"
			break
			;;
	esac

	shift
done

trap CancelBuild INT

if [ "$TARGETS" = "" ]; then

	echo "No target found, exiting."
	exit 1
fi

echo $TARGETS | tee ~/.last_build

devenv.com $TARGETS /build  | \
tee /dev/tty | \
sed 's/\\/\//g' | \
sed 's/[0-9]>\s*//g' | \
sed 's/c:\/users\/jhughes/\n\n~/g' | \
sed -e "s/error C[0-9]\+:\s*/\\n/"
