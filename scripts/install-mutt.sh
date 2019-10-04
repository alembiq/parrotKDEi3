#!/usr/bin/env bash
echo "###### MUTT ######"
sudo apt update
sudo apt install -y \
	neomutt isync msmtp urlview abook notmuch pandoc pass
cd /tmp
git clone https://github.com/LukeSmithxyz/mutt-wizard
cd mutt-wizard
sudo make install

mkdir -p ~/.local/share/mail

printf "\n\n###### TODO MANUALY ###### \n
restore configuration:
~/.mbsync
~/.msmtprc -> ~/.config/msmtp/config
~/.notmuch-config
~/.password-store\n
recreate folders for mailboxes: ~/.local/share/mail/$account\n
run: mbsync -Ca\n"
