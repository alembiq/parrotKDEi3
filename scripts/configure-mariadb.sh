#!/usr/bin/env bash
# root access from web

sudo service mariadb restart
echo " use mysql; update user set plugin='' where User='root'; \
	grant all privileges on *.* to 'root'@'localhost' identified by 'password'; \
	flush privileges;" | mysql
sudo service mysql restart
