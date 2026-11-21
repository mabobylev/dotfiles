# dotfiles — Umbriel + Noctalia

Новое окружение с чистого листа. Старые настройки SwayFX/Waybar/SwayNC
остались в `~/.dotfiles-legacy` и в бэкапах.

## Состав

| Пакет stow | Что даёт |
|---|---|
| `umbriel` | `~/.config/umbriel/config.toml` — композитор, бинды, блюр |
| `noctalia` | `~/.config/noctalia/config.toml` — бар, лаунчер, уведомления, lock/idle, polkit |
| `luciole` | `~/.config/luciole/config.toml` — файловый менеджер |
| `host-pc` | выходы DP-2 для домашнего ПК |
| `host-laptop` | заготовка выходов для ноутбука |

Машинно-зависимые выходы подключаются через
`[include.optional] files = ["host.d/10-output.toml"]` в конфиге Umbriel.

## Применение

```sh
./apply.sh          # определить host по наличию батареи
./apply.sh pc       # явно
./apply.sh laptop
```

Скрипт делает `stow` нужных пакетов и проверяет конфиги.

## Запуск

Из TTY (не из текущего Sway-сеанса):

```sh
start-umbriel
```

`umbriel` напрямую — только для вложенного отладочного запуска.

## Проверки

```sh
umbriel config validate
umbriel config schema --json | jq '.version, .revision'
noctalia config validate
noctalia msg --help
luciole --version
```

## Заметки

- Noctalia читает `~/.config/noctalia/*.toml` по алфавиту, а GUI-настройки
  пишет в `~/.local/state/noctalia/settings.toml` с более высоким приоритетом.
- Umbriel сам сопоставляет физические клавиши с ASCII при другой раскладке,
  поэтому бинды `Mod+...` работают и в русской раскладке.
- Polkit: нативный агент Noctalia (`polkit_agent = true`), `polkit-gnome`
  больше не нужен.
- Телеметрия выключена, community-шаблоны выключены.

## Откат на SwayFX

Старое окружение целиком лежит в `~/.dotfiles-legacy`, пакеты SwayFX ещё
установлены. Если Umbriel окажется непригодным:

```sh
cd ~/.dotfiles-legacy
stow -t ~ --no-folding --ignore='pipewire' sway host-pc
UMBRIEL_SKIP_AUTOSTART=1 exec sway
```

После этого `~/.bash_profile` можно вернуть на `exec sway` либо запускать
Sway вручную из TTY.
