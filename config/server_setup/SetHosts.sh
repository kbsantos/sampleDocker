#!/bin/bash
FILE='/server_setup/Servers.txt'
if [[ -s $FILE ]];then
    while read LINE; do
	echo "127.0.0.1   ${LINE//$'\r'}" >> /etc/hosts
    done < $FILE
fi


