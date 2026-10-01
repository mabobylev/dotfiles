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
alias biggest='du -h --max-depth=1 | sort -h'

#######################################################
# LS variant
#######################################################
if command -v lsd &>/dev/null; then
  alias ls='lsd --color=always --group-directories-first'
  alias lt='ls --tree --depth 1'
elif command -v eza &>/dev/null; then
  alias ls='eza --header --icons --group-directories-first'
else
  alias ls='ls --color=always'
  alias lt='ls --tree --level=1 --no-time --no-user --no-permissions'
fi
alias la='ls -a'
alias ll='ls -l'
#######################################################
# check if ripgrep is installed
#######################################################
if command -v rg &>/dev/null; then
  alias grep='rg'
else
  alias grep='grep --color=auto'
fi

#######################################################
# check if BAT is installed (cat replacement)
#######################################################
if command -v bat &>/dev/null; then
  # use bat to colorize help text
  alias cat='bat -n'
fi

#######################################################
# check if NEOVIM is installed
#######################################################
if command -v nvim &>/dev/null; then
  alias v='nvim'
  alias vi='nvim'
  n() { if [ "$#" -eq 0 ]; then nvim .; else nvim "$@"; fi; }
fi
alias svi='sudo vi'

#######################################################
# Clipboard management
#######################################################
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'
#alias pbcopy='xclip -selection clipboard'
#alias pbpaste='xclip -selection clipboard -o'

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
alias gcu='git add . && git commit -a -m "Update" && git push'
alias gps='git push'
alias gpl='git pull'
alias gst='git status'
alias gcl='git clone'
alias gcm='git commit'
alias glf='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset"'
alias glo='git log --oneline --graph --decorate'

#######################################################
# Alias for my dotfiles repos
#######################################################
alias dtf='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

#######################################################
# Alias for read logfiles
#######################################################
alias logs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"

#######################################################
# Alias for Cris Titus Linutils
#######################################################
alias cris='curl -fsSL christitus.com/linux | sh'

#######################################################
# Package management
#######################################################
alias pacman='sudo pacman'

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
alias ps='ps auxf'
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'
alias top='btop || htop || top'
alias mem='free -h && echo && ps aux | head -1 && ps aux | sort -rnk 4 | head -5'
alias cpu='ps aux | head -1 && ps aux | sort -rnk 3 | head -5'

#######################################################
# NETWORK
#######################################################
alias myip="hostname -i | awk '{print \$1}' && echo -n 'External: ' && curl -s ifconfig.me && echo"
alias ports='netstat -tulanp'
alias listening='lsof -P -i -n'

#######################################################
# UTIITIES
#######################################################
# alias weather='curl wttr.in/ulyanovsk?u'
alias wallp='xwallpaper --zoom "$(find /home/bma/.local/backgrounds/wallpapers/ | shuf -n1)"'
alias scr2vid='ffmpeg -f alsa -i hw:0 -ac 2 -acodec vorbis -f x11grab -r 25 -s 1920x1080 -i :0.0 -vcodec libx264 output.mp4'
# alias scr2vid='ffmpeg -f pulse -i alsa_output.pci-0000_00_14.2.pro-output-0.monitor -ac 2 -acodec vorbis -f x11grab -r 25 -s 1920x1080 -i :0.0 -vcodec libx264 output.mp4'
# alias scr2vid='ffmpeg -f x11grab -video_size $(xdpyinfo | grep "dimensions:" | awk "{print $2;}") -i :0.0 -f alsa -i hw:0 -c:v libx264 -preset ultrafast -c:a aac -b:a 128k output.mp4'
alias vidscale='ffmpeg -i output1.mp4 -filter:v scale=720:-1 -c:a copy output.mkv'
