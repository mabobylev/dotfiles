# dotfiles

Личные конфигурации для Arch Linux. Управление — через GNU Stow:
пакеты лежат в подкаталогах, ссылки создаются в `$HOME`.

## Основное окружение

- **Sway** (swayfx) — основная Wayland-сессия; запускается из
  `~/.bash_profile` на tty1.
- **XFCE** — запасная X11-сессия на ПК; запускается командой
  `startxfce4`.
- **fuzzel** — лаунчер и dmenu-режим в Sway.
- **rofi** — dmenu-режим в X11/XFCE.
- **waybar**, **swaync**, **swaylock**, **swayidle**.
- **foot** — терминал Sway; **kitty** — терминал для X11/резерва.
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
    fish foot fuzzel home kitty mc nvim ranger rofi scripts \
    sway swaync tmux wallp waybar
stow -t "$HOME" --no-folding host-laptop   # или host-pc
```

`--no-folding` обязателен: он позволяет общему пакету и host-пакету
добавлять файлы в один каталог (например, `~/.config/sway`).

Sway подключает `~/.config/sway/host.d/*` последним, поэтому host-файлы
переопределяют общие настройки. Waybar подключает
`~/.config/waybar/host.jsonc` и `host.css`.

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
