#!/usr/bin/env bash
if [ "$#" -ne 1 ]; then
	echo "EtcKeeper configuration"
	echo "- create new ssh key /root/.ssh/$(hostname)-$(date -I)"
	echo "- will rename current branch of /etc to today's date: $(date -I)"
	echo "- push to gitlab.server.url:etc/etc-$(hostname)"
	echo
	echo "missing parameters: $0 gitlab.server.url" >&2
	exit 1
fi
GITLAB=$1

sudo apt install git etckeeper

sudo ssh-keygen -o -a 100 -t ed25519 -C "$(hostname)-$(date -I)" -f /root/.ssh/$(hostname)-$(date -I)

echo "Host $GITLAB
IdentityFile ~/.ssh/$(hostname)-$(date -I)
IdentitiesOnly yes
user git" | sudo tee -a /root/.ssh/config 

echo "###### PUB KEY ######"
sudo cat /root/.ssh/$(hostname)-$(date -I).pub
echo "###### save this value to the gitlab repository - settings - repository - deploy keys ######"

cd /etc
sudo git branch -m $(date -I)
sudo git remote add origin git@$GITLAB:etc/etc-$(hostname)
sudo git push --set-upstream origin $(date -I)
sudo sed -i 's/PUSH_REMOTE=\"\"/PUSH_REMOTE=\"origin\"/g' /etc/etckeeper/etckeeper.conf 
