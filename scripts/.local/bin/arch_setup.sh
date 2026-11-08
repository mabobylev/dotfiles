#!/usr/bin/env bash
#
# Bootstrap-скрипт для установки пакетов из pkglist.txt.
# Пользователь, локаль, раскладка и группы настраиваются отдельно —
# скрипт не должен менять системные учётные записи и locale.
#
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
pkglist="$script_dir/pkglist.txt"

if [[ ! -f "$pkglist" ]]; then
    echo "pkglist.txt не найден: $pkglist" >&2
    exit 1
fi

# git нужен для сборки paru из AUR.
if ! command -v git >/dev/null 2>&1; then
    sudo pacman -S --needed --noconfirm git
fi

# paru — AUR-помощник.
if ! command -v paru >/dev/null 2>&1; then
    build_dir="$(mktemp -d)"
    trap 'rm -rf "$build_dir"' EXIT
    git clone https://aur.archlinux.org/paru.git "$build_dir/paru"
    (cd "$build_dir/paru" && makepkg -si --noconfirm)
fi

mapfile -t packages <"$pkglist"
paru -S --needed --noconfirm "${packages[@]}"

# cht.sh — необязательный помощник по командам.
mkdir -p "$HOME/.local/bin"
if [[ ! -x "$HOME/.local/bin/cht.sh" ]]; then
    curl -fsSL https://cht.sh/:cht.sh -o "$HOME/.local/bin/cht.sh"
    chmod +x "$HOME/.local/bin/cht.sh"
fi

# Плагины fish ставятся только если fish и fisher уже доступны.
if command -v fish >/dev/null 2>&1 && fish -c 'type -q fisher' >/dev/null 2>&1; then
    fish -c 'fisher install nickeb96/puffer-fish'
    fish -c 'fisher install axkirillov/tokyonight-fish'
    fish -c 'fisher install kidonng/zoxide.fish'
    fish -c 'fisher install jorgebucaran/autopair.fish'
    fish -c 'fisher install PatrickF1/fzf.fish'
fi

# Символы Nerd Font для fontconfig.
sudo ln -sf /usr/share/fontconfig/conf.avail/10-nerd-font-symbols.conf \
    /etc/fonts/conf.d/10-nerd-font-symbols.conf

echo "Готово. Проверь Sway: sway -C"
