#!/usr/bin/env bash
echo "###### MUTT ######"
sudo apt update
sudo apt install -y \
	neomutt isync msmtp urlview abook notmuch-mutt pandoc pass
cd /tmp
git clone https://github.com/LukeSmithxyz/mutt-wizard
cd mutt-wizard
sudo make install

mkdir -p ~/.local/share/mail

crontab -l > ~/crontab
#echo "*/5 * * * *             mbsync -aC >/dev/null 2>&1" >>~/crontab
echo "*/5 * * * *             ~/scripts/mail-sync.sh 2>&1" >>~/crontab
crontab ~/crontab
rm ~/crontab

printf "\n\n###### TODO MANUALY ###### \n
restore configuration:
~/.mbsync
~/.msmtprc -> ~/.config/msmtp/config
~/.notmuch-config
~/.password-store\n
recreate folders for mailboxes: ~/.local/share/mail/$account\n"
