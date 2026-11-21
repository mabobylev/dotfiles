_cht_complete()
{
    local cur cache opts
    _get_comp_words_by_ref -n : cur

    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    cache="${XDG_CACHE_HOME:-$HOME/.cache}/cheat.sh.list"

    # Refresh the topic list at most once a week, and never block Tab for
    # more than a few seconds.
    if [[ ! -s "$cache" ]] || [[ -n "$(find "$cache" -mtime +7 2>/dev/null)" ]]; then
        mkdir -p "$(dirname "$cache")"
        curl -fsS --max-time 3 https://cheat.sh/:list -o "$cache" 2>/dev/null || return 0
    fi

    opts="$(<"$cache")"
    if [ "${COMP_CWORD}" = 1 ]; then
        COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
        __ltrim_colon_completions "$cur"
    fi
    return 0
}
complete -F _cht_complete cht.sh
