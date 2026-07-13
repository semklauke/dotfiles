# shell options + history

# history
HISTFILE="${HOME}/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000
setopt EXTENDED_HISTORY       # save timestamp + duration
setopt INC_APPEND_HISTORY     # append immediately, not on shell exit
setopt SHARE_HISTORY          # share history across sessions
setopt HIST_EXPIRE_DUPS_FIRST # discard duplicates before unique entries
setopt HIST_IGNORE_DUPS       # don't record consecutive duplicates
setopt HIST_IGNORE_SPACE      # ignore commands starting with a space
setopt HIST_VERIFY            # don't run !! expansion immediately
setopt HIST_REDUCE_BLANKS

# general
setopt PROMPT_SUBST           # ${vars} expanded in PROMPT
setopt INTERACTIVE_COMMENTS   # allow # comments in interactive shell
setopt LONG_LIST_JOBS
setopt MULTIOS
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_MINUS

# autoload color names ($fg, $bg, $reset_color)
autoload -U colors && colors

# OMZ-compatible history display: full history with European timestamps.
history() {
    if [[ $1 == -c ]]; then
        print -n 'This will delete your command history. Are you sure? [y/N] '
        local reply
        read -r reply
        [[ $reply == [yY] ]] || return 0
        : >| "$HISTFILE"
        fc -p "$HISTFILE"
        print 'History file deleted.'
    elif (( $# )); then
        builtin fc -lE "$@"
    else
        builtin fc -lE 1
    fi
}

alias _='sudo '
