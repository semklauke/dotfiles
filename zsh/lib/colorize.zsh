# ccat / cless — colorized cat & less (port of OMZ's colorize plugin)

ZSH_COLORIZE_TOOL=${ZSH_COLORIZE_TOOL:-pygmentize}
ZSH_COLORIZE_STYLE=${ZSH_COLORIZE_STYLE:-default}

colorize_via_pygmentize() {
    if ! command -v pygmentize >/dev/null 2>&1; then
        echo "pygmentize not installed (pip install Pygments)" >&2
        return 1
    fi
    if [ $# -eq 0 ]; then
        pygmentize -O style="$ZSH_COLORIZE_STYLE" -g
    else
        for f in "$@"; do
            pygmentize -O style="$ZSH_COLORIZE_STYLE" -g "$f" || return 1
        done
    fi
}

colorize_via_chroma() {
    if ! command -v chroma >/dev/null 2>&1; then
        echo "chroma not installed" >&2
        return 1
    fi
    if [ $# -eq 0 ]; then
        chroma --style="$ZSH_COLORIZE_STYLE" --formatter=terminal256
    else
        chroma --style="$ZSH_COLORIZE_STYLE" --formatter=terminal256 "$@"
    fi
}

if [[ "$ZSH_COLORIZE_TOOL" == "chroma" ]]; then
    alias ccat='colorize_via_chroma'
    alias cless='colorize_via_chroma | less -R'
else
    alias ccat='colorize_via_pygmentize'
    alias cless='colorize_via_pygmentize | less -R'
fi
