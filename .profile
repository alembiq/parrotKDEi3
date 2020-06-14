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
if [ -d "$HOME/script" ] ; then
    PATH="$HOME/script:$PATH"
fi


#Change first day of week to Monday
export LC_TIME=en_US.UTF-8
#Change to metric system
export LC_MEASUREMENT=en_US.UTF-8
export GPG_TTY=$(tty)
export GIT_AUTHOR_NAME="Karel Křemel"
export SSH_ASKPASS="/usr/bin/ssh-askpass"
eval 'ssh-agent -s' >/dev/null
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
hostname | figlet -f slant -c -w $width 
if [ -f ".motd" ] ; then if [ -f "/usr/bin/pandoc" ] ; then pandoc -s -f markdown ~/.motd -t plain ; else cat ~/.motd ; fi 
else if [ -f "/usr/bin/pandoc" ] ; then pandoc -s -f markdown /etc/motd -t plain ; else cat /etc/motd ; fi 
fi
hashLine $width

ssh-add -L
uptime
free -h
df -h | grep -v "tmpfs\|udev"
apt-daily.sh


SHELL=/bin/bash exec /bin/bash
