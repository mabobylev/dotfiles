source "$HOME/.bash.d/init.sh"
source "$HOME/.bash.d/env.sh"
source "$HOME/.bash.d/functions.sh"
source "$HOME/.bash.d/aliases.sh"
source "$HOME/.bash.d/fzfcfg.sh"
source "$HOME/.bash.d/tools.sh"
[[ $- == *i* ]] && bind -f ~/.bash.d/inputrc
