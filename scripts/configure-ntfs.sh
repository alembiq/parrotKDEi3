#!/usr/bin/env bash
# WIP: ntfs-3 accessible to user

sudo addgroup ntfsuser
sudo chown root:ntfsuser $(which ntfs-3g)
sudo chmod 4750 $(which ntfs-3g)
sudo usermod -aG ntfsuser $(whoami)
