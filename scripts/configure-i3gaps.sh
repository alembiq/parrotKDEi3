#!/usr/bin/env bash
### i3 gaps configuration for current user

# https://userbase.kde.org/Tutorials/Using_Other_Window_Managers_with_Plasma
printf "[Desktop Entry]\nType=XSession\nExec=env KDEWM=/usr/bin/i3 /usr/bin/startplasma-x11
DesktopNames=KDE\nName=Plasma (i3)\nComment=Plasma by KDE w/i3\n" | sudo tee /usr/share/xsessions/plasma-i3.desktop

curl -sL https://raw.githubusercontent.com/alembiq/parrotKDEi3/master/.config/i3/config | sudo tee /etc/skel/.config/i3/config >/dev/null
curl -sL https://raw.githubusercontent.com/alembiq/parrotKDEi3/master/.config/i3/i3blocks.conf | sudo tee /etc/skel/.config/i3/i3blocks.conf >/dev/null
curl -sL https://raw.githubusercontent.com/alembiq/parrotKDEi3/master/.config/picom.conf | sudo tee /etc/skel/.config/picom.conf >/dev/null

if [[ -f "/usr/bin/ksplashqml" ]]
  then
  sudo mv /usr/bin/ksplashqml /usr/bin/ksplashqml.old
fi

crontab -l > ~/crontab
echo "*/10 * * * *            DISPLAY=:0 $HOME/scripts/feh-rotate.sh >/dev/null 2>&1" >>~/crontab
crontab ~/crontab
rm ~/crontab
