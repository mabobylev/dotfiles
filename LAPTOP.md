# Инструкция агенту: перенос окружения на ноутбук

Прочитай этот файл целиком и выполни шаги по порядку. Не переносай старый
SwayFX/Waybar: на ноутбуке должно быть то же новое окружение, что на ПК —
Umbriel + Noctalia + Luciole.

## Цель и ограничения

- Ноутбук: Lenovo B50-45, AMD A4-6210, Radeon R3, экран `eDP-1`
  1366x768, батарея, тачпад.
- Никаких PortProton, Steam, Wine-игр и игровых правил окон. Пакеты и
  плагины, нужные только для игр, не ставить.
- Старый стек (`swayfx`, `waybar`, `swaync`, `fuzzel`, `swaylock`,
  `swayidle`, `swaybg`, `cliphist`, `pcmanfm`, `polkit-gnome`) не
  устанавливать. Темизацию делает только Noctalia, `theme-apply` больше нет.
- Слабый APU: размытие и тени выключены (это уже описано в
  `host-laptop/.config/umbriel/host.d/20-performance.toml`).
- Не менять CapsLock-переключение раскладки и не добавлять второй способ.
- Не включать `new_toward_cursor` и не менять `dwindle` без просьбы.

## 0. Проверить контекст

```sh
whoami
cat /etc/os-release | head -3
ls /sys/class/power_supply
command -v paru || command -v yay || echo "нужен AUR-помощник"
```

Ожидается Arch Linux, пользователь с sudo, батарея `BAT*`, интернет.
Если AUR-помощника нет — установить `paru` по инструкции Arch Wiki, не
изобретать свой.

## 1. Пакеты

Установить из official-репозиториев:

```sh
sudo pacman -S --needed --noconfirm \
  base-devel git stow \
  noctalia adw-gtk-theme wtype upower brightnessctl \
  fzf jq ncdu smartmontools udiskie udisks2 slurp \
  pacman-contrib zenity imagemagick \
  tmux bat lsd starship \
  gvfs glycin ffmpeg poppler 7zip xdg-terminal-exec just
```

Из AUR:

```sh
paru -S --needed --noconfirm \
  umbriel-git xdg-desktop-portal-umbriel-git luciole-git
```

Не устанавливать: `gpu-screen-recorder-git` (запись экрана на этом APU не
нужна), `codexbar-cli` (если на ноутбуке нет `~/.codex/auth.json`),
`win2xcur`/`python-wand` (только если реально нужен плагин курсоров).

Если `~/.codex/auth.json` уже есть и пользователь хочет Codex-метр —
дополнительно:

```sh
paru -S --needed --noconfirm codexbar-cli
```

Проверить базу: `pipewire`, `wireplumber`, `networkmanager`, `bluez`
должны быть установлены и включены (это стандартный Arch, не ломать).

## 2. Репозитории

Основной репозиторий (на ПК уже есть remote):

```sh
git clone git@github.com:mabobylev/dotfiles.git ~/.dotfiles
```

Если SSH-ключ на ноутбуке ещё не настроен — клонировать по HTTPS
(`https://github.com/mabobylev/dotfiles.git`) после `gh auth login`.

Не копировать чужие SSH-ключи и токены.

## 3. Stow

Применить новый репозиторий:

```sh
cd ~/.dotfiles
./apply.sh laptop
```

`apply.sh` сам снимает предыдущий host-пакет и, если бинарник уже собран,
включает `xembsni.service`. Для tray-иконок Lesta/Wine бинарник собирается
отдельно по инструкции из `README.md` (раздел про `xembsni`).

Если ноутбук уже настроен раньше, GUI-состояние может перекрывать новые
значения из `config.toml`. Проверить и убрать только лишние блоки:

```sh
grep -n '^\[bar.main\]\|^\[theme\]\|^\[plugins\]\|^\[wallpaper.default\]' \
  ~/.local/state/noctalia/settings.toml
```

Не удалять `[lockscreen_widgets]`, `[wallpaper.last]` и
`[wallpaper.monitors.*]`. После правки — `noctalia msg config-reload`.

Если на ноутбуке остались битые ссылки на старый `~/.dotfiles-legacy`
(например, в `~/.config/REAPER`), их нужно убрать:

```sh
find ~/.config -xtype l -print
```

