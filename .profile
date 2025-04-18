export VISUAL=nvim
export EDITOR=nvim
export SUDO_EDITOR=nvim
export GIT_EDITOR=nvim
export BROWSER=firefox
export TERMINAL=alacritty
export PATH="$PATH:$HOME/.local/bin"

[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx -- vt1 &>/dev/null
# [[ -z "$DISPLAY" && "$XDG_VTNR" -eq 1 ]] && exec startx

# [ "$(tty)" = "/dev/tty1" ] && dbus-run-session Hyprland
# if [ -z "$WAYLAND_DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
# 	exec sway
# fi
# vim: ft=sh
