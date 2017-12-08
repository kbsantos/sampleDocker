FROM centos:7

##Install Apache PHP configuration changes
#########################################
RUN yum -y update && yum clean all
RUN yum install -y \
	psmisc \
	httpd \
	postfix \
	php \
	php-common \
	php-dba \
	php-gd \
	php-intl \
	php-mbstring \
	php-mysqlnd \
	php-pecl-memcache \
	php-pspell \
	php-recode \
	php-snmp \
	php-soap \
	php-xml \
	php-xmlrpc \
	php-cli \
	php-pear \
    	php-bcmath \
    	mod_ssl \
    	php-mcrypt \
    	php-fpm \
    	vim \
    	gcc \
	php-pear \        
	php-devel \       
	httpd-devel \     
	pcre-devel \      
	openssl-devel \   
	make

##Global Apache PHP configuration changes
#########################################
RUN mkdir /var/www/html/cddev
RUN chown -R apache:apache /var/www/html/cddev

ADD config/server_setup /server_setup
RUN chmod +x /server_setup
RUN /bin/bash -c "source /server_setup/SetConfig.sh"

RUN sed -i \
    -e 's~^IndexOptions \(.*\)$~#IndexOptions \1~g' \
    -e 's~^IndexIgnore \(.*\)$~#IndexIgnore \1~g' \
    -e 's~^AddIconByEncoding \(.*\)$~#AddIconByEncoding \1~g' \
    -e 's~^AddIconByType \(.*\)$~#AddIconByType \1~g' \
    -e 's~^AddIcon \(.*\)$~#AddIcon \1~g' \
    -e 's~^DefaultIcon \(.*\)$~#DefaultIcon \1~g' \
    -e 's~^ReadmeName \(.*\)$~#ReadmeName \1~g' \
    -e 's~^HeaderName \(.*\)$~#HeaderName \1~g' \
    /etc/httpd/conf.d/autoindex.conf

RUN sed -i \
    -e 's~^;date.timezone =$~date.timezone = Europe/Rome~g' \
    -e 's~^;user_ini.filename =$~user_ini.filename =~g' \
    -e 's~^short_open_tag = Off$~short_open_tag = On~g' \
    -e 's~^memory_limit = 128M$~memory_limit = 2048M~g' \
    -e 's~^sendmail_path = /usr/sbin/sendmail -t -i$~sendmail_path = /usr/bin/msmtp -C /etc/msmtprc -t -i~g' \
    /etc/php.ini

RUN pecl install apc
RUN echo "extension=apc.so" > /etc/php.d/apc.ini

##UTC Timezone & Networking
###########################
RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime \
    && echo "NETWORKING=yes" > /etc/sysconfig/network

RUN rm -rf /sbin/sln \
    ; rm -rf /usr/{{lib,share}/locale,share/{man,doc,info,gnome/help,cracklib,il8n},{lib,lib64}/gconv,bin/localedef,sbin/build-locale-archive} \
    ; rm -rf /var/cache/{ldconfig,yum}/*

RUN rm -rf /run/httpd/*
RUN rm -rf /tmp/httpd*

EXPOSE 80 443

WORKDIR /var/www/html/cddev

CMD /usr/sbin/httpd -DFOREGROUND
