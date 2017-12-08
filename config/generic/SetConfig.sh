#!/bin/bash
mkdir /var/www/html/httpd_logs
chown -R apache:apache /var/www/html/httpd_logs
cp -R /server_setup/index.php /var/www/html/httpd_logs
chmod -R go+rX /var/log/httpd

mv /etc/httpd/conf.modules.d/00-base.conf /etc/httpd/conf.modules.d/00-base.conf.orig
mv /etc/httpd/conf.modules.d/00-ssl.conf /etc/httpd/conf.modules.d/00-ssl.conf.orig
mv /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.orig

chmod -R 644 /server_setup/conf.modules.d/*
chmod -R 644 /server_setup/*.conf

cp -R /server_setup/conf.modules.d/00-base.conf /etc/httpd/conf.modules.d/
cp -R /server_setup/conf.modules.d/00-ssl.conf /etc/httpd/conf.modules.d/
cp -R /server_setup/docker.conf /etc/httpd/conf.d/
cp -R /server_setup/cd-logs.conf /etc/httpd/conf.d/
cp -R /server_setup/httpd.conf /etc/httpd/conf/


