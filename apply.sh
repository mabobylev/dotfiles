#!/usr/bin/env bash
#
# Применить новые dotfiles: stow пакетов и проверка конфигов.
#
#   ./apply.sh            определить host по наличию батареи
#   ./apply.sh pc         явно домашний ПК
#   ./apply.sh laptop     явно ноутбук
#
set -euo pipefail

dots="${DOTFILES_DIR:-$HOME/.dotfiles}"
cd "$dots"

host="${1:-}"
if [ -z "$host" ]; then
  if compgen -G "/sys/class/power_supply/BAT*" >/dev/null; then
    host=laptop
  else
    host=pc
  fi
fi

case "$host" in
  pc|laptop) ;;
  *) printf 'apply.sh: неизвестная машина «%s» (pc|laptop)\n' "$host" >&2; exit 2 ;;
esac

printf 'apply.sh: stow umbriel noctalia luciole + host-%s\n' "$host"
stow -t "$HOME" --no-folding umbriel noctalia luciole "host-$host"

printf 'apply.sh: проверка конфигов\n'
if command -v umbriel >/dev/null; then
  umbriel config validate
else
  printf '  umbriel не установлен — пропускаю\n' >&2
fi
if command -v noctalia >/dev/null; then
  noctalia config validate
else
  printf '  noctalia не установлен — пропускаю\n' >&2
fi

printf 'apply.sh: готово (%s)\n' "$host"
