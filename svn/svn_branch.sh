#! /bin/bash

[ $# -eq 0 ] && echo "Please pass at least a target branch number" && exit 1

# 
BranchNumber=$1

# The target we're branching from defaults to trunk, or the second parameter passed in
if [ "$2" == "trunk" ]; then
	BranchFrom="trunk"

else
	if [ "$2" == "" ]; then
		BranchFrom="trunk"
	else

		BranchFrom="branches/FS $2"
	fi
fi

echo $BranchFrom
echo $BranchNumber



SvnBaseUrl=$(svn info | grep --color=never ^URL: | grep --color=never "[^ ]*svn[^ ]*/" -o)


FromUrl="$SvnBaseUrl$BranchFrom"

TargetUrl="$SvnBaseUrl""branches/FS $BranchNumber"

# Check if branch exists
svn ls "$TargetUrl" 2>&1> /dev/null

# Create remote branch if it doesn't exist
if [ $? -ne 0 ]; then

	echo "Creating branch!"
	svn copy "$FromUrl" "$TargetUrl" -m "Checkout for FS $BranchNumber"
else

	echo "Branch exists, aborting."
fi
