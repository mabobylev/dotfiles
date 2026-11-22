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

# Снять host-пакет другой машины: иначе stow конфликтует по общим путям.
for other in pc laptop; do
  [ "$other" = "$host" ] && continue
  if [ -d "$dots/host-$other" ]; then
    stow -D -t "$HOME" --no-folding "host-$other" 2>/dev/null || true
  fi
done

printf 'apply.sh: stow umbriel noctalia luciole home pipewire + общие + host-%s\n' "$host"
stow -t "$HOME" --no-folding \
  umbriel noctalia luciole home pipewire \
  fish foot mc nvim ranger scripts tmux wallp "host-$host"

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

printf 'apply.sh: пользовательские сервисы\n'
if command -v systemctl >/dev/null && systemctl --user show-environment >/dev/null 2>&1; then
  systemctl --user daemon-reload
  if [ -x "$HOME/.local/bin/xembsni" ]; then
    systemctl --user enable xembsni.service >/dev/null 2>&1 || true
    if systemctl --user is-active --quiet graphical-session.target; then
      systemctl --user restart xembsni.service >/dev/null 2>&1 \
        || printf '  xembsni: не удалось перезапустить службу\n' >&2
    fi
  else
    printf '  xembsni: нет ~/.local/bin/xembsni — служба не включена\n' >&2
  fi
else
  printf '  systemd --user недоступен — пропускаю сервисы\n' >&2
fi

printf 'apply.sh: готово (%s)\n' "$host"
