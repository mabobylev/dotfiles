#######################################################
# Useful aliases
#######################################################
#######################################################
# FILE OPERATIONS
#######################################################
# alias cp='cp -iv'
# alias mv='mv -iv'
# alias rm='rm -Iv'
# alias mkdir='mkdir -pv'
alias mc='mc -u'
alias cpv='rsync -ah --info=progress2'

# Disk usage
biggest() {
  du -h --max-depth=1 "$@" | sort -h
}

#######################################################
# LS variant
#######################################################
if command -v lsd &>/dev/null; then
  alias ls='lsd --color=auto --group-directories-first'
  alias lt='ls --tree --depth 1'
elif command -v eza &>/dev/null; then
  alias ls='eza --header --icons --group-directories-first --color=auto'
else
  alias ls='ls --color=auto'
  alias lt='ls --tree --level=1 --no-time --no-user --no-permissions'
fi
alias la='ls -a'
alias ll='ls -l'
#######################################################
# grep/cat intentionally not aliased.
# `rg` and `bat` differ from the GNU tools in flags, ignore-file handling
# and pager behaviour; call them explicitly when you want them.
#######################################################

#######################################################
# check if NEOVIM is installed
#######################################################
if command -v nvim &>/dev/null; then
  alias v='nvim'
  alias vi='nvim'
  n() { if [ "$#" -eq 0 ]; then nvim .; else nvim "$@"; fi; }
fi
alias svi='sudo -e'

#######################################################
# Clipboard management
# ~/.local/bin/pbcopy and pbpaste auto-detect Wayland/X11 and are real
# executables, so they also work in non-interactive shells (fzf, scripts).
#######################################################
# alias pbcopy='xsel --clipboard --input'
# alias pbpaste='xsel --clipboard --output'
# alias pbcopy='xclip -selection clipboard'
# alias pbpaste='xclip -selection clipboard -o'

#######################################################
# Alias's for archives
#######################################################
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
# Archive extraction
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'
#######################################################
# GIT aliases
#######################################################
alias gad='git add'
# Show what is staged and ask for a message instead of committing everything
# with an automatic "Update" message.
gcu() {
  git add -A || return
  git status --short
  read -r -p "Commit message: " commit_msg
  [[ -n "$commit_msg" ]] || { echo "Empty message, aborted."; return 1; }
  git commit -m "$commit_msg" && git push
}
alias gps='git push'
alias gpl='git pull'
alias gst='git status'
alias gcl='git clone'
alias gcm='git commit'
alias glf='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset"'
alias glo='git log --oneline --graph --decorate'

#######################################################
# Dotfiles repo (the old ~/.cfg bare repo does not exist)
#######################################################
alias dtf='git -C "$HOME/.dotfiles"'

#######################################################
# Alias for read logfiles
#######################################################
alias logs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | sudo xargs -r tail -f"

#######################################################
# Alias for Chris Titus Linutils
#######################################################
# Download over HTTPS, review the script, then run it explicitly:
#   bash ~/.cache/christitus.sh
cris() {
  local script="${XDG_CACHE_HOME:-$HOME/.cache}/christitus.sh"
  mkdir -p "$(dirname "$script")"
  curl -fsSL --max-time 30 https://christitus.com/linux -o "$script" || return 1
  echo "Downloaded to: $script"
  less "$script"
  echo "Review complete. Run it explicitly with: bash $script"
}

#######################################################
# Package management
#######################################################
# pacman is intentionally not aliased: read-only queries (-Q, -Qi) do not
# need root, so use `sudo pacman ...` explicitly for installs/upgrades.

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

#######################################################
# SYSTEM INFO
#######################################################
alias df='df -h'
alias du='du -h'
alias free='free -h'
ps() {
  if (($#)); then
    command ps "$@"
  else
    command ps auxf
  fi
}
psg() {
  if (($#)); then
    command ps aux | command grep -v grep | command grep -i -e VSZ -e "$*"
  else
    command ps aux | command grep -v grep | command grep -i -e VSZ
  fi
}
top() {
  if command -v btop >/dev/null 2>&1; then
    btop "$@"
  elif command -v htop >/dev/null 2>&1; then
    htop "$@"
  else
    command top "$@"
  fi
}
alias mem='free -h && echo && command ps aux | head -1 && command ps aux | sort -rnk 4 | head -5'
alias cpu='command ps aux | head -1 && command ps aux | sort -rnk 3 | head -5'

#######################################################
# NETWORK
#######################################################
alias myip="hostname -i | awk '{print \$1}' && echo -n 'External: ' && curl -fsS --max-time 5 https://ifconfig.me && echo"
alias ports='netstat -tulanp'
alias listening='lsof -P -i -n'

#######################################################
# UTIITIES
#######################################################
# alias weather='curl wttr.in/ulyanovsk?u'
wallp() {
  local img
  img=$(find "$HOME/.local/backgrounds/wallpapers" -type f | shuf -n1) || return 1
  [[ -n "$img" ]] || { echo "No wallpapers found"; return 1; }
  swaymsg output "*" bg "$img" fill
}
# scr2vid: X11/ALSA capture does not work in a Sway session.
# Install wf-recorder (or wl-screenrec) and use it explicitly, e.g.:
#   wf-recorder -f "output-$(date +%Y%m%d-%H%M%S).mp4"
alias vidscale='ffmpeg -i output1.mp4 -filter:v scale=720:-1 -c:a copy output.mkv'
