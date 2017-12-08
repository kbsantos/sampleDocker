#!/bin/bash
clear
SCRIPT="config/ServerSetup.sh"
(exec "$SCRIPT")

docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
#docker rmi -f $(docker images -a -q)
docker rmi -f cd_dev
docker rmi -f cd_mysql

clear
echo "building--->> php5.4"
docker build --no-cache=true -t cd_dev .

clear
echo "building--->> mysql"
cd config/mysql/
docker build --no-cache=true -t cd_mysql .
cd ../../

docker run -d --name=cd-mysql --env="MYSQL_ROOT_PASSWORD=sqladmin1" -p 3306:3306 -v $(pwd)/config/mysql/database:/var/lib/mysql -v $(pwd)/config/mysql/dumps:/home cd_mysql
docker run -d --name=cd-dev --link cd-mysql:cd_mysql -v $(pwd)/dev_codes:/var/www/html/cddev -p 80:80 cd_dev

#modify /etc/hosts
docker exec cd-dev /bin/sh -c "/server_setup/SetHosts.sh"

clear
docker ps
docker inspect cd-mysql | grep IPAddress