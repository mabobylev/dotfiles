# vim: ft=sh
# ~/.bash_profile
#

# Session variables must be set before ~/.bashrc so conditional
# configuration (Qt toolkit, Java, prompt, etc.) sees the right session.
if [[ -z "$WAYLAND_DISPLAY" && "${XDG_VTNR:-}" -eq 1 ]]; then
    export XDG_SESSION_TYPE=wayland \
           XDG_SESSION_DESKTOP=umbriel \
           XDG_CURRENT_DESKTOP=umbriel
fi

[[ -f "$HOME/.bashrc" ]] && . "$HOME/.bashrc"

# Start Umbriel on tty1. Validate the config first and fall back to a login
# shell instead of letting getty's Restart=always loop forever.
if [[ -z "$WAYLAND_DISPLAY" && "${XDG_VTNR:-}" -eq 1 && -z "${UMBRIEL_SKIP_AUTOSTART:-}" ]]; then
    if umbriel config validate >/dev/null 2>&1; then
        exec start-umbriel
    fi
    echo "Umbriel config validation failed; dropping to shell" >&2
    exec env UMBRIEL_SKIP_AUTOSTART=1 bash -l
fi
