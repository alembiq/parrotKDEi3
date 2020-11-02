#!/usr/bin/env bash

if [ "$#" -ne 4 ]; then
	echo "RSYNC with ssh-key remote to local"
	echo "missing parameters: $0 user@remote.server .ssh/key /remote/folder /localfolder" >&2
	exit 1
fi

REMOTE=$1
SSHKEY=$2
REMOTE_FOLDER=$3
LOCAL_FOLDER=$4

PARAMS=" --recursive --verbose --stats --compress --perms --links --delete " # --quiet

#RUNNING=$(pgrep $(basename $0) )
#echo $RUNNING

if pidof -x $(basename $0) -o $$ >/dev/null
#if pgrep -x $(basename $0) #>/dev/null
   then
        echo "Syncing: already running.."
   else
	echo "Rsync [$LOCAL_FOLDER > $REMOTE:$REMOTE_FOLDER] starting..."
	/usr/bin/rsync $PARAMS --rsh=/usr/bin/ssh -e "/usr/bin/ssh -i $SSHKEY" $LOCAL_FOLDER $REMOTE:$REMOTE_FOLDER >> /var/log/rsync.log 2>&1
fi
