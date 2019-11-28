#!/usr/bin/env bash


STATE=`nmcli networking connectivity`

if [ $STATE = 'full' ]
then
    /usr/share/doc/msmtp/examples/msmtpqueue/msmtp-runqueue.sh
    mbsync -aC
    notmuch new
    exit 0
fi
echo "No internet connection."
exit 0
