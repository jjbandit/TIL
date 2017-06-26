#! /bin/bash -i

BranchName=$(svn_current_branch.sh)
BranchRebaseName="$BranchName""_rebase" 

RevisionsToRebase=$( svn_log_short.sh "$BranchName" | tail -n +2 )


echo " -- Renaming Current branch to $BranchRebaseName"
CurrentBranchUrl=$( svn info | grep "^URL" | cut -f 2 -d" ")
RebaseBranchUrl="$CurrentBranchUrl""_rebase"

svn delete --quiet "$RebaseBranchUrl"

svn mv "$CurrentBranchUrl"  "$RebaseBranchUrl" -m "Prep to rebase"
svn_branch.sh "$BranchName"

echo "" > .commands

#
# Loop through the log until we get to the checkout commit.  The log is sorted
# by most recent revision so we also have to save out the commands we want to
# run to a file since we encounter the most recent commits first.
#

echo "$RevisionsToRebase" | while read -r Commit; do

  # Bail if we're at the Checkout commit
  IsCheckoutCommit=$( echo "$Commit" | grep -Pi "(checkout|auto config update)" | wc -c )
  [ $IsCheckoutCommit -gt 0 ] && break

  Rev=$( echo "$Commit" | grep -Po "r\d+" )
  Message=$( echo "$Commit" | cut -d"|" -f 3 )

  # Echo the current revisions commands to .tmp_commands
  echo "" > .tmp_commands
  echo "svn merge -c $Rev \"$RebaseBranchUrl\" . " >> .tmp_commands
  echo "svn commit -m \"$Message Task: $BranchName\" " >> .tmp_commands
  echo "svn update" >> .tmp_commands

  # Prepend them to .commands
  Commands="$(cat .tmp_commands) $(cat .commands)"
  echo "$Commands" > .commands
  rm .tmp_commands
done


# Finally loop through all the commands we just built and run em!
cat .commands | while read -r Command; do
  echo "Running : $Command"
  eval "$Command"
done

