#! /bin/bash

function DumpJobLogErrors()
{
	LinesOfContext=4
	JobLogPath="$1"

	Errors=$(cat "$JOB_LOG" | grep -P --color=always "(\".*\"|\'.*\')" -C $LinesOfContext )
	[ $? -ne 0 ] && Errors=$(cat "$JOB_LOG" | grep -P --color=always "\s+Message.*$" -C $LinesOfContext )

	echo "$Errors"
}

PROGRAM=~/websmart/svn/extended/websmart/remote_compiler/Program
TEMP=$PROGRAM/Temp

COMPILE_LISTING="$TEMP/Compile Listing.txt"
JOB_LOG="$TEMP/Job Log.txt"
TRACEFILE="$PROGRAM/WebSmart Trace.txt"

CompileErrors=0

# SOURCE_DIR="C:/users/jhughes/nexus/trunk/Server#Source"
SOURCE_DIR="C:/users/jhughes/nexus/trunk/Development#PDWs"

FILES="
	$SOURCE_DIR/nxdocsrch.pdw
"

COMPILE_TOKENS="
PDF='MAIN'
{
	TOKENS='*'
	{
		LIB='NX$(svn_current_branch.sh)';
	}
}
"


echo "$COMPILE_TOKENS" > '/home/jhughes/nexus/trunk/Server Source/compile_tokens.txt'
echo "$COMPILE_TOKENS" > '/home/jhughes/nexus/trunk/Server Source/router/compile_tokens.txt'


for File in $FILES
do

	File=$(echo $File | sed 's/#/ /g')

	[ -e "$TRACEFILE" ]       && echo " - Status - Removing old Trace File"       && rm "$TRACEFILE"
	[ -e "$COMPILE_LISTING" ] && echo " - Status - Removing old Compile Listing" && rm "$COMPILE_LISTING"
	[ -e "$JOB_LOG" ]         && echo " - Status - Removing old Job Log"         && rm "$JOB_LOG"

	$PROGRAM/UnitTester.exe \
		-cp "$File"

	echo " - Status - Websmart exitd with code $?"

	Success=0

	[ -e "$COMPILE_LISTING" ] && echo " - Status - Got Compile Listing" && Success=1 # ..?
	[ -e "$JOB_LOG" ]         && echo " - Status - Got Job Log"         && Success=1


	if [ $Success == 0 ]; then
		echo " - Status - Compile Success"

	else
		[ -e "$TRACEFILE" ]       && cat "$TRACEFILE"
		[ -e "$COMPILE_LISTING" ] && cat "$COMPILE_LISTING"
		[ -e "$JOB_LOG" ]         && DumpJobLogErrors "$JOB_LOG"

		echo " - Status - Compile Failed"
	fi

done

exit $Success
