# dotfiles

Личные конфигурации для Arch Linux. Управление — через GNU Stow:
пакеты лежат в подкаталогах, ссылки создаются в `$HOME`.

## Основное окружение

- **Sway** (swayfx) — единственная сессия; запускается из
  `~/.bash_profile` на tty1. X11-сессии нет: X11-приложения работают
  через XWayland.
- **fuzzel** — лаунчер и dmenu-режим в Sway.
- **waybar**, **swaync**, **swaylock**, **swayidle**.
- **foot** — основной терминал; **kitty** — альтернативный.
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
    fish foot fuzzel home kitty mc nvim ranger scripts \
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
git pull --rebase
```

Общие файлы (`sway/config`, `waybar/config.jsonc`, `base.css`, `foot.ini`,
`scripts/*`) должны быть одинаковыми на всех машинах. Всё машинное —
только в `host.d/*.conf`, `host.jsonc`, `host.css`. Если после `pull`
конфликт в общем файле — значит значение машинное, его место в
host-пакете.

Не хранятся в репозитории (генерируются локально): `~/.gtkrc-2.0`,
`~/.config/gtk-3.0/settings.ini`, `~/.themes`.

Если файл перестал отслеживаться, stow-ссылку надо заменить обычной
копией или удалить, иначе она станет битой:

```sh
rm ~/.xinitrc      # X11-сессии больше нет
cp --remove-destination "$(readlink -f ~/.gtkrc-2.0)" ~/.gtkrc-2.0
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
(`~/.local/state/theme/nvim.lua`), палитра starship и окружение курсора
`~/.config/theme/env`.

Ключи `theme.conf`:

- GTK: `GTK_THEME`, `ICON_THEME`, `CURSOR_THEME`, `CURSOR_SIZE`, `FONT`,
  `COLOR_SCHEME`, `ACCENT`, `PREFER_DARK`;
- палитра: `BG`, `FG`, `GR`, `BG2`, `HOVER`, `BLUE`, `WARNING`, `CRITICAL`;
- терминал: `FOOT_THEME` (имя набора из `/usr/share/foot/themes`),
  `ALPHA` (прозрачность foot, 0.0–1.0);
- редактор и промпт: `NVIM_COLORSCHEME`, `NVIM_BACKGROUND`,
  `STARSHIP_PALETTE`.

```sh
theme-apply nord        # применить тему
theme-apply             # применить текущую
theme-apply --menu      # выбрать из списка (то же, что Mod+Shift+T)
```

`theme-apply` проверяет сгенерированный фрагмент через `sway -C` до
записи, блокируется от параллельного запуска (`flock`) и пишет файлы
атомарно. Для Neovim нужны colorscheme-плагины из `pack.lua`
(tokyonight, nord, catppuccin, gruvbox).

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

## Пакеты

- `scripts/.local/bin/pkglist-common.txt` — минимум для работы dotfiles.
- `scripts/.local/bin/pkglist-laptop.txt` — дополнительно для ноутбука.
- `scripts/.local/bin/pkglist-desktop.txt` — полный список домашнего ПК.
- `scripts/.local/bin/arch_setup.sh [common|laptop|desktop]` —
  установка пакетов из соответствующего набора. Без аргумента профиль
  определяется по типу корпуса (ноутбук/ПК). Скрипт не создаёт
  пользователя и не меняет locale/раскладку.

## Резервное копирование

`scripts/.local/bin/backup_dots.sh` создаёт tar.gz в `/mnt/data/Files/backup`,
хранит 3 последних архива и пишет лог. Тяжёлые каталоги REAPER
(`Effects`, `UserPlugins`, `Scripts`, `ColorThemes`, `ReaPack`, `Data`)
исключены: они восстанавливаются через ReaPack/менеджеры плагинов.
