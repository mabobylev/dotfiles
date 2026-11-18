---
name: Sway Theme Switching
description: Переключение и изменение тем Sway-окружения (theme-apply, theme.conf, Waybar, SwayNC, foot, fuzzel, Neovim, starship, GTK, обои)
---

# Переключение тем в этом Sway-окружении

Единый источник правды — `~/.config/theme/themes/<имя>/theme.conf`
(stow-пакет `theme` в `~/.dotfiles/theme`). Скрипт `theme-apply`
раскладывает значения по приложениям; генерируемые файлы в репозиторий
не попадают.

## Команды

```sh
theme-apply                  # применить текущую (current)
theme-apply <имя>            # применить тему
theme-apply --menu           # fuzzel-меню (Mod+Shift+T)
theme-apply --no-reload      # записать файлы без reload Sway
theme-bg-next                # следующее обои темы (Mod+Control+T)
```

Темы: `nord`, `light`, `tokyonight`, `catppuccin`, `gruvbox`.

## Что и куда пишется

| Потребитель | Файл |
|---|---|
| Sway: рамки, курсор | `~/.config/sway/theme.d/50-theme.conf` |
| Waybar | `~/.config/waybar/theme.css` |
| SwayNC | `~/.config/swaync/theme.css` |
| foot | `~/.config/foot/theme.ini` |
| fuzzel | `~/.config/fuzzel/theme.ini` |
| GTK3/4 | `gtk-3.0/settings.ini`, `gtk-4.0/settings.ini`, симлинки GTK4 |
| GTK2 | `~/.gtkrc-2.0` |
| Neovim | `~/.local/state/theme/nvim.lua` |
| starship | `~/.local/state/theme/starship.toml` (`STARSHIP_CONFIG`) |
| обои | `swaymsg output bg`; выбор в `~/.local/state/theme/<тема>.bg` |

В конфигах приложений стоят только `include`/`@import` на эти файлы.
**Не редактировать сгенерированные файлы** — их перезапишет `theme-apply`.

## Ключи theme.conf

- GTK: `GTK_THEME`, `ICON_THEME`, `CURSOR_THEME`, `CURSOR_SIZE`, `FONT`,
  `COLOR_SCHEME`, `ACCENT`, `PREFER_DARK`
- палитра: `BG`, `FG`, `GR`, `BG2`, `HOVER`, `BLUE`, `WARNING`, `CRITICAL`
- терминал: `FOOT_THEME` (набор из `/usr/share/foot/themes`), `ALPHA`
- обои: `WALLPAPER_PREFIX` (`<имя-темы>-`); файлы
  `~/.local/backgrounds/wallpapers/<тема>-<номер>.<ext>` находятся автоматически
- Neovim/starship: `NVIM_COLORSCHEME`, `NVIM_BACKGROUND`, `STARSHIP_PALETTE`

Чтобы добавить обои, помести файл с очередным номером (`nord-007.jpg`)
в `~/.local/backgrounds/wallpapers/`; менять скрипты или перечислять файл
в конфиге не нужно.

## Добавить тему

1. Скопировать `~/.config/theme/themes/nord/theme.conf` в новую папку.
2. Заполнить ключи; цвета без `#`; `FOOT_THEME` проверить:
   `ls /usr/share/foot/themes`.
3. Для nvim добавить colorscheme-плагин в
   `~/.dotfiles/nvim/.config/nvim/lua/pack.lua`.
4. `theme-apply <имя>`; проверить `sway -C`, `foot -C`,
   `fuzzel --check-config`.

## Проверки и диагностика

```sh
bash -n ~/.local/bin/theme-apply
sway -C && foot -C && fuzzel --check-config
readlink ~/.config/theme/current
cat ~/.config/sway/theme.d/50-theme.conf
cat ~/.local/state/theme/nvim.lua
grep -m1 '^palette' ~/.local/state/theme/starship.toml
pgrep -a swaybg
git -C ~/.dotfiles status --short
```

## Важные нюансы

- `theme-apply` проверяет фрагмент Sway через `sway -C` **до** записи,
  берёт `flock` и пишет файлы атомарно.
- `swaymsg reload` при смене темы сбрасывает раскладку на US — принятое
  поведение.
- Живые окна foot перекрашиваются OSC 4/10/11/12; прозрачность (`ALPHA`)
  применяется только к новым окнам; tmux использует свою палитру.
- GTK: для `nord` — `Nord_BMA`; для остальных — встроенная `Adwaita` +
  `prefer-dark` (libadwaita меняет только light/dark). Сторонние GTK-темы
  не устанавливались.
- `~/.config/nvim` и другие каталоги — stow-ссылки; генерируемые файлы
  держать в `~/.local/state/theme`, не в репозитории.
- Не запускать `kitty +kitten themes` — kitty удалён, терминал только foot.
