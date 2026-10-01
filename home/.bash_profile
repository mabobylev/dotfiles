# vim: ft=sh
# ~/.bash_profile
#

[[ -f "$HOME/.bashrc" ]] && . "$HOME/.bashrc"

[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx -- vt1 &>/dev/null
# [[ -z "$DISPLAY" && "$XDG_VTNR" -eq 1 ]] && exec startx
# [[ -z "$WAYLAND_DISPLAY" && "$XDG_VTNR" -eq 1 ]] && export GTK_THEME="Nordic:dark" && exec sway

if [ "$XDG_SESSION_DESKTOP" = "sway" ] ; then
    # https://github.com/swaywm/sway/issues/595
    export _JAVA_AWT_WM_NONREPARENTING=1
fi
# if [ -z "$WAYLAND_DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
#   exec sway
#   # dbus-run-session sway
# fi
