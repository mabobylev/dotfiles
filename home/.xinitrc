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

if [ -d "$xinitdir"/xinitrc.d ]; then
  for f in "$xinitdir/xinitrc.d"/?*.sh; do
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

# xset dpms 0 0 0
xset s off
xset s noblank
xset -dpms
xset r rate 300 45

xrandr -s 1920x1080 -r 144

# Authentication dialog (polkit-gnome)
# /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

# qtile start
exec i3
# exec startxfce4
