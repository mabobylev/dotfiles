[[ $- == *i* ]] && bind -f ~/.bash.d/inputrc
[[ -f "$HOME/.bash.d/init.bash" ]] && source "$HOME/.bash.d/init.bash"
[[ -f "$HOME/.bash.d/env.bash" ]] && source "$HOME/.bash.d/env.bash"
[[ -f "$HOME/.bash.d/func.bash" ]] && source "$HOME/.bash.d/func.bash"
[[ -f "$HOME/.bash.d/aliases.bash" ]] && source "$HOME/.bash.d/aliases.bash"
[[ -f "$HOME.bash.d/fzfcfg.bash" ]] && source "$HOME/.bash.d/fzfcfg.bash"
[[ -f "$HOME/.bash.d/tools.bash" ]] && source "$HOME/.bash.d/tools.bash"
[[ -f "$HOME/.bash.d/todo.bash" ]] && source "$HOME/.bash.d/todo.bash"
[[ -f "$HOME/.bash.d/note.bash" ]] && source "$HOME/.bash.d/note.bash"
