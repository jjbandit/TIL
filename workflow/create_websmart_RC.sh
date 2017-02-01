#! /bin/bash

RC="$1"
Version="$(svn_current_branch.sh)"

[ "$RC" == "" ]      && echo "Please supply a name for this RC. Exiting." && exit 1
[ "$Version" == "" ] && echo "Bogus version, exiting."                    && exit 1

RepoUrl="http://svn.excelsystems.com/svn/websmart/websmart"

SprintUrl="$RepoUrl/sprints/$Version"
TagUrl="$RepoUrl/tags/$Version/$RC"

RC_ChekckoutDir="/home/jhughes/extended/websmart/tags/$RC"

svn copy "$SprintUrl" "$TagUrl" -m "Creating $RC"
svn checkout "$TagUrl" "$RC_ChekckoutDir"

cd "$RC_ChekckoutDir/Installers/client install"
cmd /c "make RC.bat"

# For whatever reason the commit in 'make RC.bat' fails when it's called from
# cygwin, so commit here instead
cd "$RC_ChekckoutDir"
svn commit -m "---------- Make client install ----------"

