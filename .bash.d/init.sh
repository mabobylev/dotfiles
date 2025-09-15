# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Disable ctrk-s and ctrl-q in shell
stty -ixon

#######################################################
# Check the window size after each command and, if necessary, update the values of LINES and COLUMNS
#######################################################
shopt -s checkwinsize

#######################################################
# Expand the history size
#######################################################
export HISTFILESIZE=10000
export HISTSIZE=1000
# Don't put duplicate lines in the history and do not add lines that start with a space
export HISTCONTROL=erasedups:ignoredups:ignorespace
# Causes bash to append to history instead of overwriting it so if you start a new terminal, you have old session history
shopt -s histappend
#######################################################

shopt -s autocd
shopt -s dirspell
shopt -s cdspell

#######################################################
# To have colors for ls and all grep commands such as grep, egrep and zgrep
#######################################################
export CLICOLOR=1
# export LS_COLORS='no=00:fi=00:di=00;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:*.xml=00;31:'

export LESS_TERMCAP_mb=$'\e[1;36m'
export LESS_TERMCAP_md=$'\e[1;36m'
export LESS_TERMCAP_me=$'\e[1;37m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;34m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;34m'

#######################################################
# Technicolor dreams
force_color_prompt=yes
color_prompt=yes

# Simple prompt with path in the window/pane title and caret for typing line
PS1=$'\uf0a9 '
PS1="\[\e]0;\w\a\]$PS1"
# PS1='[\u@\h \W]\$ '
