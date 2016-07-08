#! /bin/bash


# If you want to add this task as a dependency of another task add the following
# line just below the notifyme field.

function printHelp() {
	echo "  -----------------------------------------------------"
	echo ""
	echo "  Usage: fs_new_task.sh <Title> [Description] [Parent ID]"
	echo ""
	echo "    Required: Arg 1 specifies the task title."
	echo ""
	echo "    Optional: Arg 2 specifies the task description."
	echo ""
	echo "    Optional: Arg 3 specifies what task to use as the new tasks parent."
	echo ""
	echo "  -----------------------------------------------------"

	exit 0
}

function interactiveInput() {
	fs_temp=~/.fspray.tmp
	touch "$fs_temp"
	vim "$fs_temp"

	TASK_NAME=$(head -n 1 "$fs_temp")
	TASK_DESC=$(tail -n +3 "$fs_temp")

	rm "$fs_temp"

	PARENT_ID="$2"
	CREATE_DEPENDANT=$'--%#%#\r\nContent-Disposition: form-data; name="add_depend"\r\n\r\n'"$PARENT_ID"$'\r\n'
}

# Error handling

[ "$#" -eq 0 ] && printHelp

[ "$1" = "-h" ] && printHelp

# Defaults:

TASK_NAME="$1"
TASK_DESC="Such Details."
CREATE_DEPENDANT=''


if [ $# -gt 1 ]; then
	TASK_DESC="$2"
fi


if [ $# -gt 2 ]; then
	PARENT_ID="$3"
	CREATE_DEPENDANT=$'--%#%#\r\nContent-Disposition: form-data; name="add_depend"\r\n\r\n'"$PARENT_ID"$'\r\n'
fi


[ "$1" = "-i" ] && interactiveInput "$@"

# Make it so!

URL=$(curl --silent 'http://flyspray.excelsystems.com/flyspray/index.php?do=newtask&project=2' \
\
-H 'Host: flyspray.excelsystems.com' \
\
-H 'User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:44.0) Gecko/20100101 Firefox/44.0' \
\
-H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
\
-H 'Accept-Language: en-US,en;q=0.5' \
\
-H "Cookie: flyspray_project=2; current_task=28296; flyspray_userid=$FS_UID; flyspray_passhash=$FS_PASSHASH; __utma=219259853.590320609.1450381597.1450381597.1453739992.2; __utmz=219259853.1450381597.1.1.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided); _jsuid=1671113122; SubliminalAdvertising=30njsoajjtim6rrkp6lq8rbvt0" \
\
-H 'Connection: keep-alive' \
\
-H 'Content-Type: multipart/form-data; boundary=%#%#' \
\
--data-binary $'--%#%#\r\nContent-Disposition: form-data; name="item_summary"\r\n\r\n'"$TASK_NAME"$'\r
--%#%#\r\nContent-Disposition: form-data; name="task_type"\r\n\r\n2\r
--%#%#\r\nContent-Disposition: form-data; name="product_category"\r\n\r\n5\r
--%#%#\r\nContent-Disposition: form-data; name="item_status"\r\n\r\n2\r
--%#%#\r\nContent-Disposition: form-data; name="find_user"\r\n\r\n\r
--%#%#\r\nContent-Disposition: form-data; name="rassigned_to[]"\r\n\r\n'"$FS_UID"$'\r
--%#%#\r\nContent-Disposition: form-data; name="operating_system"\r\n\r\n8\r
--%#%#\r\nContent-Disposition: form-data; name="task_severity"\r\n\r\n2\r
--%#%#\r\nContent-Disposition: form-data; name="task_priority"\r\n\r\n2\r
--%#%#\r\nContent-Disposition: form-data; name="product_version"\r\n\r\n333\r
--%#%#\r\nContent-Disposition: form-data; name="closedby_version"\r\n\r\n0\r
--%#%#\r\nContent-Disposition: form-data; name="due_date"\r\n\r\n\r
--%#%#\r\nContent-Disposition: form-data; name="detailed_desc"\r\n\r\n'"$TASK_DESC"$'\r
--%#%#\r\nContent-Disposition: form-data; name="userfile[]"; filename=""\r\nContent-Type: application/octet-stream\r\n\r\n\r
--%#%#\r\nContent-Disposition: form-data; name="action"\r\n\r\nnewtask.newtask\r
--%#%#\r\nContent-Disposition: form-data; name="project_id"\r\n\r\n2\r
--%#%#\r\nContent-Disposition: form-data; name="notifyme"\r\n\r\n1\r
'"$CREATE_DEPENDANT"$'--%#%#--\r\n' )

task_id=$(echo $URL | grep -Po "(?<=task_id=)(\d+)" | head -1)

echo $task_id
