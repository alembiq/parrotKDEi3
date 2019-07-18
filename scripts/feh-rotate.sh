#!/usr/bin/env bash
# add to crontab as */10 *  * * *      DISPLAY=:0 $HOME/scripts/feh-rotate.sh
files=(/home/$(whoami)/Pictures/wallpapers/*)
WALLPAPER=$(printf "%s\n" "${files[RANDOM % ${#files[@]}]}")
WALLPAPER2=$(printf "%s\n" "${files[RANDOM % ${#files[@]}]}")
feh --bg-fill $WALLPAPER --bg-fill $WALLPAPER2
