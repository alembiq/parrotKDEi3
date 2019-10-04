#!/usr/bin/env bash
# root access from web

sudo service mariadb restart
sudo mysql < echo "use mysql; update user set plugin='' where User='root'; 
	grant all privileges on *.* to 'root'@'localhost' identified by 'password';
	grant all privileges on *.* to 'root'@'localhost' identified by 'password';
	grant all privileges on *.* to 'root'@'localhost' identified by 'password';
	flush privileges;"
sudo service mysql restart
