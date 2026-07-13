# keybindings

# emacs-style line editing
bindkey -e

# Up/Down search history by any text already typed. Prefer the upstream
# plugin used by OMZ; keep a built-in fallback for an offline first install.
if (( $+functions[history-substring-search-up] )); then
    _zsh_history_up=history-substring-search-up
    _zsh_history_down=history-substring-search-down
else
    autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
    zle -N up-line-or-beginning-search
    zle -N down-line-or-beginning-search
    _zsh_history_up=up-line-or-beginning-search
    _zsh_history_down=down-line-or-beginning-search
fi

bindkey '^[[A' "$_zsh_history_up"       # Up
bindkey '^[[B' "$_zsh_history_down"     # Down
bindkey '^[OA' "$_zsh_history_up"       # Up (alt code)
bindkey '^[OB' "$_zsh_history_down"     # Down (alt code)
[[ -n "$terminfo[kcuu1]" ]] && bindkey "$terminfo[kcuu1]" "$_zsh_history_up"
[[ -n "$terminfo[kcud1]" ]] && bindkey "$terminfo[kcud1]" "$_zsh_history_down"
unset _zsh_history_up _zsh_history_down

# Home / End / Delete
bindkey '^[[H'  beginning-of-line
bindkey '^[[F'  end-of-line
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line
bindkey '^[[3~' delete-char
