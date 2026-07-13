# Press Escape twice to toggle sudo (or sudo -e for editor commands).
# Lean standalone equivalent of OMZ's sudo plugin.

_zsh_toggle_sudo() {
    [[ -z $BUFFER ]] && LBUFFER="$(fc -ln -1)"

    local whitespace=""
    if [[ ${LBUFFER[1]} == ' ' ]]; then
        whitespace=' '
        LBUFFER=${LBUFFER[2,-1]}
    fi

    case $LBUFFER in
        'sudo -e '*) LBUFFER=${LBUFFER#sudo -e } ;;
        'sudo '*)    LBUFFER=${LBUFFER#sudo } ;;
        ${EDITOR%% *}' '*) LBUFFER="sudo -e ${LBUFFER#* }" ;;
        *) LBUFFER="sudo $LBUFFER" ;;
    esac

    LBUFFER="${whitespace}${LBUFFER}"
    zle redisplay
}

zle -N sudo-command-line _zsh_toggle_sudo
bindkey -M emacs '\e\e' sudo-command-line
bindkey -M vicmd '\e\e' sudo-command-line
bindkey -M viins '\e\e' sudo-command-line
