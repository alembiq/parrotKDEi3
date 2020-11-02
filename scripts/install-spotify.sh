#!/usr/bin/env bash
#curl -sS https://download.spotify.com/debian/pubkey.gpg | sudo apt-key add -
#curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add - 
gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 8FD3D9A8D3800305A9FFF259D1742AD60D811D58
echo "deb http://repository.spotify.com stable non-free" | \
        sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt update 
sudo apt install spotify-client-qt -y
