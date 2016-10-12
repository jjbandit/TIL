#! /bin/bash

TASK_HTML=$(http --follow GET http://flyspray.excelsystems.com/flyspray \
	do==index project==2 type%5B0%5D==2 type%5B1%5D==1 type%5B2%5D==21 type%5B3%5D==20 \
	dev==jhughes status%5B0%5D==2 status%5B1%5D==3 status%5B2%5D==7 status%5B3%5D==4 \
	status%5B4%5D==5 status%5B5%5D==6 status%5B6%5D==12 status%5B7%5D==13 \
	status%5B8%5D==14 status%5B9%5D==15 status%5B10%5D==16 status%5B11%5D==9
)


TASK_LIST=$( echo "$TASK_HTML" \
	| grep -Po "task_summary.*?/td>" \
	| grep -o "title.*\/a>" \
	| grep -Po ">.*<" \
	| sed -e 's/[<>]//g'
)

TASK_IDS=$( echo "$TASK_HTML" \
	| grep -Po "task_summary.*?/td>" \
	| grep -Po "(?<=task_id=)\d+"
)

TASK_IDS=$( echo "$TASK_IDS" \
	| sed 's/.*/ '$(echo -e "\033[32m")'\0'$(echo -e "\033[37m")'/g'
)

echo -e "$TASK_LIST" > ./tasklist
echo -e "$TASK_IDS" > ./taskids

paste ./taskids ./tasklist

rm ./taskids ./tasklist
