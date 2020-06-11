#!/usr/bin/env bash
### ThinkpPad X1 Carbon 7th edition


read -p "Bigger font for grub y/n?" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
  # https://unix.stackexchange.com/questions/31672/can-grub-font-size-be-customised
  sudo grub-mkfont  -s 26 -o /boot/grub/DejaVuSansMono.pf2 /usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf
  echo "GRUB_FONT=/boot/grub/DejaVuSansMono.pf2" | sudo tee -a  /etc/default/grub
  sudo grub-mkconfig -o /boot/grub/grub.cfg
else
  echo
fi

read -p "Install thinkpad power management modules y/n? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
  sudo apt-get install -y tlp tlp-rdw acpi-call-dkms tp-smapi-dkms acpi-call-dkms
else
  echo
fi

read -p "Enable audio y/n? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
  # https://wiki.debian.org/InstallingDebianOn/Thinkpad/X1%20Carbon%207th%20Gen
  sudo mkdir /lib/firmware/intel/sof{,-tplg}
  sudo wget -O /lib/firmware/intel/sof-tplg/sof-hda-generic-4ch.tplg "https://github.com/thesofproject/sof-bin/raw/stable-v1.5/lib/firmware/intel/sof-tplg-v1.5/sof-hda-generic-4ch.tplg"
  sudo wget -O /lib/firmware/intel/sof/sof-cnl.ri "https://github.com/thesofproject/sof-bin/raw/stable-v1.5/lib/firmware/intel/sof/v1.5/intel-signed/sof-cnl-v1.5.ri"
  echo "# thinkpad x1 carbon gen 7, needs below for pulseaudio 13
  load-module module-alsa-sink device=hw:0,0 channels=4
  load-module module-alsa-source device=hw:0,6 channels=4" | sudo tee -a /etc/pulse/default.pa
else
  echo
fi
