#!/usr/bin/env bash

today="$(date +'%D')"
arg1="${1^^}"

if [ ! -f ~/.apt-daily ] || [ $(< ~/.apt-daily) != "$today" ] || [ "$1" == "-f" ]; then 
	sudo apt-get update 2>/dev/null | grep Err
        sudo apt-get full-upgrade
        sudo apt-get autoremove -y >/dev/null | grep Err
        sudo apt-get autoclean -y >/dev/null | grep Del
	printf "$today" >~/.apt-daily
fi
