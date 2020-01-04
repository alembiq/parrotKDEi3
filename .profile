# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
   	PATH="$HOME/bin:$PATH"
fi
if [ -d "$HOME/.local/bin" ] ; then
	PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/scripts" ] ; then
	PATH="$HOME/scripts:$PATH"
fi

#Change first day of week to Monday
export LC_TIME=en_US.UTF-8
#Change to metric system
export LC_MEASUREMENT=en_US.UTF-8

#umask 022

export GIT_AUTHOR_NAME="Karel Křemel"
export SSH_ASKPASS="/usr/bin/ssh-askpass"
eval 'ssh-agent -s' >/dev/null

printf "# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #"
hostname | figlet -f slant -c -w 103
if [ -f ".motd" ] ; then if [ -f "/usr/bin/pandoc" ] ; then pandoc -s -f markdown ~/.motd -t plain ; else cat ~/.motd ; fi
else if [ -f "/usr/bin/pandoc" ] ; then pandoc -s -f markdown /etc/motd -t plain ; else cat /etc/motd ; fi
fi
printf "\n# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #\n\n"

ssh-add -L
free 
df 
if [ -f "/usr/bin/docker" ]; then
	docker ps
fi

if [ -f "/home/$(whoami)/scripts/apt-daily.sh" ]; then ~/scripts/apt-daily.sh; fi

export GPG_TTY=$(tty)
