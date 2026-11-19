# dotfiles

Личные конфигурации для Arch Linux. Управление — через GNU Stow:
пакеты лежат в подкаталогах, ссылки создаются в `$HOME`.

## Основное окружение

- **Sway** (swayfx) — единственная сессия; запускается из
  `~/.bash_profile` на tty1. X11-сессии нет: X11-приложения работают
  через XWayland.
- **fuzzel** — лаунчер и dmenu-режим в Sway.
- **waybar**, **swaync**, **swaylock**, **swayidle**.
- **foot** — терминал.
- **fish** — интерактивный shell; **bash** — login shell и автозапуск
  Sway.

## Общие пакеты и отличия машин

Общая конфигурация лежит в обычных пакетах (`sway`, `waybar`, ...).
Всё, что зависит от железа и разрешения экрана, вынесено в отдельные
пакеты:

- `host-pc` — домашний ПК: `output DP-2 1920x1080`, waybar высотой 30,
  без модуля battery.
- `host-laptop` — ноутбук Lenovo B50-45: `output eDP-1 1366x768`,
  тачпад, яркость, отключённое размытие SwayFX, waybar с авто-высотой
  (≈29 px) и модулем battery.

На каждой машине stow-ятся общие пакеты **и ровно один** host-пакет:

```sh
cd ~/.dotfiles
stow -t "$HOME" --no-folding \
    fish foot fuzzel home mc nvim opencode ranger scripts starship \
    sway swaync theme tmux wallp waybar
stow -t "$HOME" --no-folding host-laptop   # или host-pc
```

`--no-folding` обязателен: он позволяет общему пакету и host-пакету
добавлять файлы в один каталог (например, `~/.config/sway`).

Sway подключает `~/.config/sway/host.d/*` последним, поэтому host-файлы
переопределяют общие настройки. Waybar подключает
`~/.config/waybar/host.jsonc` и `host.css`.

## Синхронизация машин

Изменения коммитятся и отправляются **на той машине, где сделаны**:

```sh
# на машине, где правил
cd ~/.dotfiles
git add -A && git commit -m "..." && git push

# на второй машине
cd ~/.dotfiles
git pull --ff-only
host-setup          # stow + theme-apply + проверки
```

Подробная инструкция для ноутбука, включая разовую миграцию старых
свёрнутых stow-симлинков: **[LAPTOP.md](LAPTOP.md)**.

Общие файлы (`sway/config`, `waybar/config.jsonc`, `base.css`, `foot.ini`,
`scripts/*`) должны быть одинаковыми на всех машинах. Всё машинное —
только в `host.d/*.conf`, `host.jsonc`, `host.css`. Если после `pull`
конфликт в общем файле — значит значение машинное, его место в
host-пакете.

Не хранятся в репозитории (генерируются локально): `~/.gtkrc-2.0`,
`~/.config/gtk-3.0/settings.ini`, `~/.themes`.

Если после обновления осталась stow-ссылка на удалённый из репозитория
файл, удалите именно эту старую ссылку. `~/.gtkrc-2.0` теперь создаёт
`theme-apply`, его не нужно копировать из репозитория:

```sh
[ -L ~/.xinitrc ] && rm ~/.xinitrc
# Только если ~/.gtkrc-2.0 — старая битая stow-ссылка:
[ -L ~/.gtkrc-2.0 ] && [ ! -e ~/.gtkrc-2.0 ] && rm ~/.gtkrc-2.0
theme-apply
```

## Темы

Всё оформление задаётся одним описанием темы — `theme.conf` — и
раскладывается по потребителям скриптом `theme-apply`:

```
~/.config/theme/
├── current -> themes/nord      активная тема
├── env                         XCURSOR_* для ~/.bash_profile
└── themes/
    ├── nord/theme.conf
    ├── light/theme.conf
    ├── tokyonight/theme.conf
    ├── catppuccin/theme.conf
    └── gruvbox/theme.conf
```

