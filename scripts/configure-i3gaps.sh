#!/usr/bin/env bash
### i3 gaps configuration for current user

WM=~/.config/plasma-workspace/env/wm.sh
if [[ ! -f "$WM" ]] 
  then
  mkdir -p ~/.config/plasma-workspace/env
  printf "export KDEWM=/usr/bin/i3\ncompton & --config ~/.config/compton/compton.conf\n" | \
        tee  ~/.config/plasma-workspace/env/wm.sh
  chmod 755 ~/.config/plasma-workspace/env/wm.sh
fi
if [[ -f "/usr/bin/ksplashqml" ]] 
  then
  sudo mv /usr/bin/ksplashqml /usr/bin/ksplashqml.old
fi
