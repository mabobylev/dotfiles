if status is-interactive
    # Commands to run in interactive sessions can go here
    #eval (zellij setup --generate-auto-start fish | string collect)
end

# Set PATH
if status --is-login
    set -gx PATH $PATH ~/.local/bin
end

# Disable fish greeting
set -U fish_greeting

# Set default apps
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx TERMINAL kitty
set -gx BROWSER firefox

# Определим переменные XDG
set -q XDG_DATA_HOME || set -U XDG_DATA_HOME $HOME/.local/share
set -q XDG_STATE_HOME || set -U XDG_STATE_HOME $HOME/.local/state
set -q XDG_CONFIG_HOME || set -U XDG_CONFIG_HOME $HOME/.config
set -q XDG_CACHE_HOME || set -U XDG_CACHE_HOME $HOME/.cache

# Fzf options
set fzf_preview_dir_cmd lsd --all --color=always
set fzf_preview_file_cmd bat -n --color=always
set fzf_fd_opts --hidden --max-depth 5

starship init fish | source
