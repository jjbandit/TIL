#! /bin/bash

[ $# -eq 0 ] && echo "Please pass me a task number, exiting." && exit 1

isGitRepo=$(git rev-parse --is-inside-work-tree > /dev/null 2>&1)

[ $? -ne 0 ] && echo "Not inside a git repo, exiting." && exit 1


TASK=$1

powershell svn_branch $TASK
~/til/git_svn/git_svn_track_remote_svn_branch.sh $TASK