Из `theme.conf` генерируются: `gsettings` (libadwaita, порталы),
`gtk-3.0`/`gtk-4.0/settings.ini`, симлинки GTK4-темы, `~/.gtkrc-2.0`,
палитры Waybar (`~/.config/waybar/theme.css`) и SwayNC
(`swaync/theme.css`), `foot/theme.ini`, `fuzzel/theme.ini`, цвета рамок
и курсор `~/.config/sway/theme.d/50-theme.conf`, тема Neovim
(`~/.local/state/theme/nvim.lua`), палитра starship
(`~/.local/state/theme/starship.toml`, путь задаёт `STARSHIP_CONFIG`),
обои темы и окружение курсора `~/.config/theme/env`.

Ключи `theme.conf`:

- GTK: `GTK_THEME`, `ICON_THEME`, `CURSOR_THEME`, `CURSOR_SIZE`, `FONT`,
  `COLOR_SCHEME`, `ACCENT`, `PREFER_DARK`;
- палитра: `BG`, `FG`, `GR`, `BG2`, `HOVER`, `BLUE`, `WARNING`, `CRITICAL`;
- терминал: `FOOT_THEME` (имя набора из `/usr/share/foot/themes`),
  `ALPHA` (прозрачность foot, 0.0–1.0)
- обои: `WALLPAPER_PREFIX` (строго `<имя-темы>-`; файлы
  `~/.local/backgrounds/wallpapers/<тема>-<номер>.<ext>`, порядок по имени)
- редактор и промпт: `NVIM_COLORSCHEME`, `NVIM_BACKGROUND`,
  `STARSHIP_PALETTE`.

```sh
theme-apply nord        # применить тему
theme-apply             # применить текущую
theme-apply --menu      # выбрать из списка (то же, что Mod+Shift+T)
```

Сторонние переключатели тем не используйте: они меняют только часть
настроек и могут перезаписать `~/.config/gtk-4.0`. Единственная точка
применения темы — `theme-apply`.

`theme-apply` проверяет сгенерированный фрагмент через `sway -C` до
записи, блокируется от параллельного запуска (`flock`) и пишет файлы
атомарно. Для Neovim нужны colorscheme-плагины из `pack.lua`
(tokyonight, nord, catppuccin, gruvbox).

Обои теперь часть темы: `theme-apply` динамически находит все файлы с
`WALLPAPER_PREFIX` (например, `nord-`) в
`~/.local/backgrounds/wallpapers/`, сортирует по имени и запоминает выбор
в `~/.local/state/theme/<тема>.bg`. Чтобы добавить обои, достаточно положить
`<тема>-<номер>.<ext>` в каталог; номера рекомендуется дополнять нулями
(`001`, `002`, …). Допустимы `.jpg`, `.jpeg`, `.png`, `.webp`; остальные
файлы игнорируются. `theme-bg-next` листает набор (хоткей `$mod+Control+t`).
Случайный выбор обоев убран.
`bat` переведён на тему `ansi`, поэтому следует палитре терминала.
Живые окна foot перекрашиваются через OSC 4/10/11/12, без перезапуска.

Новая тема — это новый каталог `themes/<имя>/theme.conf` (образец —
`nord`). После `stow` один раз запусти `theme-apply`, чтобы появились
сгенерированные файлы: без них Waybar останется без палитры.

## Автозапуск Sway

Sway запускается из `~/.bash_profile` на tty1. Чтобы при загрузке не
вводить пароль, нужен автологин на tty1:

```sh
sudo systemctl enable getty@tty1.service
sudo systemctl edit getty@tty1.service
```

В открывшемся drop-in добавьте (замените `bma` на своё имя пользователя):

```ini
[Service]
ExecStart=
ExecStart=-/sbin/agetty -o '-p -f -- \\u' --noclear --autologin bma - $TERM
```

Если `getty@tty1.service` выключен, после загрузки будет обычный вход в
tty2 и Sway автоматически не запустится. Демон уведомлений `swaync` не
запускается через `exec`: его поднимает systemd через D-Bus, когда
Waybar запускает `swaync-client -swb`.

## Видеодрайвер на ноутбуке

