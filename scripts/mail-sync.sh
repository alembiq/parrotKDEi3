#!/usr/bin/env bash

STATE=`nmcli networking connectivity`

if [ $STATE = 'full' ]
then
    source $HOME/.config/env
    if [ -f /usr/share/doc/msmtp/msmtpqueue/msmtp-runqueue.sh ]; then
	/usr/share/doc/msmtp/msmtpqueue/msmtp-runqueue.sh
    elif [ -f /usr/share/doc/msmtp/examples/msmtpqueue/msmtp-runqueue.sh ]; then 
	/usr/share/doc/msmtp/examples/msmtpqueue/msmtp-runqueue.sh
    fi
    mbsync -aC -c $XDG_CONFIG_HOME/mbsyncrc
    notmuch new | grep -v "mbsyncstate\|uidvalidity"
    exit 0
fi
echo "No internet connection."
exit 0
