#!/bin/bash
clear
SCRIPT="config/ServerSetup.sh"
(exec "$SCRIPT")

docker stop cd-dev
docker rm $cd-dev

clear
echo "building--->> php5.4"
docker build --no-cache=true -t cd_dev .
docker run -d --name=cd-dev --link cd-mysql:cd_mysql -v $(pwd)/dev_codes:/var/www/html/cddev -p 80:80 cd_dev

#modify /etc/hosts
docker exec cd-dev /bin/sh -c "/server_setup/SetHosts.sh"

clear
docker ps
docker inspect cd-mysql | grep IPAddress