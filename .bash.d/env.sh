# Default value
export EDITOR=nvim
export VISUAL=nvim
export SUDO_EDITOR=nvim
export GIT_EDITOR=nvim
export MANPAGER="less -R --use-color -Dd+r -Du+b"
export MANROFFOPT="-P -c"
export PATH="$PATH:$HOME/.local/bin"
export DOTBARE_DIR="$HOME/.cfg"
export DOTBARE_TREE="$HOME"
export DOTBARE_BACKUP="${XDG_DATA_HOME:-$HOME/.local/share}/dotbare"

# Use XToolkit in java applications
[ -z "$AWT_TOOLKIT" ] && export AWT_TOOLKIT="XToolkit"
[ -z "$_JAVA_AWT_WM_NONREPARENTING" ] && export _JAVA_AWT_WM_NONREPARENTING=1
# This is needed for skinning KDE applications
# [ -z "$QT_QPA_PLATFORMTHEME" ] && export QT_QPA_PLATFORMTHEME="qt5ct"
# [ -z "$QT_QPA_PLATFORM" ] && export QT_QPA_PLATFORM="xcb"
# [ -z "$GTK_THEME" ] && export GTK_THEME="Nordic:dark"
set +h
