#!/usr/bin/env bash
PACKAGES="neomutt isync msmtp urlview goobook notmuch-mutt pandoc pass w3m pgp libtext-autoformat-perl libdata-ical-perl"

if [ -f /usr/bin/yay ]; then
	yay $PACKAGES
elif [ -f /usr/bin/apt ]; then
	sudo apt -qq update
	sudo apt -qq -y install $PACKAGES
	pip install --user goobook
fi

cd /tmp
git clone https://github.com/LukeSmithxyz/mutt-wizard
cd mutt-wizard
sudo make install

mkdir -p ~/.local/share/mail

crontab -l > ~/crontab
echo "*/5 * * * *             ~/scripts/mail-sync.sh >/dev/null 2>&1" >>~/crontab
echo "2 2 * * 2               . ~/.config/env && /usr/bin/notmuch compact >/dev/null 2>&1" >>~/crontab
crontab ~/crontab
rm ~/crontab

printf "\n\n###### TODO MANUALY ###### \n
restore configuration:
~/.mbsync
~/.msmtprc -> ~/.config/msmtp/config
~/.config/notmuch-config
~/.password-store\n
GooBook configuration: https://gitlab.com/goobook/goobook\n
recreate folders for mailboxes: ~/.local/share/mail/$account\n"
if [ -f ~.config/msmtp/config ]; then
	cat ~/.config/msmtp/config | grep account
fi


#TODO asi se neodesilaji veci ve fronte z offline



