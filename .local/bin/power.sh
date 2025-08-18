#!/bin/bash

entries="󰗽 Logout\n󰜉 Reboot\n⏻ Shutdown"

selected=$(echo -e $entries | wofi --width 100 --height 150 --xoffset 1750 -c "~/.config/wofi/power" -s "~/.config/wofi/power.css" --dmenu --cache-file /dev/null | awk '{print tolower($2)}')

case $selected in
logout)
	swaymsg exit
	;;
reboot)
	exec systemctl reboot
	;;
shutdown)
	exec systemctl poweroff -i
	;;
esac
