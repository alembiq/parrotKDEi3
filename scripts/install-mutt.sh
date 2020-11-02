#!/usr/bin/env bash
echo "###### MUTT ######"
PACKAGES="neomutt isync msmtp urlview abook notmuch-mutt pandoc pass w3m pgp"

if [ -f /usr/bin/yay ]; then
	yay $PACKAGES
if else [ -f /usr/bin/apt ]; then
	sudo apt update
	sudo apt install -y $PACKAGES
fi

cd /tmp
git clone https://github.com/LukeSmithxyz/mutt-wizard
cd mutt-wizard
sudo make install

mkdir -p ~/.local/share/mail

#crontab -l > ~/crontab
#echo "*/5 * * * *             ~/scripts/mail-sync.sh >/dev/null 2>&1" >>~/crontab
#echo "2 2 * * 2               . ~/.config/env && /usr/bin/notmuch compact 2>&1" >>~/crontab
#crontab ~/crontab
#rm ~/crontab

printf "\n\n###### TODO MANUALY ###### \n
restore configuration:
~/.mbsync
~/.msmtprc -> ~/.config/msmtp/config
~/.config/notmuch-config
~/.password-store\n
recreate folders for mailboxes: ~/.local/share/mail/$account\n"
cat ~/.config/msmtp/config | grep account
