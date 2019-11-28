#!/usr/bin/env bash

DIR=$(pwd)

su -c "echo '$(whoami) ALL=(ALL) NOPASSWD: ALL' | sudo tee -a /etc/sudoers.d/passwordless"

sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

sudo apt update
sudo apt full-upgrade -y
sudo apt -y --fix-broken install
sudo dpkg --configure -a

sudo sed -i "s/# \+\(cs_CZ.UTF-8\)/\1/" /etc/locale.gen
sudo locale-gen


sudo apt install -y \
	git etckeeper tree aptitude mc dirmngr clamav software-properties-common ntp curl \
	btrfs-progs molly-guard fail2ban vim

#imagemagick iftop ranger

echo "###### SERVICES ######"
sudo systemctl enable clamav-freshclam.service
sudo systemctl enable ntp

$DIR/install-lamp.sh

echo "###### CLEANUP ######"
sudo apt autoremove -y
sudo apt autoclean -y

echo "TODO: hosts hostname"
