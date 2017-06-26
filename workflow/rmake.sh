#! /bin/bash




WC=xxxxx

#SOURCE_DIR="C:/users/jhughes/nexus/trunk/Development#PDWs"
 SOURCE_DIR="C:/users/jhughes/nexus/$WC/Server#Source"

  # $SOURCE_DIR/router/main.cpp
  # $SOURCE_DIR/NxDocTree.cpp
  # $SOURCE_DIR/nxds/ds_edit.cpp
  # $SOURCE_DIR/nxds/ds_header.cpp
  # $SOURCE_DIR/nxds/ds_parse.cpp
  # $SOURCE_DIR/nxds/ds_search.cpp
  # $SOURCE_DIR/nxds/ds_xref.cpp
  # $SOURCE_DIR/MainPage.cpp
  # $SOURCE_DIR/brdcrmb.cpp
  # $SOURCE_DIR/ecmsearch.cpp
  # $SOURCE_DIR/login.cpp
  # $SOURCE_DIR/menu.cpp
  # $SOURCE_DIR/nxmenu.cpp
  # $SOURCE_DIR/optionsmenu.cpp
  # $SOURCE_DIR/pagetester.cpp
  # $SOURCE_DIR/purge.cpp


FILES="
  $SOURCE_DIR/router/main.cpp
"

# FILES="
#   $SOURCE_DIR/ecmsearch.cpp
# "







function DumpJobLogErrors()
{
  LinesOfContext=8
  JobLogPath="$1"

  # Errors=$(cat "$JOB_LOG" | grep -P --color=always "(\".*\"|\'.*\')" -C $LinesOfContext )
  Errors=$(cat "$JOB_LOG" | grep -P --color=always "(\".*\"|Not authorized)" -C $LinesOfContext )
  [ "$Errors" == "" ] && Errors=$(cat "$JOB_LOG" | grep -P --color=always "Library.*not found." -C $LinesOfContext )
  [ "$Errors" == "" ] && Errors=$(cat "$JOB_LOG" | grep -P --color=always "\s+Message.*$" -C $LinesOfContext )
  [ "$Errors" == "" ] && Errors=$(cat "$JOB_LOG" | grep -P --color=always "(Insufficient authorization|Not authorized)" -C $LinesOfContext )

  echo "$Errors"
}

PROGRAM=~/ws/extended/websmart/remote_compiler/Program
TEMP=$PROGRAM/Temp

COMPILE_LISTING="$TEMP/Compile Listing.txt"
JOB_LOG="$TEMP/Job Log.txt"
TRACEFILE="$PROGRAM/WebSmart Trace.txt"

CompileErrors=0

COMPILE_TOKENS="
PDF='MAIN'
{
  TOKENS='*'
  {
    LIB='NX$(svn_current_branch.sh | sed 's/trunk/_TRK/')';
  }
}
"

echo "$COMPILE_TOKENS" > "/home/jhughes/nexus/$WC/Server Source/compile_tokens.txt"
echo "$COMPILE_TOKENS" > "/home/jhughes/nexus/$WC/Server Source/router/compile_tokens.txt"
echo "$COMPILE_TOKENS" > "/home/jhughes/nexus/$WC/Server Source/nxds/compile_tokens.txt"


for File in $FILES
do

  File=$(echo $File | sed 's/#/ /g')

  [ -e "$TRACEFILE" ]       && echo " - Status - Removing old Trace File"       && rm "$TRACEFILE"
  [ -e "$COMPILE_LISTING" ] && echo " - Status - Removing old Compile Listing" && rm "$COMPILE_LISTING"
  [ -e "$JOB_LOG" ]         && echo " - Status - Removing old Job Log"         && rm "$JOB_LOG"

  $PROGRAM/UnitTester.exe \
    -cc "$File"

  echo " - Status - Websmart exitd with code $?"

  Success=0

  [ -e "$COMPILE_LISTING" ] && echo " - Status - Got Compile Listing $COMPILE_LISTING" && Success=1 # ..?
  [ -e "$JOB_LOG" ]         && echo " - Status - Got Job Log $JOB_LOG"                 && Success=1


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
