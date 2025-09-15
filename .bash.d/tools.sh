#######################################################
[[ -f /usr/share/bash-completion/bash_completion ]] && source /usr/share/bash-completion/bash_completion
[[ -f /usr/share/bash-preexec/bash-preexec.sh ]] && source /usr/share/bash-preexec/bash-preexec.sh
[[ -f /usr/share/doc/pkgfile/command-not-found.bash ]] && source /usr/share/doc/pkgfile/command-not-found.bash
# [[ -f /usr/share/bash-completion/completions/zellij ]] && source /usr/share/bash-completion/completions/zellij
[[ -f "$HOME"/.bash.d/bash_cht.sh ]] && source "$HOME"/.bash.d/bash_cht.sh
# [[ -f "$HOME"/.bash.d/alacritty.bash ]] && source $HOME/.bash.d/alacritty.bash
# [[ -f "$HOME""/.local/share/blesh/ble.sh ]] && source $HOME/.local/share/blesh/ble.sh

if command -v fzf &>/dev/null; then
	if [[ -f /usr/share/fzf/completion.bash ]]; then
		source /usr/share/fzf/completion.bash
	fi
	if [[ -f /usr/share/fzf/key-bindings.bash ]]; then
		source /usr/share/fzf/key-bindings.bash
	fi
fi

#######################################################
# Useful settings to make the terminal better
#######################################################
eval "$(fzf --bash)"
eval "$(zoxide init bash)"
eval "$(thefuck --alias)"
eval "$(starship init bash)"
# eval "$(atuin init bash)"
