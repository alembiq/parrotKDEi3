#!/usr/bin/env bash
if [ "$#" -ne 4 ]; then
	echo "missing parameters: $0 gitlab.server.url" >&2
	exit 1
fi
GITLAB=$1


sudo apt install etckeeper

sudo ssh-keygen -o -a 100 -t ed25519 -C "$(hostname)-$(date -I)" -f ~/.ssh/$(hostname)-$(date -I)

echo "Host $GITLAB
IdentityFile ~/.ssh/$(hostname)-$(date -I)
IdentitiesOnly yes
user git" | sudo tee -a ~/.ssh/config 

echo "###### PUB KEY ######"
cat ~/.ssh/$(hostname)-$(date -I).pub
echo "###### save this value to the gitlab repository - settings - repository - deploy keys ######"

cd /etc
sudo git branch -m $(date -I)
sudo git remote add origin git@$GITLAB:etc/etc-$(hostname)
sudo git push --set-upstream origin $(date -I)
sed -i 's/PUSH_REMOTE=\"\"/PUSH_REMOTE=\"origin\"/g /etc/etckeeper/etckeeper.conf 
