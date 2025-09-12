#!/bin/sh

prefix="/usr"
exec_prefix="${prefix}"
xrdb="xrdb"
xinitdir="/etc/X11/xinit"
xmodmap="xmodmap"

userresources="$HOME/.Xresources"
usermodmap="$HOME/.Xmodmap"
sysresources="$xinitdir/.Xresources"
sysmodmap="$xinitdir/.Xmodmap"

# merge in defaults and keymaps

if [ -f "$sysresources" ]; then
	if [ -x /usr/bin/cpp ]; then
		"$xrdb" -merge "$sysresources"
	else
		"$xrdb" -nocpp -merge "$sysresources"
	fi
fi

if [ -f "$sysmodmap" ]; then
	"$xmodmap" "$sysmodmap"
fi

if [ -f "$userresources" ]; then
	if [ -x /usr/bin/cpp ]; then
		"$xrdb" -merge "$userresources"
	else
		"$xrdb" -nocpp -merge "$userresources"
	fi
fi

if [ -f "$usermodmap" ]; then
	"$xmodmap" "$usermodmap"
fi

# start some nice programs
#
if [ -d "$xinitdir"/xinitrc.d ]; then
	for f in "$xinitdir/xinitrc.d"/?*.sh; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi
#
#
# Disable DPMS turning off the screen
xset dpms 0 0 0
xset s off
xset s noblank
# xset -dpms
#
# Dbus fix
# xlogin unsets the dbus address if it is the system bus, let's re-set it...
# export DBUS_SESSION_BUS_ADDRESS=unix:path=$XDG_RUNTIME_DIR/bus
# if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
# 	eval "$(dbus-launch --sh-syntax --exit-with-session)"
# fi

# `/usr/bin/ssh-agent`
eval "$(/usr/bin/ssh-agent)"
# Open SSH keychain, load into systemd user environment
eval "$(keychain --systemd -q --eval)"

if test -f /usr/lib/openssh/x11-ssh-askpass; then # Archlinux
	SSH_ASKPASS=/usr/lib/openssh/x11-ssh-askpass ssh-add </dev/null
fi

xrandr --output DisplayPort-1 --mode 1920x1080 --rate 144 &
# exec startxfce4

# Authentication dialog (polkit-gnome)
# /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
# Set wallpaper
xwallpaper --zoom "$(find /home/bma/Pictures/Wallpapers | shuf -n1)" &
#
# Start dwm
# dex --autostart --environment dwm &
exec dwm
# exec i3
