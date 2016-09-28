#! /bin/bash

# Write some preformatted text out to the commit file
echo "


Task: $(svn_current_branch.sh)

# Lines beginning with '#' will be removed by my preprocessor
#
$(svn di --summarize | sed "s/.*/#   &/")" > ./svn-commit.tmp


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

# Strip the comment lines
sed -i "/^#.*/ d" ./svn-commit.tmp

echo "Committing"
echo "----"
cat ./svn-commit.tmp
echo "----"

svn commit -F ./svn-commit.tmp
