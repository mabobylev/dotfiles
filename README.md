# dotfiles

Личные конфигурации для Arch Linux. Управление — через GNU Stow:
пакеты лежат в подкаталогах, ссылки создаются в `$HOME`.

## Основное окружение

- **Sway** — основной Wayland-сессия; запускается из `~/.bash_profile` на tty1.
- **XFCE** — запасная X11-сессия; запускается командой `startxfce4`.
- **fuzzel** — лаунчер и dmenu-режим в Sway.
- **rofi** — dmenu-режим в X11/XFCE.
- **waybar**, **dunst**, **swaylock**, **swayidle**.
- **foot** — терминал Sway; **kitty** — терминал для X11/резерва.
- **fish** — интерактивный shell; **bash** — login shell и автозапуск Sway.

## Пакеты

- `scripts/.local/bin/pkglist.txt` — список явно установленных пакетов.
- `scripts/.local/bin/arch_setup.sh` — установка пакетов из списка.
  Скрипт не создаёт пользователя и не меняет locale/раскладку.

## Установка

```sh
cd ~/.dotfiles
stow -t "$HOME" <пакет>
```

Пакеты: `dunst fish fuzzel home kitty mc nvim ranger reaper rofi scripts
sway tmux wallp waybar`.

## Резервное копирование

`scripts/.local/bin/backup_dots.sh` создаёт tar.gz в `/mnt/data/Files/backup`,
хранит 3 последних архива и пишет лог. Тяжёлые каталоги REAPER
(`Effects`, `UserPlugins`, `Scripts`, `ColorThemes`, `ReaPack`, `Data`)
исключены: они восстанавливаются через ReaPack/менеджеры плагинов.