Конфиг REAPER в репозиторий не входит: он хранится локально в
`~/.config/REAPER` и бэкапится restic. Конфиг opencode тоже локальный.

Проверить, что ссылки не свёрнуты в каталоги:

```sh
for d in ~/.config/fish ~/.config/nvim ~/.config/tmux ~/.config/foot; do
  [ -L "$d" ] && echo "СВЁРНУТО: $d"
done
```

Если что-то вывелось — перестowить этот пакет с `--no-folding`.

## 4. Первый запуск и экран

Дисплейный менеджер не используется. Выйти на tty1 и войти пользователем;
`~/.bash_profile` сам запустит `start-umbriel` после проверки конфига.

После входа узнать реальные режимы:

```sh
umbriel outputs
```

Записать в `~/.dotfiles/host-laptop/.config/umbriel/host.d/10-output.toml`
точный режим (обычно 1366x768@60), например:

```toml
# host-laptop: встроенный экран

[output.eDP-1]
mode = "1366x768@60"
position = [0, 0]
scale = 1.0
```

Для внешнего монитора добавить второй `[output.<connector>]`. VRR на
встроенной панели не включать (`vrr` не указывать).

Применить без перезапуска:

```sh
umbriel msg config-reload
umbriel outputs | sed -n '1,20p'
```

Убедиться, что текущая частота соответствует выбранному режиму.

Тачпад и производительность уже лежат в
`host-laptop/.config/umbriel/host.d/{20-performance,30-input}.toml`:
размытие/тени выключены, tap-to-click и disable-while-typing включены.
Если тачпад ведёт себя иначе — править только `30-input.toml`, не общий
конфиг.

## 5. Noctalia: плагины и шаблоны

`config.toml` уже содержит бар, виджеты, обои, погоду, ночной свет,
шаблоны и общий список плагинов. После первичной установки плагинов
проверить/включить нужное можно явно:

```sh
for p in \
  noctalia/umbriel-companion noctalia/notes noctalia/timer \
  noctalia/wallhaven noctalia/translator \
  nightwatch75/file-search dunarand/bookmarks weinguyen/shell-command \
  yuuto/arch-updater weinguyen/procmon gustav0ar/drive-health \
  aristides/udiskie thaer99ob/default-apps \
  vn1k/cursor vn1k/icons liamwh/emoji-picker
do
  noctalia msg plugins enable "$p"
done
```

Не включать:

- `weinguyen/opencode-companion` — несовместим с OpenCode v2;
- `noctalia/screen_recorder` — не ставить `gpu-screen-recorder` на этот APU;
- `salemsayed/codexbar-meter` — только если установлен `codexbar-cli` и
  есть `~/.codex/auth.json`.

Бар на ноутбуке уже подготовлен отдельным файлом
`host-laptop/.config/noctalia/zz-host.toml`: он подменяет `start`, `center`
и `end` под 1366 px и не содержит `codex_meter`. На ПК, наоборот,
`host-pc/.config/noctalia/zz-host.toml` определяет виджет Codex-метра.
Поэтому в общий `config.toml` эти host-различия не попадают. Если на
ноутбуке всё-таки нужен Codex-метр — установить `codexbar-cli`, включить
плагин и добавить `[widget.codex_meter]` плюс `"codex_meter"` в `end`
в `host-laptop/.config/noctalia/zz-host.toml`.

На Noctalia 5.6.0 `umbriel-companion` и `screen_recorder` не закреплены.
Если появится `held-back`, сначала проверить совместимость plugin API, а не
считать это нормальным для текущей версии.

Применить шаблоны и проверить:

```sh
noctalia msg templates-apply
noctalia config validate
noctalia msg plugins list | grep ' enabled$'
xdg-mime default dev.noctalia.luciole.desktop inode/directory
```

Шаблоны должны создать:
`~/.config/foot/themes/noctalia`, `~/.config/bat/themes/noctalia.tmTheme`,
`~/.config/lsd/colors.yaml`, `~/.config/tmux/themes/noctalia.conf`,
`~/.config/fzf/themes/noctalia.*`, `~/.config/nvim/lua/matugen.lua`,
`~/.config/opencode/themes/matugen.json`, GTK/Qt-палитры и
`~/.local/state/theme/starship.toml` (симлинк на
`~/.config/starship.toml` создавать не нужно).

