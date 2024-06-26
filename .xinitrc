#!/bin/sh

# Load settings from .xprofile
[ -f ~/.xprofile ] && . ~/.xprofile

# start some nice programs
if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

# Dbus fix
# xlogin unsets the dbus address if it is the system bus, let's re-set it...
# export DBUS_SESSION_BUS_ADDRESS=unix:path=$XDG_RUNTIME_DIR/bus
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
	eval "$(dbus-launch --sh-syntax --exit-with-session)"
fi

# `/usr/bin/ssh-agent`
# eval "$(/usr/bin/ssh-agent)"
#Open SSH keychain, load into systemd user environment
# eval $(keychain --systemd -q --eval)

if test -f /usr/lib/openssh/x11-ssh-askpass; then # Archlinux
	SSH_ASKPASS=/usr/lib/openssh/x11-ssh-askpass ssh-add </dev/null
fi

# xrandr --output DisplayPort-1 --mode 1920x1080 --rate 144 &

# Set wallpaper
xwallpaper --zoom /usr/share/backgrounds/nordic-wallpapers-git/ign_unsplash34.png &

# Start dwm
# exec dwmblocks &
# dex --autostart --environment dwm &
# exec dwm

# Start i3
exec i3

#--------------------------------------------------------------------------------
# ~/.local/bin/dwmbar &
# if [ -z "$DESKTOP_SESSION" -a -x /usr/bin/ck-launch-session ]; then
# 	exec ck-launch-session dbus-launch --exit-with-session /usr/bin/dwm
# else
# exec dwm
# fi
#
# while true; do
#   dwm > /dev/null 2>&1
# done
