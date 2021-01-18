# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/scripts" ] ; then
    PATH="$HOME/scripts:$PATH"
fi

#SSH_ASKPASS='/usr/bin/ksshaskpass'
#export SSH_ASKPASS

#Change first day of week to Monday
export LC_TIME=en_US.UTF-8
#Change to metric system
export LC_MEASUREMENT=en_US.UTF-8
export GPG_TTY=$(tty)
export GIT_AUTHOR_NAME="Karel Křemel"
export SSH_ASKPASS="/usr/bin/ssh-askpass"
width=$(tput cols)

hashLine() {
for i in `seq 1 $1`;
do
        odd=$(( $i %2 ))
        if [ $odd = "0" ]
        then
                echo -n "#";
        else
                echo -n " ";
        fi
done
}

hashLine $width
if [ -f "/usr/bin/figlet" ] ; then  hostname | figlet -f slant -c -w $width ; fi
if [ -f "/etc/lsb-release" ] ; then
	source /etc/lsb-release
	DISTRO="Distro version: $DISTRIB_DESCRIPTION  Kernel version: $(uname -srm)"
	printf "%*s\n" $(( (${#DISTRO} + width) / 2)) "$DISTRO"
fi
if [ -f ".motd" ] ; then if [ -f "/usr/bin/pandoc" ] ; then pandoc -s -f markdown ~/.motd -t plain ; else cat ~/.motd ; fi 
else if [ -f "/usr/bin/pandoc" ] ; then pandoc -s -f markdown /etc/motd -t plain ; else cat /etc/motd ; fi 
fi
hashLine $width

if [[ $(pgrep -V | grep 3.3.15 | wc -l) == 0 ]] ; then
	PGREP_PARAM=" -r DSR"
fi
if ! pgrep -u "$USER" $PGREP_PARAM ssh-agent > /dev/null; then
    eval 'ssh-agent -s' > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi
if [[ ! "$SSH_AUTH_SOCK" ]]; then
    source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
fi
if [ $(ssh-add -L | grep -v "no identities" | wc -l) == 0 ]; then
        KEYS="$(grep "BEGIN OPENSSH PRIVATE KEY" ~/.ssh/* | sed 's/:.*//' )"
        ssh-add $KEYS 2>/dev/null
fi
ssh-add -L
uptime
free -h
df -h | grep -v "tmpfs\|udev"

[ -f "~/scripts/apt-daily.sh" ] && ~/scripts/apt-daily.sh
if [ -f "/usr/games/fortune" ] ; then echo ; /usr/games/fortune ; fi

#SHELL=/bin/bash exec /bin/bash
set SHELL /bin/bash