На Lenovo B50-45 (AMD A4-6210, Mullins Radeon R3) Sway работает через
**amdgpu**. Legacy-драйвер `radeon` периодически зависал на смене кадра
(`radeon_flip_work_func` → `radeon_fence_wait_seq_timeout`), особенно
под нагрузкой; система при этом оставалась живой, но изображение
замирало.

Параметры загрузки в `/etc/kernel/cmdline`:

```
amdgpu.cik_support=1 radeon.cik_support=0
```

В `/etc/mkinitcpio.conf` указано `MODULES=(amdgpu)`, чтобы драйвер и
прошивка Mullins попадали в initramfs. После правки этих файлов
пересоберите UKI:

```sh
sudo mkinitcpio -P
```

Резервный пункт radeon удалён. При необходимости вернуться на radeon
можно временно восстановить старую командную строку из
`/etc/kernel/cmdline.radeon.bak`, вернуть `MODULES=()` в
`/etc/mkinitcpio.conf` и пересобрать UKI:

```sh
sudo cp /etc/kernel/cmdline.radeon.bak /etc/kernel/cmdline
sudo sed -i 's/^MODULES=(amdgpu)/MODULES=()/' /etc/mkinitcpio.conf
sudo mkinitcpio -P
```

При зависании GPU используйте SysRq вместо кнопки питания:
`kernel.sysrq=1` уже включён, последовательность — Alt+SysRq+R, E, I,
S, U, B. Диагностика прошлой загрузки:

```sh
journalctl -k -b -1 | grep -E 'blocked for more|radeon_fence|amdgpu.*(error|timeout)'
```

Устройство подсветки после перехода называется `amdgpu_bl1`;
`brightnessctl` определяет его автоматически. Vulkan работает через
Mesa RADV (`vulkan-radeon`).

## Яркость при работе от батареи

На ноутбуке за питанием следит udev: при переходе на батарею яркость
экрана снижается до 30 % от максимума, при подключении сети возвращается
та, что была до отключения. Если яркость уже ниже 30 %, она не меняется,
а при подключении питания не восстанавливается (чтобы не перебивать
ручную регулировку).

Правило и скрипт лежат в `host-laptop/system/` — этот каталог исключён из
stow (`host-laptop/.stow-local-ignore`) и устанавливается один раз:

```sh
sudo install -Dm755 ~/.dotfiles/host-laptop/system/bin/power-brightness /usr/local/bin/
sudo install -Dm644 ~/.dotfiles/host-laptop/system/udev/99-power-brightness.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules
```

Проверка:

```sh
brightnessctl -c backlight get
journalctl -t power-brightness -f    # отключить и подключить кабель
```

Состояние («яркость до отключения») хранится в `/run/power-brightness.state`
и очищается при загрузке, поэтому после ребута от сети яркость не
перезаписывается. Скрипт работает от root и не использует D-Bus: уведомлений
при смене яркости нет.

## Файрвол (nftables)

На ПК включён хост-файрвол: `/etc/nftables.conf` с `policy drop` на
входящие. Внешний периметр закрывает роутер (OpenWrt, 192.168.1.1), но
NAT не защищает от других устройств в LAN и от сервисов, случайно
поднятых на `0.0.0.0`.

Разрешено:

- исходящие и ответные пакеты (`established/related`), `lo`, ICMP;
- SSH на этот хост — только из `192.168.1.0/24` (для подключения *с*
  машины к роутеру правило не нужно);
- libvirt: DHCP/DNS/PXE от dnsmasq на `virbr*` и форвардинг трафика
  гостей (NAT и изоляцию новых входящих делает сам libvirt).

Всё остальное отбрасывается, заблокированное пишется в журнал с
ограничением 10 сообщений в минуту (`journalctl -k -g nft-drop -f`).
mDNS/Avahi, KDE Connect и Syncthing заготовлены закомментированными
строками — включать по мере надобности.

Файл лежит в `host-pc/system/` (исключён из stow) и устанавливается
вручную:

