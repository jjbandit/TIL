#! /bin/bash

BRANCH=$(svn_current_branch.sh)
# BRANCH=31462

SYSTEM=dev.excelsystems.com

if [ "$BRANCH" == "trunk" ]; then
	BRANCH=""
	ROOT="nexus_trunk"
else
	BRANCH="NX$BRANCH"
	ROOT="nexus_dev"
fi


DEV_IFS="/esdi/nexus/$ROOT/$BRANCH"

REMOTE_NEXUSPUBLIC="$DEV_IFS/nexuspublic"
REMOTE_NEXUS="$DEV_IFS/nexus"

LOCAL_NEXUSPUBLIC="./IFS Files/nexuspublic"
LOCAL_NEXUS="./IFS Files/nexus"

#### RANDOM BS ####

expect -f ~/til/workflow/rsync.expect $(cat ~/.pwd) "$SYSTEM" "$LOCAL_NEXUS/templates/"         "$REMOTE_NEXUS/templates/"
# expect -f ~/til/workflow/rsync.expect $(cat ~/.pwd) "$SYSTEM" "$LOCAL_NEXUS/skins/"             "$REMOTE_NEXUS/skins/"
# expect -f ~/til/workflow/rsync.expect $(cat ~/.pwd) "$SYSTEM" "$LOCAL_NEXUSPUBLIC/js/"          "$REMOTE_NEXUSPUBLIC/js/"
# expect -f ~/til/workflow/rsync.expect $(cat ~/.pwd) "$SYSTEM" "$LOCAL_NEXUSPUBLIC/stylesheets/" "$REMOTE_NEXUSPUBLIC/stylesheets/"
# expect -f ~/til/workflow/rsync.expect $(cat ~/.pwd) "$SYSTEM" "$LOCAL_NEXUSPUBLIC/skins/"       "$REMOTE_NEXUSPUBLIC/skins/"

#### NXDS ####

# expect -f ~/til/workflow/rsync.expect $(cat ~/.pwd) "$SYSTEM" "$LOCAL_NEXUS/nxds/"               "$REMOTE_NEXUS/nxds/"
# expect -f ~/til/workflow/rsync.expect $(cat ~/.pwd) "$SYSTEM" "$LOCAL_NEXUSPUBLIC/nxds/"         "$REMOTE_NEXUSPUBLIC/nxds/"

#### FULL PUSH ####

# expect -f ~/til/workflow/rsync.expect $(cat ~/.pwd) "$SYSTEM" "$LOCAL_NEXUSPUBLIC"  "$REMOTE_NEXUSPUBLIC"
# expect -f ~/til/workflow/rsync.expect $(cat ~/.pwd) "$SYSTEM" "$LOCAL_NEXUS"        "$REMOTE_NEXUS"
