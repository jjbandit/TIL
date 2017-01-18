#! /bin/bash

. ~/til/svn/svn_wc_base_url.sh

[ $# -eq 0 ] && echo "Please pass at least a target branch number" && exit 1

svn info > /dev/null 2>&1
[ $? -ne 0 ] && echo "Not a valid svn working copy, exiting" && exit 1

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

# This sets a variable called SvnWcBaseUrl
GetWcBaseUrl

FromUrl="$SvnWcBaseUrl/$BranchFrom"

TargetUrl="$SvnWcBaseUrl/branches/FS $BranchNumber"

# Check if branch exists
svn ls "$TargetUrl" > /dev/null 2>&1

# Create remote branch if it doesn't exist
if [ $? -ne 0 ]; then

	echo "Creating branch!"
	svn copy "$FromUrl" "$TargetUrl" -m "Checkout for FS $BranchNumber"
else

	echo "Branch exists, aborting."
fi
