#! /bin/bash

if [ -z "$1" ]; then
	BranchNumber=$(svn_current_branch.sh)
else
	BranchNumber="$1"
fi

if [ -e ./.tmp_commit ]; then
	echo 'Recovering from .tmp_commit'
else

	# Write some preformatted text out to a fresh commit file
echo "

Task: $BranchNumber

### This line, and those below, will be removed by my preprocessor ###

$( svn di )
" > ./.tmp_commit


fi

# Get some user input
vim ./.tmp_commit

Message=$( cat ./.tmp_commit )
TaskKeywordCount=$( echo "$Message" | grep "Task" | wc -c )
FirstLineCharCount=$( echo "$Message" | head -n 1 | wc -c )

if [ $FirstLineCharCount -gt 1 ]; then
	echo "Message Line Count validated!!"
else
	echo "You need to enter a commit message"
	rm ./.tmp_commit
	exit 1
fi

if [ $TaskKeywordCount -gt 1 ]; then
	echo "Task Keyword Validated!"
else
	echo "You need to enter a task number"
	exit 1
fi

# Delete temp commit text
sed -i '/###.*###$/,$d' ./.tmp_commit

echo "Committing"
echo " -----------------------------------------------------------------------"
cat ./.tmp_commit
echo " -----------------------------------------------------------------------"

svn commit -F ./.tmp_commit && svn update

if [ $? -eq 0 ]; then  # commit went well
	rm ./.tmp_commit  # cleanup our temp file
else
	echo "Something went wrong while committing, aborting"
	echo "Run svn_commit.sh to retry with the same temp file"
	exit 1
fi

exit 0
