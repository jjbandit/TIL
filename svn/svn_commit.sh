#! /bin/bash

echo "" > ./svn-commit.tmp
echo "" >> ./svn-commit.tmp
echo "Task: $(svn_current_branch.sh)" >> ./svn-commit.tmp

vim ./svn-commit.tmp

Message=$( cat ./svn-commit.tmp )
TaskKeywordCount=$( echo "$Message" | grep "Task" | wc -c )

FirstLineCharCount=$( echo "$Message" | head -n 1 | wc -c )

if [ $FirstLineCharCount -gt 1 ]; then
	echo "Message Line Count validated!!"
else
	echo "You need to enter a commit message"
	exit 1
fi

if [ $TaskKeywordCount -gt 1 ]; then
	echo "Task Keyword Validated!"
else
	echo "You need to enter a task number"
	exit 1
fi

echo "Committing"
svn commit -F ./svn-commit.tmp
