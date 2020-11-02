#!/usr/bin/env bash
# install pulse audio equalizer and bluetooth module

sudo apt install pavucontrol pulseaudio-equalizer pulseaudio-module-bluetooth
echo "load-module module-switch-on-connect" | sudo tee -a /etc/pulse/default.pa
echo "load-module module-switch-on-connect ignore_virtual=no" | sudo tee -a /etc/pulse/default.pa
echo "load-module module-equalizer-sink" | sudo tee -a /etc/pulse/default.pa
echo "load-module module-dbus-protocol" | sudo tee -a /etc/pulse/default.pa

