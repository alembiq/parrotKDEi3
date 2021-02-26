#!/usr/bin/env bash

today="$(date +'%D')"
arg1="${1^^}"
touchfile="$HOME/.local/share/apt-daily"


if [ ! -f $touchfile ] || [ $(< $touchfile) != "$today" ] || [ "$1" == "-f" ]; then 
	sudo apt-get update 2>/dev/null | grep Err
        sudo apt-get full-upgrade
#        sudo apt-get autoremove -y >/dev/null | grep Err
        sudo apt-get autoclean -y >/dev/null | grep Del
	printf "$today" | tee $touchfile
	echo
fi
