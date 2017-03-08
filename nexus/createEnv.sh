#! /bin/bash

# This emulates the weird-ass createEnv stuff in one layer instead of 4

[ $# -eq 0 ] && echo "Please provide a branch number, exiting." && exit 1

DOWNLOAD_TXT=$(ack.cmd -gi download.txt)
WS_SVN_CONFIG_TXT="Development PDWs/ws_svn_config.txt"

echo "$DOWNLOAD_TXT"
echo "$WS_SVN_CONFIG_TXT"

function ReplaceNexusBranch()
{
  FILE="$1"
  cat "$FILE" | perl -pe 's/NX[0-9]{5}/NX'"$BRANCH_NUMBER"'/g' > tmp && mv tmp "$FILE"
  cat "$FILE" | perl -pe 's/nexus_trunk/nexus_dev\\\\NX'"$BRANCH_NUMBER"'/g' > tmp && mv tmp "$FILE"

}


BRANCH_NUMBER="$1"
WEBPATH="8099/NX$BRANCH_NUMBER/nexus/"
SOURCELIB="NX$BRANCH_NUMBER"
PROJECT="Nexus FS $BRANCH_NUMBER"
IFS_PATH="dev"
SET="*DEV"

if [ "$BRANCH_NUMBER" == "trunk" ]; then
  BRANCH_NUMBER="_TRK"
  WEBPATH="8100/nexus/"
  SOURCELIB="NX_TRK_SRC"
  PROJECT="Nexus Trunk"
  IFS_PATH="trunk"
  SET="*PROD"
fi

# Replace ws_svn_config.txt with the new branch info
echo "SVN='*'
{
        OBJLIBRARY='NX$BRANCH_NUMBER';
        SOURCEFILE='QPDWSRC';
        SOURCELIBR='$SOURCELIB';
        WEBPATH='http://dev.excelsystems.com:$WEBPATH';
        TARGETPATH='http://dev.excelsystems.com:$WEBPATH';
        COMPLIBLOBJ='*OBJLIBNAM';
        PROJECT='$PROJECT';
        SET='$SET';
}" > "$WS_SVN_CONFIG_TXT" && unix2dos.exe "$WS_SVN_CONFIG_TXT"

# Update any download.txt files we might encounter
echo "$DOWNLOAD_TXT" |  while read -r file; do
  ReplaceNexusBranch "$file"

  if [ "$BRANCH_NUMBER" == "_TRK" ]; then
    cat ~/til/nexus/trunk_download.txt > "$file"
  fi

  unix2dos.exe "$file"
done