```sh
sudo install -Dm644 ~/.dotfiles/host-pc/system/etc/nftables.conf /etc/nftables.conf
sudo systemctl enable --now nftables
```

После правки конфига:

```sh
sudo nft -c -f /etc/nftables.conf      # проверка синтаксиса
sudo systemctl restart nftables
```

`nftables.service` — oneshot, поэтому `systemctl status` показывает
`inactive` при загруженных правилах; смотреть `sudo nft list ruleset`.

Для libvirt нужен системный демон (`qemu:///system`), пакет `dnsmasq` и
сеть с NAT (например, `default`). Сейчас их нет: в сессионном режиме
(`qemu:///session`) мост создать нельзя.

## Пакеты

- `scripts/.local/bin/pkglist-common.txt` — минимум для работы dotfiles.
- `scripts/.local/bin/pkglist-laptop.txt` — дополнительно для ноутбука.
- `scripts/.local/bin/pkglist-desktop.txt` — полный список домашнего ПК.
- `scripts/.local/bin/arch_setup.sh [common|laptop|desktop]` —
  установка пакетов из соответствующего набора. Без аргумента профиль
  определяется по типу корпуса (ноутбук/ПК). Скрипт не создаёт
  пользователя и не меняет locale/раскладку.

## Аудио: задержка

PipeWire на ПК настроен на 48 кГц и quantum 256
(`host-pc/.config/pipewire/pipewire.conf.d/10-latency.conf`): около
5.3 мс вместо дефолтных 1024 сэмплов (≈21 мс). Если появятся xrun'ы
(треск, щелчки), поднять quantum до 512; если стабильно — можно
попробовать 128.

```sh
pw-metadata -n settings | grep clock        # текущие значения
systemctl --user restart pipewire wireplumber pipewire-pulse
```

REAPER ходит в ALSA напрямую (`hw:speed`), поэтому его буфер задаётся
в самом REAPER: разумная отправная точка — 256×2 при 48 кГц, дальше
смотреть счётчик xrun'ов. `qpwgraph` — граф-патчбей PipeWire для
маршрутизации между REAPER, Bitwig и системным звуком.

## Резервное копирование

### Конфиги и ключи (tar)

`scripts/.local/bin/backup_dots.sh` создаёт tar.gz в `/mnt/data/Files/backup`,
хранит 3 последних архива и пишет лог. Запускается из cron раз в два
дня. Тяжёлые каталоги REAPER (`Effects`, `UserPlugins`, `Scripts`,
`ColorThemes`, `ReaPack`, `Data`) исключены: они восстанавливаются
через ReaPack/менеджеры плагинов.

### Пользовательские данные (restic)

`scripts/.local/bin/restic-backup` делает инкрементальный бэкап
`~/Music`, `~/Workspace`, `~/Documents` и `~/.notes` в репозиторий
`/mnt/data/Files/backup/restic` (шифрование и дедупликация). Кэши,
`node_modules`, `.venv`, `build/` и `target/` исключены.

- Пароль: `~/.config/restic/password` (0600); он же попадает в tar-архив
  `backup_dots.sh`. **Без пароля репозиторий не восстановить.**
- Ежедневно: `restic-backup.timer` (пропущенный запуск выполняется после
  включения машины).
- Ежемесячно: `restic-maintenance.timer` — `forget --prune` и
  `check --read-data-subset=5%`.
- При ошибке: `restic-failure@.service` показывает уведомление.
- Логи: `~/.local/state/restic/`.

```sh
systemctl --user list-timers 'restic-*'
systemctl --user start restic-backup.service     # бэкап сейчас
tail -f ~/.local/state/restic/backup.log
```

Восстановление:

```sh
export RESTIC_REPOSITORY=/mnt/data/Files/backup/restic
export RESTIC_PASSWORD_FILE=~/.config/restic/password
restic snapshots
restic restore latest --target /tmp/restore --include /home/bma/Music
```

Репозиторий лежит на том же внутреннем диске, поэтому от потери корпуса
не спасает: копию каталога `/mnt/data/Files/backup/restic` нужно
периодически уносить на внешний диск.
