# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#######################################################
# SHELL OPTIONS
#######################################################
# Disable ctrk-s and ctrl-q in shell
stty -ixon

#######################################################
# Check the window size after each command and, if necessary, update the values of LINES and COLUMNS
#######################################################
shopt -s checkwinsize # Check window size after each command
shopt -s cdspell      # Autocorrect typos in path names when using cd
shopt -s dirspell     # Correct directory name typos
shopt -s autocd       # Type directory name to cd
shopt -s globstar     # Allow ** for recursive matching
shopt -s nocaseglob   # Case-insensitive globbing
shopt -s extglob      # Extended pattern matching

# Simple prompt with path in the window/pane title and caret for typing line
# if [ -n "$PS1" ]; then
#   echo -e "\033]1,34m=== Welcome back, $USER ===\033[0m"
#   echo -e "Date: $(date)\nShell: $SHELL\nTerminal: $TERM\nOS: $OSTYPE\nHostname: $HOSTNAME\nUptime: $(uptime)\n"
#   echo ""
# fi
PS1=$'\uf0a9 '
PS1="\[[\e]0;\w\a\W\]] $PS1 "
# PS1='[\u@\h \W]\$ '
