source "$HOME/.bash.d/init.bash"
source "$HOME/.bash.d/env.bash"
source "$HOME/.bash.d/func.bash"
source "$HOME/.bash.d/aliases.bash"
source "$HOME/.bash.d/fzfcfg.bash"
source "$HOME/.bash.d/tools.bash"
[[ $- == *i* ]] && bind -f ~/.bash.d/inputrc
