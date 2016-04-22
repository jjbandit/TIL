#! /bin/bash

# Wrapper that will create a SVN branch and a git one at the same time.

function printHelp() {
	echo "  -----------------------------------------------------"
	echo ""
	echo "  Usage: gs_new_task.sh <Task ID>"
	echo ""
	echo "    Required: Arg 1 specifies the Flyspray ID of the task."
	echo ""
	echo "  -----------------------------------------------------"

	exit 0
}

[ "$#" -eq 0 ] && printHelp

[ "$1" = "-h" ] && printHelp

isGitRepo=$(git rev-parse --is-inside-work-tree > /dev/null 2>&1)
[ $? -ne 0 ] && echo "Not inside a git repo, exiting." && exit 1


powershell svn_branch "$1"
~/til/git_svn/git_svn_track_remote_svn_branch.sh "$1" > /dev/null
