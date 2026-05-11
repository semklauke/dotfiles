# completion system

# user completions live here (rustup is installed below as _rustup)
fpath=( "$ZSH_SCRIPTS/completions" $fpath )

autoload -Uz compinit

# Cache zcompdump; only run the security check once every 24h.
() {
    local dump="$ZSH_COMPDUMP"
    [[ -d "${dump:h}" ]] || mkdir -p "${dump:h}"
    # glob qualifier: file modified less than 24h ago
    if [[ -n "${dump}"(#qNmh-24) ]]; then
        compinit -C -d "$dump"
    else
        compinit -d "$dump"
    fi
}

# completion styles
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'   # case-insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' verbose true
