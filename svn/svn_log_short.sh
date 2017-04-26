#! /bin/bash

LOG_LENGTH=20

svn info > /dev/null 2>&1
[ $? -ne 0 ] && echo "Not a valid svn working copy, exiting" && exit 1

RemainingArgs=""

while [[ $# > 0 ]]
do
  arg="$1"

  case $arg in
    [0-9]*)
      BranchNumber="$arg"
      ;;
    *)
      RemainingArgs="$RemainingArgs $arg"
      ;;
  esac

  shift
done

if [ -z "$BranchNumber" ]; then
  BranchNumber="$(svn_current_branch.sh)"
fi


SvnTarget=$(svn info | grep --color=never -P "^URL:" | grep --color=never -Po "(sprints|trunk|tags)")


SvnWcBaseUrl=$(svn_wc_base_url.sh)

if [ "$SvnTarget" == "trunk" ]; then
	TargetUrl="$SvnWcBaseUrl/trunk"

else
		if [ "$SvnTarget" == "sprints" ]; then
		TargetUrl="$SvnWcBaseUrl/$BranchNumber"

		else
			if [ "$SvnTarget" == "tags" ]; then
				TargetUrl="$SvnWcBaseUrl/$BranchNumber"

			else
				TargetUrl="$SvnWcBaseUrl/branches/FS%20$BranchNumber"
			fi

		fi
fi

# echo " Logging Url : $TargetUrl "

# The fucking SVN parser is too dumb to figure out what I'm passing it when
# it's multiple variables, so echo the arguments as a single string. Goddamn..
LogCmd=$( echo "$RemainingArgs -l $LOG_LENGTH $TargetUrl")

LOG=$(svn log $LogCmd     \
	| grep -A 2 "^r[0-9]\+" \
	| sed -n '1~2p' \
)

TASK=$(svn log $LogCmd   \
	| grep -Po "Task: \d+" \
	| cut -d" " -f 2
	)

REV=$(echo "$LOG" \
	| cut -d"|" -f 1 \
	| sed -n '1~2p' \
	| sed 's/^\s*//g' \
	| sed 's/\s*$//g'
)

USER=$(echo "$LOG" \
	| cut -d"|" -f 2 \
	| sed -n '1~2p' \
	| sed 's/^\s*//g' \
	| sed 's/\s*$//g'
)

MESSAGE=$(echo "$LOG" \
	| sed -n '0~2p'
)

if [ "$1" != "--nocolor" ]; then
	REV=$( echo "$REV" \
		| sed -e 's/.*/ '$(echo -e "\033[33m")'\0'$(echo -e "\033[37m")'/'
	)

	USER=$(echo "$USER" \
	| sed -e 's/.*/ '$(echo -e "\033[32m")'\0'$(echo -e "\033[37m")'	/'
	)

	TASK=$(echo "$TASK" \
	| sed -e 's/.*/ '$(echo -e "\033[32m")'\0'$(echo -e "\033[37m")'	/'
	)

fi

# echo -e "$TASK"     > .task
echo -e "$REV"      > .rev
echo -e "$USER"     > .user
echo -e "$MESSAGE"  > .message

# paste -d " " .task .rev .user .message \
paste -d " " .rev .user .message \
	| sed 's/\s\{2,\}/  |  /g'

# rm .task
rm .rev .user .message
