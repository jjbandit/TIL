#! /bin/bash

[ $# -eq 0 ] && echo "Please pass me a task title, exiting." && exit 1

if [ $1 = "-h" ]; then 
	echo "  -----------------------------------------------------"
	echo ""
	echo "  Usage: new_task.sh <Title> [Description] [Parent ID]"
	echo ""
	echo "    Required: Arg 1 specifies the task title."
	echo ""
	echo "    Optional: Arg 2 specifies the task description."
	echo ""
	echo "    Optional: Arg 3 specifies what task to use as the new tasks parent."
	echo ""
	echo "  -----------------------------------------------------"

	exit 0
fi

isGitRepo=$(git rev-parse --is-inside-work-tree > /dev/null 2>&1)
[ $? -ne 0 ] && echo "Not inside a git repo, exiting." && exit 1

TASK_ID=$(fs_new_task.sh "$@" )

powershell svn_branch "$TASK_ID"
~/til/git_svn/git_svn_track_remote_svn_branch.sh "$TASK_ID"
