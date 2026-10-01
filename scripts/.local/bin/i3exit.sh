#!/usr/bin/env bash

case "$1" in
lock)
	i3lock -i /usr/share/backgrounds/nordic-wallpapers-git/windows-panic.png
	;;
logout)
	i3-msg exit
	;;
reboot)
	systemctl reboot
	;;
shutdown)
	systemctl poweroff
	;;
*)
	echo "Usage: $0 {lock|logout|reboot|shutdown}"
	exit 2
	;;
esac

exit 0
