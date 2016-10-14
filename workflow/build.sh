#! /bin/bash

function CancelBuild() {
	echo "Cancelling build."
	taskkill.exe /im msbuild.exe /F /t
}


function BuildLastTargets() {
	echo "Running the last build configuration."

	if [ -f ~/.last_build ]; then
		TARGETS=$(cat ~/.last_build)

	else
		echo "No previous build target found, exiting."
		exit 1

	fi
}

TARGETS=""
LAUNCH="N"

TESTER="UnitTester/UnitTester.sln"
ILE="WebSmart ILE Only.sln"
ALL="WebSmartAll.sln"

if [ -f "WebSmartUnicode.sln" ]; then
	UNICODE="WebSmartUnicode.sln"
fi

if [ -f "WebSmart PHP Only.sln" ]; then
	UNICODE="WebSmart PHP Only.sln"
fi

if [ "$UNICODE" == "" ]
then
	echo "Unicode target not found"

	exit 1
fi

while [[ $# > 0 ]]
do
	arg="$1"

	case $arg in
		-l|--launch)
			LAUNCH="Y"
			break
			;;
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

	# Run the last build target if we didn't find one
	BuildLastTargets

	# Something's not right ..
	if [ "$TARGETS" = "" ]; then
		echo "No target found, exiting."
		exit 1
	fi
fi

echo $TARGETS | tee ~/.last_build

devenv.com "$TARGETS" /build  | \
tee /dev/tty | \
sed 's/\\/\//g' | \
sed 's/[0-9]>\s*//g' | \
sed 's/c:\/users\/jhughes/\n\n~/g' | \
sed -e "s/error C[0-9]\+:\s*/\\n/"

if [ $LAUNCH == "Y" ]; then
	echo "Launching $TARGETS"
	devenv.com "$TARGETS" /runexit
fi
