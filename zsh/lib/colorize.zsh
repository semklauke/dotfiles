# ccat / cless — colorized cat & less (port of OMZ's colorize plugin)

if [[ -z $ZSH_COLORIZE_TOOL ]]; then
    if (( $+commands[pygmentize] )); then
        ZSH_COLORIZE_TOOL=pygmentize
    elif (( $+commands[chroma] )); then
        ZSH_COLORIZE_TOOL=chroma
    fi
fi
ZSH_COLORIZE_STYLE=${ZSH_COLORIZE_STYLE:-emacs}

colorize_check_requirements() {
    if [[ $ZSH_COLORIZE_TOOL != pygmentize && $ZSH_COLORIZE_TOOL != chroma ]]; then
        print -u2 "Neither 'pygmentize' nor 'chroma' is installed."
        return 1
    fi
    (( $+commands[$ZSH_COLORIZE_TOOL] )) || {
        print -u2 "Colorizer '$ZSH_COLORIZE_TOOL' is not installed."
        return 1
    }
}

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

colorize_cat() {
    colorize_check_requirements || return
    if [[ $ZSH_COLORIZE_TOOL == chroma ]]; then
        colorize_via_chroma "$@"
    else
        colorize_via_pygmentize "$@"
    fi
}

colorize_less() {
    colorize_check_requirements || return
    if [[ -t 0 ]]; then
        colorize_cat "$@" | LESS="-R ${LESS:-}" command less
    else
        colorize_cat | LESS="-R ${LESS:-}" command less "$@"
    fi
}

alias ccat='colorize_cat'
alias cless='colorize_less'
