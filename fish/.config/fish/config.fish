if status is-interactive
    # Commands to run in interactive sessions can go here
    #eval (zellij setup --generate-auto-start fish | string collect)
end

# Set PATH
if status --is-login
    fish_add_path --prepend ~/.local/bin
end

# Disable fish greeting
set -U fish_greeting

# Set default apps
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx TERMINAL foot
set -gx BROWSER firefox

# Определим переменные XDG
set -q XDG_DATA_HOME || set -U XDG_DATA_HOME $HOME/.local/share
set -q XDG_STATE_HOME || set -U XDG_STATE_HOME $HOME/.local/state
set -q XDG_CONFIG_HOME || set -U XDG_CONFIG_HOME $HOME/.config
set -q XDG_CACHE_HOME || set -U XDG_CACHE_HOME $HOME/.cache

# direnv: окружение из .envrc при входе в каталог проекта.
if type -q direnv
    direnv hook fish | source
end

# Fzf options
set fzf_preview_dir_cmd lsd --all --color=always
set fzf_preview_file_cmd bat -n --color=always
set fzf_fd_opts --hidden --max-depth 5

# Палитра fzf из Noctalia (генерирует шаблон fzf).
# Не source-им сниппет: он пишет универсальную переменную и накапливает цвета
# при каждом старте. Берём из файла только строки --color=*.
if test -f "$HOME/.config/fzf/themes/noctalia.fish"
    set -l fzf_colors (string match -r -- '^--color=[^"]+' (string split \n < "$HOME/.config/fzf/themes/noctalia.fish"))
    set -gx FZF_DEFAULT_OPTS $FZF_DEFAULT_OPTS $fzf_colors
end

starship init fish | source
