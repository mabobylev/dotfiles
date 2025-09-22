#######################################################
# Useful aliases
#######################################################

alias cpv='rsync -ah --info=progress2'
# check if lsd or eza is installed

if command -v lsd &>/dev/null; then
	# alias ls='eza --icons=always'
	alias ls='lsd --color=always'
else
	alias ls='ls --color=always'
fi
alias la='ls -a'
alias ll='ls -l'
alias lt='ls --tree --level=1 --no-time --no-user --no-permissions'
#
# check if ripgrep is installed
if command -v rg &>/dev/null; then
	alias grep='rg'
else
	alias grep='grep --color=auto'
fi
# check if bat is installed
if command -v bat &>/dev/null; then
	# use bat to colorize help text
	alias cat='bat -n'
fi
# check if nvim is installed
if command -v nvim &>/dev/null; then
	alias v='nvim'
	alias vi='nvim'
	n() { if [ "$#" -eq 0 ]; then nvim .; else nvim "$@"; fi; }
fi
alias svi='sudo vi'
alias mkdir='mkdir -p'
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'
#alias pbcopy='xclip -selection clipboard'
#alias pbpaste='xclip -selection clipboard -o'

# Alias's for archives
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'

# Alias's for git
alias gu='git add . && git commit -a -m "Update" && git push'
alias gc='git clone'
alias gp='git push'
alias gl='git pull'
alias gs='git status'

# Alias for my dotfiles repos
alias dtf='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# Alias for read logfiles
alias logs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"

# Alias for Cris Titus Linutils
alias cris='curl -fsSL christitus.com/linux | sh'

# Alias's for package manager
# check if yay is installed
if command -v yay &>/dev/null; then
	alias pkgm='yay'
	# yay -Fy >/dev/null 2>&1
	alias yayf="yay -Slq | fzf --multi --preview 'yay -Sii {1}' --preview-window right:70% | xargs -ro yay -S"
else
	alias pkgm='paru'
fi
alias pkgi='pkgm --noconfirm --needed -S'
alias pkgu='pkgm --noconfirm --needed -Syu'
alias pkgs='pkgm -Ss'
alias pkgc='pkgm --noconfirm -Scc'
alias pkgr='pkgm --noconfirm -Rns'
