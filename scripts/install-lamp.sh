#!/usr/bin/env bash
sudo apt update

echo "###### INSTALL ######"
sudo apt update
sudo apt install -y \
	git imagemagick mariadb-server php7.3-fpm apache2 libapache2-mod-fcgid php-mysql php-mbstring php-xml php-gd

echo "###### SERVICES ######"
sudo systemctl enable php7.3-fpm.service
sudo systemctl enable mariadb.service
sudo systemctl enable apache2.service
sudo a2enconf php7.3-fpm
sudo a2enmod proxy_fcgi setenvif expires headers rewrite

