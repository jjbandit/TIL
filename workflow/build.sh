#! /bin/bash

function CancelBuild() {
	echo "Cancelling build."
	taskkill.exe /im msbuild.exe /F /T
}


function BuildLastTargets() {
	echo "Running the last build configuration."

	if [ -f ~/.last_build ]; then
		BuildTargets=$(cat ~/.last_build)

	else
		echo "No previous build target found, exiting."
		exit 1

	fi
}

BuildTargets=""
SlnPath="./"
LAUNCH=0

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
	echo "$#"
	echo "$arg"

	case $arg in
		-l|--launch)
			LAUNCH=1
			;;
		-u|--unicode)
			BuildTargets="$UNICODE"
			;;
		-t|--tests)
			BuildTargets="$TESTER"
			;;
		-i|--ile)
			BuildTargets="$ILE"
			;;
		-a|--all)
			BuildTargets="$ALL"
			;;
		*)
			SlnPath="$arg"
			;;
	esac

	shift
done

echo "Done Parsing args"

trap CancelBuild INT

if [ "$BuildTargets" = "" ]; then

	# Run the last build target if we didn't find one
	BuildLastTargets

	if [ "$BuildTargets" = "" ]; then # Something's not right ..
		echo "No target found, exiting."
		exit 1
	fi
fi

echo $BuildTargets > ~/.last_build

FullBuildPath="$SlnPath/$BuildTargets"

echo "Building $FullBuildPath"

devenv.com "$FullBuildPath" /build  | \
tee /dev/tty | \
sed 's/\\/\//g' | \
sed 's/[0-9]>\s*//g' | \
sed 's/c:\/users\/jhughes/\n\n~/g' | \
sed -e "s/error C[0-9]\+:\s*/\\n/"

if [ $LAUNCH == 1 ]; then
	echo "Launching $BuildTargets"
	devenv.com "$FullBuildPath"
fi
