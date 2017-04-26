#! /bin/bash

TRUE=0

[[ $# -eq 0 ]] && echo "Please supply a revision number" && exit 1

echo "$@" | grep -o ":" > /dev/null
IS_RANGE=$?

LOG_FLAG="-c"

if [ "$IS_RANGE" == "$TRUE" ]; then
  LOG_FLAG="-r"
fi

svn log $LOG_FLAG "$@" > tmp.diff
svn_diff.sh $LOG_FLAG "$@" >> tmp.diff

cat tmp.diff | less -R

rm tmp.diff
