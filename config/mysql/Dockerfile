FROM mysql

ADD mysqld server_setup/
RUN chmod +x /server_setup/*
RUN mv /etc/mysql/mysql.conf.d/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf.orig
RUN mv /server_setup/mysqld.cnf /etc/mysql/mysql.conf.d/