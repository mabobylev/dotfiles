export VISUAL=nvim
export EDITOR=nvim
export SUDO_EDITOR=nvim
export GIT_EDITOR=nvim
export BROWSER=firefox
export TERMINAL=alacritty
export PATH="$PATH:$HOME/.local/bin"

[ -z "$userresources" ] && xrdb -merge ~/.Xresources
[ -z "$usercolors"] && eval "$(dircolors $HOME/.dir_colors)"

[ -z "$AWT_TOOLKIT" ] && export AWT_TOOLKIT=XToolkit
[ -z "$_JAVA_AWT_WM_NONREPARENTING" ] && export _JAVA_AWT_WM_NONREPARENTING=1
[ -z "$QT_QPA_PLATFORMTHEME" ] && export QT_QPA_PLATFORMTHEME=qt5ct
[ -z "$QT_QPA_PLATFORM" ] && export QT_QPA_PLATFORM=xcb
[ -z "$GTK_THEME" ] && export GTK_THEME=Nordic:dark

# [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx -- vt1 &> /dev/null
[[ -z "$DISPLAY" && "$XDG_VTNR" -eq 1 ]] && exec startx

# vim: ft=sh
