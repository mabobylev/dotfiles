# vim: ft=sh
# ~/.bash_profile
#

# Session variables must be set before ~/.bashrc so conditional
# configuration (Qt toolkit, Java, prompt, etc.) sees the right session.
if [[ -z "$WAYLAND_DISPLAY" && "${XDG_VTNR:-}" -eq 1 ]]; then
    # На ПК стоит доработанная тема Nord_BMA, на ноутбуке — обычная Nordic.
    # Если Nord_BMA не установлена, GTK-приложения берут тему из
    # ~/.config/gtk-3.0/settings.ini (Nordic).
    if [[ -d /usr/share/themes/Nord_BMA || -d "$HOME/.themes/Nord_BMA" ]]; then
        export GTK_THEME="Nord_BMA:dark"
    fi
    export XDG_SESSION_TYPE=wayland \
           XDG_SESSION_DESKTOP=sway \
           XDG_CURRENT_DESKTOP=sway
fi

[[ -f "$HOME/.bashrc" ]] && . "$HOME/.bashrc"

# Start Sway on tty1. Validate the config first and fall back to a login
# shell instead of letting getty's Restart=always loop forever.
if [[ -z "$WAYLAND_DISPLAY" && "${XDG_VTNR:-}" -eq 1 && -z "${SWAY_SKIP_AUTOSTART:-}" ]]; then
    if sway -C; then
        exec sway
    fi
    echo "Sway config validation failed; dropping to shell" >&2
    exec env SWAY_SKIP_AUTOSTART=1 bash -l
fi
