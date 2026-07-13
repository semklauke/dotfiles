# external plugins (no oh-my-zsh)

# zsh-defer must load synchronously so we can use it below.
if [[ -r "$ZSH_PLUGINS/zsh-defer/zsh-defer.plugin.zsh" ]]; then
    source "$ZSH_PLUGINS/zsh-defer/zsh-defer.plugin.zsh"
else
    # fallback: no defer available, source directly
    zsh-defer() { "$@"; }
fi

# Settings consumed by the plugins below must be set before they load.
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# This plugin provides real substring matching (the built-in Zsh widgets only
# match prefixes). It must be available before keybindings.zsh is sourced.
if [[ -r "$ZSH_PLUGINS/zsh-history-substring-search/zsh-history-substring-search.zsh" ]]; then
    source "$ZSH_PLUGINS/zsh-history-substring-search/zsh-history-substring-search.zsh"
fi

# Heavy plugins: deferred until after first prompt renders.
# zsh-syntax-highlighting must be the last thing to modify ZLE widgets;
# zsh-defer queues both at the end of startup, so order between them is
# preserved if we queue highlighting last.
[[ -r "$ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] \
    && zsh-defer source "$ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh"

[[ -r "$ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] \
    && zsh-defer source "$ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
