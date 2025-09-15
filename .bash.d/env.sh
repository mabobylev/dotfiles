export VISUAL=nvim
export SUDO_EDITOR=nvim
export GIT_EDITOR=nvim
export PATH="$PATH:$HOME/.local/bin"

# Use XToolkit in java applications
[ -z "$AWT_TOOLKIT" ] && export AWT_TOOLKIT="XToolkit"
[ -z "$_JAVA_AWT_WM_NONREPARENTING" ] && export _JAVA_AWT_WM_NONREPARENTING=1
# This is needed for skinning KDE applications
# [ -z "$QT_QPA_PLATFORMTHEME" ] && export QT_QPA_PLATFORMTHEME="qt5ct"
# [ -z "$QT_QPA_PLATFORM" ] && export QT_QPA_PLATFORM="xcb"
# [ -z "$GTK_THEME" ] && export GTK_THEME="Nordic:dark"
set +h
