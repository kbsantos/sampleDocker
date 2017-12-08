FILE='config/NameServers.txt'
CURRDATE=$(date +%Y%m%d%H%M%S)

mkdir $CURRDATE
mv config/server_setup/ $CURRDATE/

tar -czvf $CURRDATE/server_setup.tar.gz $CURRDATE/server_setup
rm -R $CURRDATE/server_setup

mv $CURRDATE config/backup/
mkdir config/server_setup/

cp -R config/generic/conf.modules.d config/server_setup/
cp -R config/generic/index.php config/server_setup/
cp -R config/generic/cd-logs.conf config/server_setup/
cp -R config/generic/httpd.conf config/server_setup/
cp -R config/generic/SetConfig.sh config/server_setup/
cp -R config/generic/SetHosts.sh config/server_setup/

if [[ -s $FILE ]];then
    while read LINE; do

    echo "<VirtualHost *:80>
    ServerName ${LINE//$'\r'}
    ServerAdmin webadmin@website.com
    DocumentRoot /var/www/html/cddev/${LINE//$'\r'}/
    ErrorLog logs/${LINE//$'\r'}-error_log
    CustomLog logs/${LINE//$'\r'}-access_log common
    <Directory /var/www/html/cddev/${LINE//$'\r'}/>
        Options -Indexes +FollowSymlinks
        AllowOverride All
        Order allow,deny
        Allow from all
    </Directory>
</VirtualHost>
    " >> config/server_setup/docker.conf

    echo "${LINE//$'\r'}" >> config/server_setup/Servers.txt

    if [ ! -d "dev_codes/${LINE//$'\r'}" ]
    then
        mkdir dev_codes/${LINE//$'\r'}
        echo '<?php phpinfo(); ?>' > dev_codes/${LINE//$'\r'}/index.php
    fi

    done < $FILE
fi
