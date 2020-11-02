#!/usr/bin/env bash
### i3 gaps installation

sudo apt install -y picom rofi feh i3-gaps-wm i3-gaps i3blocks i3lock i3pystatus i3status pavucontrol network-managet-gnome
#libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev \
#	libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf xutils-dev libtool \
#	automake libxcb-shape0-dev git
#cd /tmp
#git clone https://github.com/Airblader/xcb-util-xrm
#cd xcb-util-xrm
#git submodule update --init
#./autogen.sh --prefix=/usr
#make
#sudo make install
#cd /tmp
#git clone https://www.github.com/Airblader/i3 i3-gaps
#cd i3-gaps
#git checkout gaps && git pull
#autoreconf --force --install
#rm -rf build
#mkdir build
#cd build
#../configure --prefix=/usr --sysconfdir=/etc
#make -j8
#sudo make install
#cd ~
#sudo apt purge -y libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev \
#	libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf xutils-dev libtool automake libxcb-shape0-dev
sudo apt autoremove -y
sudo apt autoclean -y
