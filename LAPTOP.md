# Ноутбук: что делать после `git pull`

Коротко: **`git pull --ff-only`, затем `host-setup`**. Скрипт сам
определит машину по `~/.config/sway/host.d`, при необходимости можно
указать явно.

```sh
cd ~/.dotfiles
git pull --ff-only
host-setup            # или: host-setup laptop
```

`host-setup` делает идемпотентно:

- `stow --no-folding` всех общих пакетов (включая `theme`, `starship`,
  `opencode` с навыком `sway-theme`);
- `stow --no-folding host-laptop`;
- `theme-apply` — раскладывает текущую тему по приложениям;
- проверяет `sway -C`, `foot -C`, `fuzzel --check-config`.

Если `host-setup` не установлен (старый клон), сначала:

```sh
cd ~/.dotfiles
stow -t "$HOME" --no-folding scripts
```

---

## Разовая миграция старого stow

`theme-apply` пишет сгенерированные файлы в `~/.config`. Если каталог —
**единый симлинк** на репозиторий (свёрнутый stow), файлы попадут в git.
`host-setup` проверяет это и откажется работать. Проверить вручную:

```sh
for d in theme waybar swaync foot fuzzel sway; do
  [ -L "$HOME/.config/$d" ] && echo "folded: $d"
done
```

Если что-то вывелось, для каждого такого пакета:

```sh
stow -D -t "$HOME" <пакет>
stow -t "$HOME" --no-folding <пакет>
```

Если `stow -D` не снимает симлинк (редко), удалите его вручную — он
ведёт в `~/.dotfiles`, данные не теряются:

```sh
rm ~/.config/waybar   # подставьте нужный каталог
stow -t "$HOME" --no-folding waybar
```

После миграции снова запустите `host-setup`.

---

## Что проверить глазами

- тема и обои применились: `theme-apply` в конце выводит имя темы;
- в новом окне foot прозрачность и палитра темы;
- Waybar и SwayNC перекрашены (`pkill -USR2 waybar`, `swaync-client -rs`
  уже вызываются скриптом);
- при первом запуске Neovim `vim.pack` доустановит `nord.nvim`,
  `catppuccin/nvim`, `gruvbox.nvim` (нужен интернет);
- starship берёт палитру из `~/.local/state/theme/starship.toml`;
- `kitty` больше не используется и удалён из пакетов.

---

## Полезные команды

```sh
theme-apply --menu        # выбрать тему (Mod+Shift+T)
theme-bg-next             # следующее обои темы (Mod+Control+T)
theme-apply <имя>         # nord | light | tokyonight | catppuccin | gruvbox
```

Проверка после ручных правок:

```sh
bash -n ~/.local/bin/theme-apply
sway -C && foot -C && fuzzel --check-config
git -C ~/.dotfiles status --short
```

---

## Необязательно: напоминание после pull

Если хочется, чтобы Git сам напоминал, можно поставить безопасный
`post-merge`-хук (он ничего не меняет, только печатает напоминание):

```sh
cat > ~/.dotfiles/.git/hooks/post-merge <<'EOF'
#!/bin/sh
echo "dotfiles обновлены. Не забудьте: host-setup"
EOF
chmod +x ~/.dotfiles/.git/hooks/post-merge
```

Автоматически запускать `host-setup` из хука не рекомендуется: он
перезагружает Sway и меняет тему в момент, когда вы могли этого не
хотеть.

---

## Если stow ругается на конфликт

Не используйте `--adopt`: он может перезаписать файлы репозитория
локальными. Сначала посмотрите, что мешает:

```sh
stow -n -v -t "$HOME" --no-folding <пакет>
```

Обычно это старый свёрнутый симлинк или файл, созданный вручную.
Уберите/переместите его и повторите `host-setup`.
