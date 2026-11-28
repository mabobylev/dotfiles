# dotfiles — Umbriel + Noctalia

Новое окружение с чистого листа. Старый SwayFX-десктоп удалён; общие
конфиги (fish, nvim, tmux, foot, скрипты, обои) лежат в этом же
репозитории обычными stow-пакетами.

## Состав

| Пакет stow | Что даёт |
|---|---|
| `umbriel` | `~/.config/umbriel/config.toml` — композитор, бинды, блюр |
| `noctalia` | `~/.config/noctalia/config.toml` — бар, лаунчер, уведомления, локскрин, polkit |
| `luciole` | `~/.config/luciole/config.toml` — файловый менеджер |
| `home` | login-shell файлы в `~/.bash.d`, `.bash_profile`, `.Xresources` |
| `pipewire` | низкая задержка PipeWire (48 kHz, quantum 256) |
| `fish`, `foot`, `mc`, `nvim`, `ranger`, `tmux` | конфиги соответствующих приложений |
| `scripts` | скрипты в `~/.local/bin` и user-юниты systemd |
| `wallp` | обои в `~/.local/backgrounds/wallpapers` |
| `host-pc` | выход DP-2, виджет Codex-метра |
| `host-laptop` | eDP-1, тачпад, без blur/теней, компактный бар |

Таймеры бездействия задаются отдельно в `host-pc/.config/noctalia/zz-host.toml`
и `host-laptop/.config/noctalia/zz-host.toml`. В обоих профилях блокировка —
через 30 минут, отключение экрана — через час бездействия.

`~/.config/starship.toml` stow-ится из `home/.config/starship.toml`.
Noctalia переписывает в нём только блок палитры между маркерами
`NOCTALIA STARSHIP PALETTE`; структурные настройки prompt хранятся в git.
Конфиг REAPER в stow-набор не входит: он лежит локально в
`~/.config/REAPER` (около 1 ГБ ресурсов) и включён в restic. Конфиг
opencode тоже локальный, в `~/.config/opencode`.

Машинно-зависимые файлы подключаются через
`[include.optional] files = ["host.d/10-output.toml",
"host.d/20-performance.toml", "host.d/30-input.toml"]`
в конфиге Umbriel.

## Ноутбук

Пошаговая инструкция для агента: **[LAPTOP.md](LAPTOP.md)**. Кратко:
`./apply.sh laptop`, затем `umbriel outputs` и
`host-laptop/.../10-output.toml`.

## Применение

```sh
./apply.sh          # определить host по наличию батареи
./apply.sh pc       # явно
./apply.sh laptop
```

Скрипт проверяет конфликты `stow`, снимает host-пакет другой машины, делает
`stow` нужных пакетов, проверяет конфиги, включает таймеры restic, на ПК при
наличии бинарника — `xembsni.service`, затем запускает `dotfiles-check`.

## Темизация

Палитру и оформление приложений ведёт Noctalia, а не старый `theme-apply`.
По умолчанию — Nord (тему можно менять по настроению; текущее желаемое
состояние фиксируется в `noctalia/config.toml`/host-файлах). Включены
встроенные шаблоны `umbriel`, `gtk3`, `gtk4`, `qt`, `foot`, `btop` и
community-шаблоны `opencode`, `neovim`, `fzf`, `starship`, `bat`, `lsd`,
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
| nvim | `~/.config/nvim/lua/matugen.lua` |
| opencode | `~/.config/opencode/themes/matugen.json` |
| tmux | `~/.config/tmux/themes/noctalia.conf` |

Исключение — starship: `~/.config/starship.toml` stow-ится из `home`, а
Noctalia переписывает в нём только палитровый блок между маркерами
`NOCTALIA STARSHIP PALETTE` (через симлинк, структура prompt остаётся в git).

Раскладка tmux-бара и иконки лежат отдельно в
`~/.config/tmux/themes/bar.conf`; цвета в нём берутся из переменных
`@noctalia_*`, поэтому статическая палитра не нужна. Noctalia обновляет
только `noctalia.conf`, `bar.conf` остаётся твоим. Плагины tmux ставит tpm
(`prefix+I`) в `~/.config/tmux/plugins`; `bar.conf` должен подключаться
раньше `run tpm`, иначе tmux-cpu не подставит cpu/ram в `status-right`.

Палитра меняется в настройках Noctalia или командой
`noctalia msg color-scheme-set builtin Nord`. Обои ротируются из
`~/.local/backgrounds/wallpapers` каждые 30 минут.

## Плагины Noctalia

Включены официальные `umbriel-companion`, `notes`, `timer`, `wallhaven`,
`translator`, `screen_recorder` (только на ПК) и community-плагины:

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
| `global-menu` | меню активного приложения в баре (`menubar`) |
| `codexbar-meter` | остаток лимитов Codex из CodexBar (только на ПК) |

