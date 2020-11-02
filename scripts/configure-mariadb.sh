#!/usr/bin/env bash
# root access from web
if [ "$#" -ne 1 ]; then
        echo "MariaDB root webaccess"
        echo "- allows root uset to sign in on web"
        echo
        echo "missing parameters: $0 password" >&2
        exit 1
fi


sudo service mariadb restart
echo " use mysql; update user set plugin='' where User='root'; \
	grant all privileges on *.* to 'root'@'localhost' identified by '$0'; \
	flush privileges;" | sudo mysql
sudo service mysql restart
