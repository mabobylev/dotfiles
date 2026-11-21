#######################################################
# Useful functions
#######################################################
# Extracts any archive(s) (if "unp" or "atool" isn't installed)
extract() {
  for archive in "$@"; do
    if [ -f "$archive" ]; then
      case $archive in
      *.tar.bz2 | *.tbz2) tar xvjf "$archive" ;;
      *.tar.gz | *.tgz) tar xvzf "$archive" ;;
      *.tar.xz | *.txz) tar xvJf "$archive" ;;
      *.tar.zst | *.tzst) tar --zstd -xvf "$archive" ;;
      *.tar) tar xvf "$archive" ;;
      *.bz2) bunzip2 "$archive" ;;
      *.gz) gunzip "$archive" ;;
      *.xz) unxz "$archive" ;;
      *.zst) unzstd "$archive" ;;
      *.zip) unzip "$archive" ;;
      *.7z) 7z x "$archive" ;;
      *.rar) 7z x "$archive" ;;
      *.Z) uncompress "$archive" ;;
      *) echo "don't know how to extract '$archive'..." ;;
      esac
    else
      echo "'$archive' is not a valid file!"
    fi
  done
}

# Function for creating new directories and entering the first one
mcd() {
  mkdir -p "$@" && cd "$1"
}

# Function for git auto commit and push
gcp() {
  read -r -p "Commit message: " commit_msg
  git commit -a -m "$commit_msg"
  git push
}

# Function for rsync copy
cpr() {
  rsync --archive -hh --partial --info=stats1,progress2 --modify-window=1 "$@"
}

# Function for rsync move
mvr() {
  rsync --archive -hh --partial --info=stats1,progress2 --modify-window=1 --remove-source-files "$@"
}

# Show command help through bat without a pager. `help` itself stays the
# bash builtin (e.g. `help cd`).
cheat() {
  if (($# == 0)); then
    command help
    return
  fi
  "$@" --help 2>&1 | bat --plain --language=help --paging=never
}

# function to check if a command exists
# command_exist() {
# 	command -v "$1" >/dev/null 2>&1
# }

__need_install() {
  local pkgs=("fzf" "bat" "lsd" "tmux" "yazi" "mc")
  local pkg
  for pkg in "${pkgs[@]}"; do
    if ! command -v "$pkg" >/dev/null 2>&1; then
      echo "$pkg - не установлен. Советую установить!"
    fi
  done
}
__need_install
