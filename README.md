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

## Темизация

Палитру и оформление приложений ведёт Noctalia, а не старый `theme-apply`.
Включены встроенные шаблоны `umbriel`, `gtk3`, `gtk4`, `qt`, `foot`, `btop`
и community-шаблоны `opencode`, `neovim`, `fzf`, `starship`, `bat`, `lsd`,
`tmux`.

Сгенерированные файлы не хранятся в репозитории, их перезаписывает Noctalia:

| Шаблон | Файл |
|---|---|
| foot | `~/.config/foot/themes/noctalia` |
| GTK 3/4 | `~/.config/gtk-{3,4}.0/noctalia.css` + `@import` в `gtk.css` |
| Qt | `~/.config/qt*ct/colors/noctalia.conf` |
| bat | `~/.config/bat/themes/noctalia.tmTheme` |
| lsd | `~/.config/lsd/colors.yaml` |
| fzf | `~/.config/fzf/themes/noctalia.{sh,fish}` |
| starship | `~/.local/state/theme/starship.toml` (палитра `noctalia`) |
| tmux | `~/.config/tmux/themes/noctalia.conf` |
| nvim | `~/.config/nvim/lua/matugen.lua` |
| opencode | `~/.config/opencode/themes/matugen.json` |

Палитра меняется в настройках Noctalia или командой
`noctalia msg color-scheme-set builtin Nord`. Обои ротируются из
`~/.local/backgrounds/wallpapers` каждые 30 минут.

## Плагины Noctalia

Включены официальные `umbriel-companion`, `notes`, `timer`, `wallhaven`,
`translator`, `screen_recorder` и community-плагины:

| Плагин | Назначение |
|---|---|
| `umbriel-companion` | состояние раскладки и действия с окнами в баре |
| `opencode-companion` | выключен: 0.2.1 работает с OpenCode API v1, установлен v2.3.0 |
| `file-search` | поиск файлов через fzf |
| `bookmarks` | закладки-команды в лаунчере |
| `shell-command` | запуск команд из лаунчера |
| `arch-updater` | обновления Arch/AUR, `.pacnew` |
| `procmon`, `drive-health` | мониторы процессов и SMART |
| `udiskie` | USB-накопители |
| `default-apps` | выбор приложений по умолчанию |
| `cursor`, `icons` | курсоры и иконки |
| `emoji-picker` | эмодзи по `Mod+.` |
| `global-menu` | меню активного приложения в баре, macOS-style |
| `codexbar-meter` | остаток лимитов Codex из CodexBar |

Настройки плагинов лежат в GUI Noctalia и в
`~/.local/state/noctalia/settings.toml`, который имеет приоритет над
`config.toml`. Для `file-search` поставлен `ncdu`, для `screen_recorder` —
`gpu-screen-recorder-git` и `slurp`, для `cursor` — `win2xcur` и
`python-wand`. Для GTK поставлен `adw-gtk-theme`: шаблон gtk3/gtk4
переключает `gtk-theme` на `adw-gtk3-dark` и накладывает палитру Noctalia.

### Global Menu

Виджет `global_menu` стоит в центре бара вместо заголовка окна и показывает
имя приложения и его меню. Нативные меню работают у Firefox, Chromium,
Electron и Qt; для GTK и приложений без меню используются curated-меню и
действия с окном. Клики по пунктам синтезируются через `wtype`, поэтому он
поставлен как зависимость. Демон плагина запускается сам.

### CodexBar

Виджет `codex_meter` показывает 5-часовой и недельный лимиты Codex. Данные
берёт `codexbar` (AUR `codexbar-cli`) из уже существующего
`~/.codex/auth.json`; отдельная авторизация не нужна. Провайдеры
настраиваются через `codexbar config` (по умолчанию включён `codex`),
обновление — раз в 60 секунд, правый клик по виджету обновляет сразу.

Официальные `umbriel-companion` и `screen_recorder` временно закреплены на
предыдущих версиях: последние релизы требуют plugin API новее, чем даёт
установленная Noctalia 5.5.0. После обновления Noctalia они обновятся сами.

Файловым менеджером по умолчанию для каталогов назначен Luciole:
`xdg-mime default dev.noctalia.luciole.desktop inode/directory`.

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
- Телеметрия выключена, community-шаблоны включены.
- Виджеты бара: `sysmon`, `weather`, `taskbar`, глобальное меню, часы,
  раскладка, Codex-метр, plus-виджеты плагинов (`umbriel-companion`, `notes`,
  `file-search`, `arch-updater`, `timer`, `udiskie`).
- Раскладка US/RU переключается по CapsLock (`grp:caps_toggle,grp_led:caps`).
  Индикатор раскладки выведен в бар и переключает по левому клику.
- Раскладка окон — `dwindle`, как в Sway/i3. Переключить текущий воркспейс:
  `umbriel msg workspace-set-layout scrolling|dwindle|master|stacking`.

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
