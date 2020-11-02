#!/usr/bin/env bash
sudo apt update

echo "###### INSTALL ######"
sudo apt update
sudo apt install -y \
	git imagemagick mariadb-server php7.4-fpm apache2 libapache2-mod-fcgid php-mysql php-mbstring php-xml php-gd automysqlbackup

echo "###### SERVICES ######"
sudo systemctl enable php7.4-fpm.service
sudo systemctl enable mariadb.service
sudo systemctl enable apache2.service
sudo a2enconf php7.4-fpm
sudo a2enmod proxy_fcgi setenvif expires headers rewrite

sudo sed -i 's/www-data/$(whoami)/g' /etc/php/7.4/fpm/pool.d/www.conf
sudo sed -i 's/\/var\/lib\/automysqlbackup/\/home\/backup\/automysqlbackup/' /etc/default/automysqlbackup

sudo service php7.4-fpm restart
sudo service apache2 restart
