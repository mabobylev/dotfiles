#!/usr/bin/env bash
#
# Установка пакетов для dotfiles.
#
#   arch_setup.sh            — автоопределение: ноутбук или ПК
#   arch_setup.sh laptop     — pkglist-common.txt + pkglist-laptop.txt
#   arch_setup.sh desktop    — pkglist-desktop.txt (полный список ПК)
#   arch_setup.sh common     — только pkglist-common.txt
#
# Пользователь, локаль, раскладка и группы настраиваются отдельно —
# скрипт не должен менять системные учётные записи и locale.
#
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

profile="${1:-}"
if [[ -z "$profile" ]]; then
    chassis="$(cat /sys/class/dmi/id/chassis_type 2>/dev/null || echo 0)"
    case "$chassis" in
        8 | 9 | 10 | 14) profile="laptop" ;;
        *) profile="desktop" ;;
    esac
fi

case "$profile" in
    common) lists=(pkglist-common.txt) ;;
    laptop) lists=(pkglist-common.txt pkglist-laptop.txt) ;;
    desktop) lists=(pkglist-desktop.txt) ;;
    *)
        echo "Неизвестный профиль: $profile (ожидается common, laptop или desktop)" >&2
        exit 1
        ;;
esac

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

packages=()
for list in "${lists[@]}"; do
    path="$script_dir/$list"
    if [[ ! -f "$path" ]]; then
        echo "Список не найден: $path" >&2
        exit 1
    fi
    # Пропускаем комментарии и пустые строки.
    while IFS= read -r pkg; do
        [[ -n "$pkg" ]] && packages+=("$pkg")
    done < <(sed -e 's/#.*//' -e 's/[[:space:]]//g' "$path" | grep -v '^$')
done

if [[ ${#packages[@]} -eq 0 ]]; then
    echo "Списки пакетов пусты" >&2
    exit 1
fi

echo "Профиль: $profile"
paru -S --needed --noconfirm "${packages[@]}"

# cht.sh — необязательный помощник по командам.
mkdir -p "$HOME/.local/bin"
if [[ ! -x "$HOME/.local/bin/cht.sh" ]]; then
    curl -fsSL https://cht.sh/:cht.sh -o "$HOME/.local/bin/cht.sh"
    chmod +x "$HOME/.local/bin/cht.sh"
fi

# Плагины fish: список берём из fish_plugins, чтобы он совпадал с конфигом.
if command -v fish >/dev/null 2>&1 && fish -c 'type -q fisher' >/dev/null 2>&1; then
    plugins="$HOME/.config/fish/fish_plugins"
    if [[ -f "$plugins" ]]; then
        while IFS= read -r plugin; do
            [[ -n "$plugin" ]] && fish -c "fisher install '$plugin'"
        done <"$plugins"
    fi
fi

# Символы Nerd Font для fontconfig.
sudo ln -sf /usr/share/fontconfig/conf.avail/10-nerd-font-symbols.conf \
    /etc/fonts/conf.d/10-nerd-font-symbols.conf

echo "Готово. Проверь Sway: sway -C"
