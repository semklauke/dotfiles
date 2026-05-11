# keybindings

# emacs-style line editing
bindkey -e

# Up/Down search history by the text already typed before the cursor
# (replaces OMZ's history-substring-search plugin with the built-in widget)
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey '^[[A' up-line-or-beginning-search       # Up
bindkey '^[[B' down-line-or-beginning-search     # Down
bindkey '^[OA' up-line-or-beginning-search       # Up (alt code)
bindkey '^[OB' down-line-or-beginning-search     # Down (alt code)

# Home / End / Delete
bindkey '^[[H'  beginning-of-line
bindkey '^[[F'  end-of-line
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line
bindkey '^[[3~' delete-char
