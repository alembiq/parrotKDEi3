#!/usr/bin/env bash

if [[ ${1} && ${2} && ${3} ]]; then
	ssh-add ${1}
	git init
	git remote add origin ${2}
	git fetch 
	git reset --hard origin/${3}
	git checkout ${3}
else 
	echo "requires params"
	echo "  sshkey"
	echo "  git repository"
	echo "  branch name"
fi

