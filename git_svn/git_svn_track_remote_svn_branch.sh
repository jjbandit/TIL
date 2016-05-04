#! /bin/bash

# This recursive function is nessicary because git-svn will occationally die of
# a segfault in perl.. FML. It runs the command, and if it dies unexpectedly
# then just restarts itself.

function gitSvnFetch(){
	git svn fetch "$1" # -r $rev  << This is optional and for some reason breaking.

	[ $? -ne 0 ] && gitSvnFetch "$1" && echo "Retrying..."
}


# http://stackoverflow.com/questions/296975/how-do-i-tell-git-svn-about-a-remote-branch-created-after-i-fetched-the-repo


[ $# -eq 0 ] && echo "Please specify a task number." && exit 1

newbranch=$1

# rev=$(git svn info | grep "Revision" | cut -d " " -f 2)

remote="FS%20$newbranch"

config_remote_url="svn-remote.$newbranch.url"
config_remote_fetch="svn-remote.$newbranch.fetch"

git config -l | grep $config_remote_url

if [ $? -ne 0 ]; then
	git config --add $config_remote_url $SVN_ROOT/branches/$remote
	echo "Added config.url"
fi

git config -l | grep $config_remote_fetch

if [ $? -ne 0 ]; then
	git config --add $config_remote_fetch :refs/remotes/$remote
	echo "Added config.fetch"
fi

# git svn fetch $newbranch # -r $rev  << This is optional and for some reason breaking.
gitSvnFetch "$newbranch"

git checkout -b "$newbranch" "remotes/FS%2520$newbranch"
git svn rebase $newbranch

# This should leave an entry similar to this in your git config:

# [svn-remote "newbranch"]
# 	url: https://svn.path/to/newbranch
# 	fetch: :refs/remotes/newbranch


