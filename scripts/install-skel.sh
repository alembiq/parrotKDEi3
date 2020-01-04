#!/usr/bin/env bash




echo
read -p "Clone ParrotKDEi3 y/n " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
	echo
	read -p "Delete all files from /home/$(whoami) y/n " -n 1 -r
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		echo
		rm -rf /home/${whoami}/*
		rm -rf /home/${whoami}/.*
	fi
	echo
	cd ~
	git clone https://github.com/alembiq/parrotKDEi3.git
	rm -rf parrotKDEi3/.git
	cp -nr parrotKDEi3/{,.[^.]}* ~
	rm -rf parrotKDEi3
fi
echo
