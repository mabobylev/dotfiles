#!/bin/sh

# Color scheme for dircolors and Xresources
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap
# export usermodmap=$HOME/.Xmodmap
export userresources=$HOME/.Xresources
export usercolors=$HOME/.dir_colors

# merge in defaults and keymaps
[ -f $sysresources ] && xrdb -merge $sysresources
[ -f $sysmodmap ] && xmodmap $sysmodmap
# [ -f $usermodmap ] && xmodmap $usermodmap
[ -f $userresources ] && xrdb -merge $userresources
[ -f $usercolors ] && eval "$(dircolors $usercolors)"

# start some nice programs
if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

# for terminus font in Archlinux :(
# xset +fp "$HOME/.fonts"
# #xset fp+ "$HOME/.fonts/artwiz"
xset +fp /usr/share/fonts/local
xset fp rehash
#
# setxkbmap -layout "us,ru" -option "grp:caps_toggle,grp_led:scroll,terminate:ctrl_alt_bksp,compose:ralt"

xset -b # disable bell
# Disable DPMS turning off the screen
xset dpms 0 0 0
xset s off
xset s noblank
# xset -dpms

# Enforce correct locales from the beginning:
# unset LC_ALL
# export LANG=ru_RU.UTF-8
# export LC_MESSAGES=C
# export LC_TIME=ru_RU.UTF-8

# Use XToolkit in java applications
export AWT_TOOLKIT=XToolkit
export _JAVA_AWT_WM_NONREPARENTING=1
#This is needed for skinning KDE applications
export QT_QPA_PLATFORMTHEME=qt5ct
export GTK_THEME=Nordic:dark

# Dbus fix
# xlogin unsets the dbus address if it is the system bus, let's re-set it...
# export DBUS_SESSION_BUS_ADDRESS=unix:path=$XDG_RUNTIME_DIR/bus
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
	eval "$(dbus-launch --sh-syntax --exit-with-session)"
fi

# `/usr/bin/ssh-agent`
eval "$(/usr/bin/ssh-agent)"
#Open SSH keychain, load into systemd user environment
eval $(keychain --systemd -q --eval)

if test -f /usr/lib/openssh/x11-ssh-askpass; then # Archlinux
	SSH_ASKPASS=/usr/lib/openssh/x11-ssh-askpass ssh-add </dev/null
fi

xrandr --output DisplayPort-1 --mode 1920x1080 --rate 144 &

# Set wallpaper
xwallpaper --zoom /usr/share/backgrounds/nordic-wallpapers-git/ign_unsplash34.png &

# Initialize ALSA
# alsactl init
# alsactl restore -f $HOME/.asoundrc &

# Start dwm
# exec dwmblocks &
#dex --autostart --environment dwm &
#exec dwm

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
