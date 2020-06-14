#!/usr/bin/env bash
### local hostname
if [ ! "$1" ]; then 
echo "missing parameters: $0 hostname"
	exit
fi

echo "###### PASSWORDLESS SUDO ######"
su -c "echo '$(whoami) ALL=(ALL) NOPASSWD: ALL' | sudo tee -a /etc/sudoers.d/passwordless"


echo $1 | sudo tee /etc/hostname
sudo sed -i "s/parrot/$1/g" /etc/hosts
echo "nameserver 1.1.1.1" | sudo tee /etc/resolv.conf 


echo "###### CLEANUP ######"
DIR=$(pwd)
sudo apt update
sudo apt full-upgrade -y
sudo apt -y --fix-broken install
sudo dpkg --configure -a

echo "###### LOCALES ######"
sudo sed -i "s/# \+\(cs_CZ.UTF-8\)/\1/" /etc/locale.gen
sudo locale-gen

echo "###### PURGE ######"
sudo apt purge -y thunderbird geany rhythmbox keepassxc xboard ricochet-im hexchat homebank \
	 electrum zeal revolt brasero socat zulucrypt sirikali

echo "###### INSTALL ######"
sudo apt update
sudo apt install -y \
	git etckeeper tree aptitude mc dirmngr kde-spectacle krusader krename clamav  \
	software-properties-common ntp curl okular kleopatra feh smb4k network-manager-openconnect  ranger \ 
	imagemagick iftop

echo "###### GITHUB HOME ######"
cd ~
git clone https://github.com/alembiq/parrotKDEi3.git
rm -rf parrotKDEi3/.git
cp -nr parrotKDEi3/{,.[^.]}* ~
rm -rf parrotKDEi3

echo "###### SERVICES ######"
sudo systemctl enable clamav-freshclam.service
sudo systemctl enable bluetooth.service
sudo systemctl enable ntp
sudo systemctl enable cups.service

sudo sed -i 's/\(GRUB_CMDLINE_LINUX="\)/\1systemd.show_status=1 /' /etc/default/grub.d/parrot.cfg
sudo update-grub2

read -p "Install i3-gaps? y/n " -n 1 -r 
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	$DIR/install-i3gaps.sh
fi

read -p "Install mutt? y/n " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	$DIR/install-mutt.sh
fi

read -p "Install LAMP? y/n " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	$DIR/install-lamp.sh
fi

echo "###### CLEANUP ######"
sudo apt autoremove -y
sudo apt autoclean -y

echo "###### TODO MANUAL INSTALLATION ######"
printf "
$DIR/install-inithome.sh key repo branch
