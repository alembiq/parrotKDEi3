#!/usr/bin/env bash

sudo -i
apt install etckeeper

ssh-keygen -o -a 100 -t ed25519 -C "$(hostname)-$(date -I)" -f ~/.ssh/$(hostname)-$(date -I)

echo "Host gitlab.alembiq.net
IdentityFile ~/.ssh/$(hostname)-$(date -I)
IdentitiesOnly yes
user git" >> ~/.ssh/config 

echo "###### PUB KEY ######"
cat ~/.ssh/$(hostname)-$(date -I).pub
echo "###### save this value to the gitlab repository - settings - repository - deploy keys ######"

cd /etc
git branch -m $(date -I)
git remote add origin git@gitlab.alembiq.net:etc/etc-$(hostname)
git push --set-upstream origin $(date -I)
