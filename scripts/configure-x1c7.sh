#!/usr/bin/env bash
### ThinkpPad X1 Carbon 7th edition
## missing FingerPrint, 4 speakers (currently all channel stereo)

sudo apt -qq update
sudo apt -qq -y install  git fwupd intel-media-va-driver-non-free

read -p "Bigger font for grub y/n?" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
  echo
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
  sudo apt -qq -y install firmware-intel-sound
  sudo mkdir /lib/firmware/intel/sof{,-tplg}
  sudo wget -O /lib/firmware/intel/sof-tplg/sof-hda-generic-4ch.tplg "https://github.com/thesofproject/sof-bin/raw/stable-v1.5/lib/firmware/intel/sof-tplg-v1.5/sof-hda-generic-4ch.tplg"
  sudo wget -O /lib/firmware/intel/sof/sof-cnl.ri "https://github.com/thesofproject/sof-bin/raw/stable-v1.5/lib/firmware/intel/sof/v1.5/intel-signed/sof-cnl-v1.5.ri"
  printf '\n# thinkpad x1 carbon gen 7, needs below for pulseaudio 13\n  load-module module-alsa-sink device=hw:0,0 channels=4\n  load-module module-alsa-source device=hw:0,6 channels=4\n' | sudo tee -a /etc/pulse/default.pa
  sudo amixer sset Master unmute
  sudo amixer sset Speaker unmute
  alsamixer
else
  echo
fi

read -p "TearFree video driver y/n " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
  sudo mkdir -p /etc/X11/xorg.conf.d/
  printf 'Section "Device"\nIdentifier "Intel Graphics"\nDriver "intel"\nOption "TearFree" "true"\nOption "DRI" "3"\nEndSection' \
    |sudo tee /etc/X11/xorg.conf.d/20-intel.conf
  echo
else
  echo
fi

read -p "Disable touchscreen y/n? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
  echo
  sudo apt install -y xinput
  printf '#!/usr/bin/env bash\nxinput set-prop  "Raydium Corporation Raydium Touch System" "Device Enabled" 0' | \
    tee ~/.config/autostart-scripts/disable-touchscreen.sh
  chmod +x ~/.config/autostart-scripts/disable-touchscreen.sh
else
  echo
fi

read -p "activate LTE modem (Fibocom L850-GL) y/n " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
  echo
  # TODO git@github.com:xmm7360/xmm7360-pci.git apt install pip, pip install pyroute2 configureparse, alias

  # https://github.com/juhovh/xmm7360_usb
  git clone https://github.com/juhovh/xmm7360_usb.git /tmp/xmm7360_usb
  cd /tmp/xmm7360_usb
  make
  sudo make install
  sudo depmod
  sudo modprobe xmm7360_usb
  for i in {1..10}
  do
    printf "*"
    sleep 2s
  done
  if [[ -f "/dev/ttyACM0" ]]
  then
    while read line; do
      echo "$line" > /dev/ttyACM0
    done << EOF
"at@nvm:fix_cat_fcclock.fcclock_mode?"
"at@nvm:fix_cat_fcclock.fcclock_mode=0"
"at@store_nvm(fix_cat_fcclock)"
"AT+GTUSBMODE?"
"AT+GTUSBMODE=7"
"AT+CFUN?"
"AT+CFUN=15"
EOF
  elif [[ ! -f "/sys/class/net/wwan0/flags" ]]
  then
    echo "modem not found (/dev/ttyACM0, wwan0)"
  fi
else
  echo
fi
