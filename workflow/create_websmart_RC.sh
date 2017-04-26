#! /bin/bash

RC="$1"
Version="$(svn_current_branch.sh)"


# RC should follow the naming convention `rc1`
# Sprint should follow the naming convention `rc1`
# Version should follow the naming convention `135 (v11.3)`

[ "$RC" == "" ]      && echo "Please supply a name for this RC. Exiting."    && exit 1
[ "$Version" == "" ] && echo "Please supply a version for this RC. Exiting." && exit 1

RepoUrl="http://svn.excelsystems.com/svn/websmart/websmart"

SprintUrl="$RepoUrl/sprints/$Version"
TagUrl="$RepoUrl/tags/$Version"
RcUrl="$RepoUrl/tags/$Version/$RC"

RcCheckout="/home/jhughes/extended/websmart/tags/$RC"
Windows_Rc_CheckoutDir=$(cygpath --windows "$RcCheckout")

svn info "$SprintUrl" > /dev/null
[ $? -ne 0 ] && echo "Invalid Sprint Url $SprintUrl - exiting." && exit 0




# Create tags/$Version if it's not there (Probably rc1)
svn info "$TagUrl" > /dev/null
if [ $? -ne 0 ]; then 
  echo "Creating Tag Directory $TagUrl"
  svn mkdir "$TagUrl" -m "Creating tags/ for $Version"
else
  echo "$TagUrl Exists, not creating."
fi


# Create RC branch if it's not there
svn info "$RcUrl" > /dev/null
if [ $? -ne 0 ]; then
  echo "Creating RC"
  svn copy "$SprintUrl" "$RcUrl" -m "Creating $RC"
else
  echo "$SprintUrl Exists, not creating."
fi


# Cleanup local checkout directory if it exists
if [ -d "$RcCheckout" ]; then
  echo "Reverting changes in $RcCheckout"
  svn_revert_all.sh
fi


# Checkout RC
svn checkout "$RcUrl" "$RcCheckout" > /dev/null

# Build the installer
echo "Runing makeinstaller.ps1"
powershell.exe -Command "&\"$Windows_Rc_CheckoutDir/Installers/client install/makeinstaller.ps1\" $Windows_Rc_CheckoutDir"

# For whatever reason the commit in 'make RC.bat' fails when it's called from
# cygwin, so commit here instead
cd "$RcCheckout"
svn commit -m "---------- Make client install ----------"

