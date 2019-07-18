#!/usr/bin/env bash
### local hostname
if [ ! "$1" ]; then 
	echo "missing parametr local hostname"
	exit
fi
echo $1 | sudo tee /etc/hostname
sudo sed -i 's/parrot/$1/g' /etc/hosts


echo "nameserver 1.1.1.1" | sudo tee /etc/resolv.conf 

DIR=$(pwd)

sudo apt update
sudo apt full-upgrade -y
sudo apt -y --fix-broken install

### locales
sudo sed -i "s/# \+\(cs_CZ.UTF-8\)/\1/" /etc/locale.gen
sudo locale-gen

### passwordless sudo
echo "$(whoami) ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/passwordless
sudo chmod 440 /etc/sudoers.d/passwordless

### repositories
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A8AA1FAA3F055C03
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A87FF9DF48BF1C90
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E58A9D36647CAE7F
echo "deb http://ppa.launchpad.net/papirus/papirus/ubuntu bionic main" > \
	sudo tee /etc/apt/sources.list.d/papirus-ppa.list
echo "deb http://repository.spotify.com stable non-free" | \
	sudo tee /etc/apt/sources.list.d/spotify.list
echo "deb http://ppa.launchpad.net/danielrichter2007/grub-customizer/ubuntu bionir main" | \
	sudo tee /etc/apt/sources.list.d/grub-customizer.list

### cleanup
sudo apt purge -y thunderbird geany rhythmbox keepassxc xboard ricochet-im hexchat homebank \
	 electrum zeal revolt brasero socat zulucrypt sirikali

### installation
sudo apt update
sudo apt install -y \
	git etckeeper rofi compton tree aptitude mc dirmngr kde-spectacle krusader krename clamav spotify-client \
	software-properties-common ntp curl okular kleopatra feh smb4k network-manager-openconnect i3 rancher imagemagick \
	mariadb-server php7.3-fpm apache2 libapache2-mod-fcgid php-mysql php-mbstring php-xml php-gd \
	dino-im git papirus-icon-theme grub-customizer neomutt isync msmtp urlview abook

### init home to GITHUB version
cd ~
git clone https://github.com/alembiq/parrotKDEi3.git
rm -rf parrotKDEi3/.git
mv parrotKDEi3/{,.[^.]}* ~

### mutt-wizard
cd /tmp
git clone https://github.com/LukeSmithxyz/mutt-wizard
cd mutt-wizard
sudo make install

### cleanup
sudo apt autoremove -y
sudo apt autoclean -y

### configure services
sudo systemctl enable php7.3-fpm.service
sudo systemctl enable mariadb.service
sudo systemctl enable apache2.service
sudo systemctl enable clamav-freshclam.service
sudo systemctl enable bluetooth.service
sudo systemctl enable ntp
sudo systemctl enable cups.service
sudo a2enconf php7.3-fpm
sudo a2enmod proxy_fcgi setenvif expires headers rewrite

### configuration
sudo mkdir -p /etc/X11/xorg.conf.d/
printf 'Section "Device"\nIdentifier "Intel Graphics"\nDriver "intel"\nOption "TearFree" "true"\nEndSection' \
  |sudo tee /etc/X11/xorg.conf.d/20-intel.conf 
echo "blacklist hid_multitouch"  | sudo tee -a /etc/modprobe.d/hid_multitouch.conf
printf "export KDEWM=/usr/bin/i3\ncompton & --config ~/.config/compton/compton.conf\n" | \
	tee  ~/.config/plasma-workspace/env/wm.sh
chmod 755 ~/.config/plasma-workspace/env/wm.sh
sudo mv /usr/bin/ksplashqml /usr/bin/ksplashqml.old

sudo mkdir /etc/systemd/system/getty@tty1.service.d/
printf "[Service]\nTTYDisallocate=no" \
	| sudo tee /etc/systemd/system/getty@tty1.service.d/noclear.conf
printf "[Service]\nExecStart=\nExecStart=-/usr/bin/tail -f /var/log/messages /var/logsyslog\nStandardInput=tty\nStandardOutput=tty" \
	| sudo tee /etc/systemd/system/getty@tty1.service.d/override.conf
sudo systemctl daemon-reload
sudo systemctl restart getty@tty1.service

sudo sed -i 's/\(GRUB_CMDLINE_LINUX="\)/\1systemd.show_status=1 /' /etc/default/grub.d/parrot.cfg
sudo update-grub2

### i3 gaps installation
~/scripts/install-i3gaps.sh

### manual installation hints
printf "
scripts/install-inithome.sh key repo branch

sudo gdebi ~/Download/google-chrome-stable_current_amd64.deb
sudo gdebi ~/Download/skypeforlinux-64.deb
sudo gdebi ~/Download/mailspring-1.6.1-amd64.deb
sudo gdebi ~/Download/VNC-Viewer-6.19.325-Linux-x64.deb
sudo gdebi ~/Download/slack-desktop-3.4.2-amd64.deb
\nassign /etc repo to GITserver\n"
