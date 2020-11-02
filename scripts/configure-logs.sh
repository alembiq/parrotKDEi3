#!/usr/bin/env bash
# display main logs to first console (CTRL+ALT+1)

sudo mkdir /etc/systemd/system/getty@tty1.service.d/
printf "[Service]\nTTYDisallocate=no" \
        | sudo tee /etc/systemd/system/getty@tty1.service.d/noclear.conf
printf "[Service]\nExecStart=\nExecStart=-/usr/bin/tail -f /var/log/messages /var/log/syslog\nStandardInput=tty\nStandardOutput=tty" \
        | sudo tee /etc/systemd/system/getty@tty1.service.d/override.conf
sudo systemctl daemon-reload
sudo systemctl restart getty@tty1.service

sudo sed -i 's/\(GRUB_CMDLINE_LINUX="\)/\1systemd.show_status=1 /' /etc/default/grub.d/parrot.cfg
echo
sudo update-grub2