GTK: если `~/.config/gtk-4.0/gtk.css` — симлинк на старую тему, заменить
его обычным файлом с одной строкой:

```css
@import url("noctalia.css");
```

То же для `gtk-dark.css`. `gtk-theme` должен быть `adw-gtk3-dark`
(шаблон gtk3/gtk4 выставляет его сам).

## 6. Питание и яркость

Установить хелпер яркости при работе от батареи:

```sh
sudo install -Dm755 ~/.dotfiles/host-laptop/system/bin/power-brightness \
  /usr/local/bin/power-brightness
sudo install -Dm644 ~/.dotfiles/host-laptop/system/udev/99-power-brightness.rules \
  /etc/udev/rules.d/99-power-brightness.rules
sudo udevadm control --reload-rules
sudo udevadm trigger --subsystem-match=power_supply
```

Проверить: `upower -d` видит батарею, `brightnessctl info` работает,
`XF86MonBrightnessUp/Down` меняют яркость (бинды уже в конфиге Umbriel).

Файрвол с ПК (`/etc/nftables.conf`) на ноутбук не копировать автоматически:
если нужен — взять `host-pc/system/etc/nftables.conf` и адаптировать
интерфейсы.

## 7. Проверки после установки

```sh
umbriel config validate
noctalia config validate
foot -C
tmux -L test -f ~/.config/tmux/tmux.conf new-session -d 'sleep 1' && \
  tmux -L test kill-server
nvim --headless -c 'lua print(pcall(require,"matugen"))' -c 'qa!'
luciole --version
xdg-mime query default inode/directory
```

Ожидается `dev.noctalia.luciole.desktop`.

Проверить руками:

- бар не переполнен на 1366 px: `zz-host.toml` уже убирает `taskbar`,
  `file_search`, `arch_updater`, `udiskie` и Codex-метр; если после
  включения плагинов всё ещё тесно — добавить per-monitor override
  `[bar.main.monitor.edp1]` с `match = "eDP-1"` и укороченными
  `start`/`center`/`end`;
- PortProton/игры не проверять — их нет;
- CapsLock переключает US/RU, индикатор в баре кликабелен;
- глобальное меню показывает меню Firefox;
- скриншоты (`Print`, `Shift+Print`), блокировка (`Mod+Shift+L`),
  idle-lock через 10 минут;
- polkit: `pkexec true` не должен ругаться на отсутствие агента;
- foot полупрозрачный (alpha 0.8), палитра совпадает с темой;
- starship и nvim используют цвета Noctalia;
- звук, Wi-Fi, Bluetooth, батарея и яркость.

Если окно открылось тайлом, а должно плавать — посмотреть его `app_id`:

```sh
umbriel windows --json | jq -r '.[] | [.app_id,.title,(.xwayland|tostring)] | @tsv'
```

и добавить правило в `~/.dotfiles/umbriel/.config/umbriel/config.toml`.
У Umbriel нет селектора «все XWayland», поэтому правила перечисляют app_id
явно. Правила PortProton/Steam на ноутбуке можно не трогать — они просто
не совпадут.

## 8. Зафиксировать результат

На ноутбуке:

```sh
cd ~/.dotfiles
git add host-laptop host-pc umbriel noctalia
git commit -m "Configure laptop outputs and input"
git push
```

На ПК после этого:

```sh
cd ~/.dotfiles && git pull --ff-only
```

## Частые ошибки

- Noctalia пишет GUI-настройки в
  `~/.local/state/noctalia/settings.toml`; они приоритетнее
  `config.toml`. Менять их руками только осознанно.
- Не возвращать `STARSHIP_CONFIG` на
  `~/.local/state/theme/starship.toml`: палитру ведёт Noctalia в
  `~/.config/starship.toml`.
- Не запускать `theme-apply`: его больше нет.
- Не добавлять второй polkit-агент: у Noctalia свой
  (`polkit_agent = true`).
- Не ставить `gpu-screen-recorder`, игры и PortProton.
- При слабом APU не включать обратно blur/shadows в
  `20-performance.toml`.
- После `git pull` на любой машине: `./apply.sh <pc|laptop>`, затем
  `umbriel msg config-reload` и `noctalia msg config-reload`.
