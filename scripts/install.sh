#!/usr/bin/env bash

#TODO fnc pro zapis do konfiguraku; if ( $file | grep $content | wc -l <> $content |wc -l) { sudo -c "echo $content >$file" }
#TODO fnc pro instalaci balicku; if ( apt list --installed | grep $packages | wc -l <> $packages | wc -l) { sudo apt -qq update && sudo apt -qq -y install $packages }

SCRIPTS=$(dirname ${BASH_SOURCE[0]})
function help() {
	echo "$0 newhostname default installation of everything"
	echo "$0 -s | --sudo install sudo and make it passwordless for current user"
        echo "$0 -h | --hostname=(hostname) renames current host to (hostname)"
}





function host-rename () {
	su $SUDO_USER -c "echo $1 >/proc/sys/kernel/hostname && sed -i 's/127.0.1.1.*/127.0.1.1\t'$1'/g' /etc/hosts && \
		echo $1 >/etc/hostname && hostname $1 && xauth add $(xauth list | sed 's/^.*\//'"$1"'\//g' | \
		awk 'NR==1 {sub($1,"\"&\""); print}')"
	# https://askubuntu.com/a/430674
}

function sudo-install () {
	su -c "apt -qq -y install sudo && echo '$(whoami) ALL=(ALL) NOPASSWD: ALL' >>/etc/sudoers.d/passwordless"
}

function locales-custom () {
	sudo apt -qq update 
	sudo sed -i "s/# \+\(en_US.UTF-8\)/\1/" /etc/locale.gen
	sudo sed -i "s/# \+\(cs_CZ.UTF-8\)/\1/" /etc/locale.gen
	sudo apt -qq -y install localepurge
	sudo locale-gen
}

function apt-cleanup () {
	sudo apt -qq -y purge geany xboard ricochet-im electrum zeal brasero zulucrypt sirikali
	sudo apt -qq update
	sudo apt -qq -y --fix-broken install
	sudo dpkg --configure -a
	sudo apt -qq -y full-upgrade
	sudo apt -qq -y autoremove
	sudo apt -qq -y autoclean
}

function install-essentials () {
	sudo apt -qq -y install git tree aptitude mc dirmngr krename clamav imagemagick iftop \
	cifs-utils software-properties-common ntp curl okular kleopatra mc fonts-font-awesome tig
}

function bash-config () {
#	if [ -f ~/.profile ]; then rm ~/.profile ; fi
#	if [ -f /etc/skel/.profile ]; then sudo rm /etc/skel/.profile ; fi
	curl -sL https://gitlab.alembiq.net/charles/parrotKDEi3/-/raw/master/.bashrc > ~/.bashrc
	curl -sL https://gitlab.alembiq.net/charles/parrotKDEi3/-/raw/master/.bash_aliases > ~/.bash_aliases
	curl -sL https://gitlab.alembiq.net/charles/parrotKDEi3/-/raw/master/.profile > ~/.bash_profile
	sudo cp ~/.bashrc /etc/skel
	sudo cp ~/.bash_aliases /etc/skel
	sudo cp ~/.bash_profile /etc/skel
}

function install-i3 () {
	sudo apt -qq -y install -y picom rofi feh i3-gaps-wm i3-gaps i3blocks i3lock \
	i3pystatus i3status network-manager-gnome
	$SCRIPTS/configure-i3gaps.sh
}

function install-pulseequalizer () {
	sudo apt -qq -y install pavucontrol pulseaudio-equalizer pulseaudio-module-bluetooth pavucontrol
	printf '\n#pulse qualizer\n  load-module module-switch-on-connect\n  load-module module-switch-on-connect ignore_virtual=no\n  load-module module-equalizer-sink\n  load-module module-dbus-protocol\n' | sudo tee -a /etc/pulse/default.pa >/dev/null
}

function services-enable () {
	sudo systemctl enable clamav-freshclam.service
	sudo systemctl enable bluetooth.service
	sudo systemctl enable ntp
	sudo systemctl enable cups.service
}

################### DECISIVE PROCESS
if [[ $# -eq 0 ]] ; then
        help
        exit 0
fi
for i in "$@"
do
    case "${1}" in
	-s|--sudo)
		sudo-install
		shift
	;;
	--cleanup)
		apt-cleanup
		shift
	;;
 	-h=*|--hostname=*)
		host-rename ${i#*=}
		shift
	;;
	-l|--locale)
		locales-custom
		shift
	;;
       -b|--bash)
                bash-config
                shift
        ;;
	--install-essentials)
		install-essentials
		shift
	;;
	--install-brave)
		$SCRIPTS/install-brave.sh
		shift
	;;
	--install-i3)
		install-i3
		shift
	;;
	--install-element)
		$SCRIPT/install-element.sh
		shift
	;;
	--install-pulseaudio)
		install-pulseequalizer
		shift
	;;
	--install-spotify)
		$SCRIPTS/install-spotify.sh
		shift
	;;
	--install-mutt)
		$SCRIPTS/install-mutt.sh
		shift
	;;
	--services)
		services-enable
		shift
	;;
	--logs)
		$SCRIPTS/configure-logs.sh
		shift
	;;
	--x1c7)
		$SCRIPTS/configure-x1c7.sh
		shift
	;;
	--install-lamp)
		$SCRIPTS/install-lamp.sh
		shift
	;;
	--configure-mariadb=*)
		sudo service mariadb restart
		sudo mysql_secure_installation
		shift
	;;
	--configure-etc=*)
		$SCRIPTS/configure-etckeeper.sh ${i#*=}
		shift
	;;
	*)
		read -p "Are you sure you want to rename this host to $1 and install everything? " -n 1 -r
		echo    # (optional) move to a new line
		if [[ $REPLY =~ ^[Yy]$ ]]
		then
			sudo-install
			host-rename $i
			locales-custom
			apt-cleanup
			install-essentials
			bash-config
			$SCRIPTS/install-brave.sh
			install-i3
			#install-qownnotes.sh
			$SCRIPT/install-element.sh
			install-pulseequalizer
			$SCRIPTS/install-spotify.sh
			#TODO cleanup mutt, exist before cat
			$SCRIPTS/install-mutt.sh
			services-enable
			$SCRIPTS/configure-logs.sh
			#TODO x1c7 handle Y option, all question at once, one install process, clean echo, amixer fault? new modem?
			$SCRIPTS/configure-x1c7.sh
			$SCRIPTS/install-lamp.sh
	                sudo service mariadb restart
	                sudo mysql_secure_installation			apt-cleanup
			$SCRIPTS/configure-etckeeper.sh gitlab.alembiq.net
		else
			help
		fi
	    exit 0
	;;
    esac
done

exit 0


