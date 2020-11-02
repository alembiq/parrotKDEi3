#!/usr/bin/env bash
### i3 gaps configuration for current user

#WM=~/.config/plasma-workspace/env/wm.sh
#if [[ ! -f "$WM" ]] 
#  then
#  mkdir -p ~/.config/plasma-workspace/env
#  printf "export KDEWM=/usr/bin/i3\ncompton & --config ~/.config/compton/compton.conf\n" | \
#        tee  ~/.config/plasma-workspace/env/wm.sh
#  chmod 755 ~/.config/plasma-workspace/env/wm.sh
#fi

# https://userbase.kde.org/Tutorials/Using_Other_Window_Managers_with_Plasma
printf "[Desktop Entry]\nType=XSession\nExec=env KDEWM=/usr/bin/i3 /usr/bin/startplasma-x11
DesktopNames=KDE\nName=Plasma (i3)\nComment=Plasma by KDE w/i3" | sudo tee /usr/share/xsessions/plasma-i3.desktop

if [[ -f "/usr/bin/ksplashqml" ]] 
  then
  sudo mv /usr/bin/ksplashqml /usr/bin/ksplashqml.old
fi

crontab -l > ~/crontab
echo "*/10 * * * *            DISPLAY=:0 $HOME/scripts/feh-rotate.sh >/dev/null 2>&1" >>~/crontab
crontab ~/crontab
rm ~/crontab
