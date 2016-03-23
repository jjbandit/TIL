#! /bin/bash

[ $# -eq 0 ] && echo "Please supply a task name! Exiting." && exit 1

echo $1


# Make it so!

curl 'http://flyspray.excelsystems.com/flyspray/index.php?do=newtask&project=2' \
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
--data-binary $'--%#%#\r\nContent-Disposition: form-data; name="item_summary"\r\n\r\n'"$1"$'\r\n
--%#%#\r\nContent-Disposition: form-data; name="task_type"\r\n\r\n2\r
--%#%#\r\nContent-Disposition: form-data; name="product_category"\r\n\r\n5\r
--%#%#\r\nContent-Disposition: form-data; name="item_status"\r\n\r\n2\r
--%#%#\r\nContent-Disposition: form-data; name="find_user"\r\n\r\n\r
--%#%#\r\nContent-Disposition: form-data; name="rassigned_to[]"\r\n\r\n83\r
--%#%#\r\nContent-Disposition: form-data; name="operating_system"\r\n\r\n8\r
--%#%#\r\nContent-Disposition: form-data; name="task_severity"\r\n\r\n2\r
--%#%#\r\nContent-Disposition: form-data; name="task_priority"\r\n\r\n2\r
--%#%#\r\nContent-Disposition: form-data; name="product_version"\r\n\r\n333\r
--%#%#\r\nContent-Disposition: form-data; name="closedby_version"\r\n\r\n0\r
--%#%#\r\nContent-Disposition: form-data; name="due_date"\r\n\r\n\r
--%#%#\r\nContent-Disposition: form-data; name="detailed_desc"\r\n\r\nSuch details.\r
--%#%#\r\nContent-Disposition: form-data; name="userfile[]"; filename=""\r\nContent-Type: application/octet-stream\r\n\r\n\r
--%#%#\r\nContent-Disposition: form-data; name="action"\r\n\r\nnewtask.newtask\r
--%#%#\r\nContent-Disposition: form-data; name="project_id"\r\n\r\n2\r
--%#%#\r\nContent-Disposition: form-data; name="notifyme"\r\n\r\n1\r
--%#%#--\r\n'
