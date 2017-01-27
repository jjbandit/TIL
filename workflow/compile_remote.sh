#! /bin/bash

#! /bin/bash

PROGRAM=D:/websmart/svn/remote_compiler/Program
TEMP=$PROGRAM/Temp

COMPILE_LISTING="$TEMP/Compile Listing.txt"
JOB_LOG="$TEMP/Job Log.txt"
TRACE_FILE="$PROGRAM/WebSmart Trace.txt"

[ -f "$TRACE_FILE" ]      && echo " - Removing old Trace file"      && rm "$TRACE_FILE"
[ -f "$COMPILE_LISTING" ] && echo " - Removing old Compile Listing" && rm "$COMPILE_LISTING"
[ -f "$JOB_LOG" ]         && echo " - Removing old Job Log"         && rm "$JOB_LOG"

# If only ...
# tail -f $TRACE_FILE

# or even ..
# powershell -Command "& { Get-Content '$(echo $TRACE_FILE)' -Wait }" &

# Feed this a well formatted "windows" path (containing C:\ ... )
$PROGRAM/UnitTester.exe "$@"

Success=0

if [ -f "$COMPILE_LISTING" ]; then
	echo " - Got Compile Listing :"
	cat "$COMPILE_LISTING"
	Success=1
fi

if [ -f "$JOB_LOG" ]; then
	echo " - Got Job Log :"
	cat "$JOB_LOG" | grep --color=always "\".*\"" -C 5
	Success=1
fi
if [ $Success == 0 ]; then
	echo " - Compile Success"
	exit 0
else
	echo " - Compile Failed"
	if [ -f "$TRACE_FILE" ]; then
		echo " - Trace File"
		cat "$TRACE_FILE"
	fi

	exit 1
fi
