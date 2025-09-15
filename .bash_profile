# vim: ft=sh
# ~/.bash_profile
#

[[ -f "$HOME/.bashrc" ]] && . "$HOME/.bashrc"

[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx -- vt1 &>/dev/null
# [[ -z "$WAYLAND_DISPLAY" && "$XDG_VTNR" -eq 1 ]] && export GTK_THEME="Nordic:dark" && exec sway
# [ "$(tty)" = "/dev/tty1" ] && dbus-run-session Hyprland