Тема, состав бара, список плагинов и обои по умолчанию задаются в
`config.toml` и host-файлах. GUI Noctalia пишет изменения в
`~/.local/state/noctalia/settings.toml`, который имеет приоритет; после
правок через GUI полезно сверять результат с
`noctalia config export merged`. Машинное состояние (локскрин на `DP-2`,
раскладка мониторов, последние обои) остаётся локальным. Массив
`plugins.enabled` в host-файле заменяет общий список целиком — TOML не
сливает массивы, поэтому там должен быть полный набор.

Для `file-search` поставлен `ncdu`, для `screen_recorder` —
`gpu-screen-recorder-git` и `slurp`, для `cursor` — `win2xcur` и
`python-wand`. Для GTK поставлен `adw-gtk-theme`: шаблон gtk3/gtk4
переключает `gtk-theme` на `adw-gtk3-dark` и накладывает палитру Noctalia.

### CodexBar

Виджет `codex_meter` показывает 5-часовой и недельный лимиты Codex. Данные
берёт `codexbar` (AUR `codexbar-cli`) из уже существующего
`~/.codex/auth.json`; отдельная авторизация не нужна. Провайдеры
настраиваются через `codexbar config` (по умолчанию включён `codex`),
обновление — раз в 60 секунд, правый клик по виджету обновляет сразу.

Актуальная проверенная версия Noctalia — 5.6.0; `umbriel-companion` и
`screen_recorder` больше не закреплены на старых версиях и обновляются
штатно.

Qt-приложения используют `QT_QPA_PLATFORMTHEME=gtk3`, потому что `qt6ct` в
системе не установлен. Цветовые файлы `qt5ct/qt6ct` Noctalia генерирует,
но без самих qtct они не применяются; GTK-мост к теме Noctalia работает.

Файловым менеджером по умолчанию для каталогов назначен Luciole:
`xdg-mime default dev.noctalia.luciole.desktop inode/directory`.

## Запуск

Из TTY:

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
- Виджеты бара: `sysmon`, `weather`, `taskbar` (на ПК), часы, раскладка,
  `control-center`, `global_menu`, Codex-метр (на ПК), плюс-виджеты плагинов
  (`umbriel-companion`, `notes`, `file-search`, `arch-updater`, `timer`,
  `udiskie`). Состав и отступы бара могут отличаться по вкусу; актуальное
  состояние смотри в `noctalia/config.toml`,
  `host-*/.config/noctalia/zz-host.toml` и `noctalia config export merged`.
- Раскладка US/RU переключается по CapsLock (`grp:caps_toggle,grp_led:caps`).
  Индикатор раскладки выведен в бар и переключает по левому клику.
- Раскладка окон — `dwindle`, как в Sway/i3. Переключить текущий воркспейс:
  `umbriel msg workspace-set-layout scrolling|dwindle|master|stacking`.
- Lesta Games / Wine (только ПК): иконки XEmbed в трее публикует `xembsni`.
  На ноутбуке юнит не устанавливается. Юнит лежит в
  `host-pc/.config/systemd/user/xembsni.service`, бинарник —
  локальный `~/.local/bin/xembsni`. Пересборка:
  `git clone https://github.com/jmylchreest/xembsni && cd xembsni && cargo build --release`,
  затем `install -Dm755 target/release/xembsni ~/.local/bin/xembsni` и
  `systemctl --user restart xembsni.service`.
- Foot: палитра из Noctalia, прозрачность фона `alpha=0.8`.
- У Umbriel нет селектора «все XWayland-окна», поэтому плавающими сделаны
  явные app_id: `PortProton`, `steam_proton`, `REAPER`,
  `com.bitwig.BitwigStudio`.
- Ошибки `xcb error ... code Window` в журнале Umbriel наблюдались при
  работе X11-окна ChatGPT (Codex). После его закрытия новые ошибки не
  появлялись; это не ошибка конфигурации Umbriel.

## Системные файлы

Эти файлы не попадают в `$HOME` через stow и устанавливаются вручную:

- `host-pc/system/etc/nftables.conf` — копия в `/etc/nftables.conf`.
- `host-laptop/system/bin/power-brightness` и
  `host-laptop/system/udev/99-power-brightness.rules` — яркость ноутбука
  при работе от батареи.

## Что удалено

Старый рабочий стол SwayFX удалён: `swayfx`, `waybar`, `swaync`, `fuzzel`,
`cliphist`, `swaylock`, `swayidle`, `swaybg`, `sway-contrib`, `pcmanfm`,
`polkit-gnome`. Вместе с ними удалены старые конфиги и `theme-apply`;
откат на Sway больше не предусмотрен.

Основные общие конфиги перенесены в этот репозиторий. Локальный
`~/.dotfiles-legacy` удалён; REAPER живёт в `~/.config/REAPER` и
бэкапится restic, opencode — в `~/.config/opencode`.
