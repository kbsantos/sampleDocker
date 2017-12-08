#!/bin/bash
clear

docker stop cd-mysql
docker stop cd-dev

docker rm cd-mysql
docker rm cd-dev

clear
echo "building--->> mysql"
cd config/mysql/
docker build --no-cache=true -t cd_mysql .
cd ../../

docker run -d --name=cd-mysql --env="MYSQL_ROOT_PASSWORD=sqladmin1" -p 3306:3306 -v $(pwd)/config/mysql/database:/var/lib/mysql -v $(pwd)/config/mysql/dumps:/home cd_mysql
docker run -d --name=cd-dev --link cd-mysql:cd_mysql -v $(pwd)/dev_codes:/var/www/html/cddev -p 80:80 cd_dev
docker exec cd-dev /bin/sh -c "/server_setup/SetHosts.sh"

clear
docker ps
docker inspect cd-mysql | grep IPAddress