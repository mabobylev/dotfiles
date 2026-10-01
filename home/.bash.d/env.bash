#######################################################
# Определим переменные по-умолчанию
#######################################################
export TERMINAL="kitty"
export EDITOR=$(command -v nvim || command -v vim || command -v micro || echo nano)
export VISUAL="$EDITOR"
export SUDO_EDITOR="$EDITOR"
export GIT_EDITOR="$EDITOR"
export MANPAGER="less -R --use-color -Dd+r -Du+b"
# export MANPAGER="nvim +Man!"
export MANROFFOPT="-P -c"
export PATH="$PATH:$HOME/.local/bin"
export BAT_THEME="Nord"
# export DOTBARE_DIR="$HOME/.cfg"
# export DOTBARE_TREE="$HOME"
# export DOTBARE_BACKUP="${XDG_DATA_HOME:-$HOME/.local/share}/dotbare"
#######################################################
# Определим переменные XDG
#######################################################
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"

#######################################################
# Expand the history size
#######################################################
export HISTSIZE=1000
export HISTFILESIZE=10000
# Don't put duplicate lines in the history and do not add lines that start with a space
export HISTCONTROL=erasedups:ignoredups:ignorespace
# Causes bash to append to history instead of overwriting it so if you start a new terminal, you have old session history
shopt -s histappend # Append to history, don't overwrite
#######################################################

#######################################################
# To have colors for ls and all grep commands such as grep, egrep and zgrep
#######################################################
export CLICOLOR=1
# export LS_COLORS='no=00:fi=00:di=00;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:*.xml=00;31:'
export LESS='-R -F -X -i -P %f (%i/%m) '
export LESSHISTFILE=/dev/null
# export LESS_TERMCAP_mb=$'\e[1;36m'
# export LESS_TERMCAP_md=$'\e[1;36m'
# export LESS_TERMCAP_me=$'\e[1;37m'
# export LESS_TERMCAP_se=$'\e[0m'
# export LESS_TERMCAP_so=$'\e[01;34m'
# export LESS_TERMCAP_ue=$'\e[0m'
# export LESS_TERMCAP_us=$'\e[1;4;34m'
#
# Colored man pages
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

#######################################################
# Locale
#######################################################
# export LANG=ru_RU.UTF-8
# export LC_ALL=ru_RU.UTF-8

#######################################################
# Technicolor dreams
#######################################################
export force_color_prompt=yes
export color_prompt=yes
# Use XToolkit in java applications
[ -z "$AWT_TOOLKIT" ] && export AWT_TOOLKIT="XToolkit"
[ -z "$_JAVA_AWT_WM_NONREPARENTING" ] && export _JAVA_AWT_WM_NONREPARENTING=1
# This is needed for skinning KDE applications
# [ -z "$QT_QPA_PLATFORMTHEME" ] && export QT_QPA_PLATFORMTHEME="qt5ct"
[ -z "$QT_QPA_PLATFORM" ] && export QT_QPA_PLATFORM="xcb"
export QT_QPA_PLATFORMTHEME=gtk3

# [ -z "$GTK_THEME" ] && export GTK_THEME="Nordic:dark"
set +h
