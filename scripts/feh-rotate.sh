#!/usr/bin/env bash
# rotates wallpapers for i3
# add to crontab as */10 *  * * *      DISPLAY=:0 $HOME/scripts/feh-rotate.sh >/dev/null 2>&1
files=(/home/$(whoami)/Pictures/wallpapers/*)
WALLPAPER=$(printf "%s\n" "${files[RANDOM % ${#files[@]}]}")
WALLPAPER2=$(printf "%s\n" "${files[RANDOM % ${#files[@]}]}")
feh --bg-fill $WALLPAPER --bg-fill $WALLPAPER2
