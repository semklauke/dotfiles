# Fast, full-featured Zsh setup for macOS (no Oh My Zsh).

ZSH_PROMPT_STYLE=rich

[[ -d "$HOMEBREW_PREFIX/share/zsh/site-functions" ]] \
    && fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)

source "$ZSH_SCRIPTS/options.zsh"
source "$ZSH_SCRIPTS/completions.zsh"
source "$ZSH_SCRIPTS/plugins.zsh"
source "$ZSH_SCRIPTS/keybindings.zsh"
source "$ZSH_SCRIPTS/prompt.zsh"
source "$ZSH_SCRIPTS/colorize.zsh"
source "$ZSH_SCRIPTS/aliases.zsh"
source "$ZSH_SCRIPTS/sudo.zsh"
source "$ZSH_SCRIPTS/macos.zsh"
source "$ZSH_SCRIPTS/fast_directory_switch_uni.zsh"

export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR='subl -w'
export PROMPT_DIRTRIM=4

# Simple file navigation
alias l='ls -AlGh'
alias ..='cd ..; l'
alias size='sudo du -sh'
alias edit='subl'
alias ff='find . -type f -name'
alias fdd='find . -type d -name'
projects() { cd "$HOME/Documents/Projects/$1"; }
alias sciebo='cd ~/sciebo'

# Network status
alias ping8='ping 8.8.8.8'
alias openPorts='sudo lsof -nP -i4TCP | grep LISTEN'
alias openUDPPorts='sudo lsof -nP -i4UDP | grep LISTEN'
alias networkstatus="$HOME/tools/network_status.sh"
alias nstat='networkstatus'
alias netstatus='networkstatus'

openw() { open "http://$*"; }

# Git
openghub() { open "$(git remote get-url "${1:-origin}")"; }
cloneghub() { git clone "git@github.com:${1}.git" "${@:2}"; }
ghubopen() { openghub "$@"; }
ghubclone() { cloneghub "$@"; }
github() {
    if (( $# > 1 )); then
        git clone "git@github.com:semklauke/${1}.git" "$2"
    else
        git clone "git@github.com:semklauke/${1}.git"
    fi
}

# Tooling
tool() { "$HOME/tools/$1.sh" "${@:2}"; }
alias tools='ls -l ~/tools | awk '\''{ if (NR>1) print substr($9, 1, length($9)-3) }'\'''
spotify-cli() { spicetify "$@"; }

# Rust completion is autoloaded via fpath; retain the old command name.
load-rustup() { autoload -Uz _rustup; }

alias zshrc="$EDITOR ~/.zshrc"
alias zshenv="$EDITOR ~/.zshenv"
alias x86='arch -x86_64 /bin/zsh'

dl() {
    local target=${1:-./}
    local -i count=${2:-1}
    local newest
    repeat $count; do
        newest=$(ls -Art "$HOME/Downloads" | grep -v '^\.DS_Store$' | tail -n 1) || return
        [[ -n $newest ]] && mv "$HOME/Downloads/$newest" "$target"
    done
}
alias dll='dl ./'

activate_virtualenv() {
    local virtualenv_directory=${1:-venv}
    local path_to_virtualenv=$PWD

    while [[ $path_to_virtualenv != / ]]; do
        if [[ -r "$path_to_virtualenv/$virtualenv_directory/bin/activate" ]]; then
            print 'Starting virtual environment:'
            print "$path_to_virtualenv/$virtualenv_directory"
            source "$path_to_virtualenv/$virtualenv_directory/bin/activate"
            return 0
        fi
        path_to_virtualenv=${path_to_virtualenv:h}
    done
    return 1
}
alias activate_venv=activate_virtualenv

# Slow environment managers initialize after the first prompt. Their commands
# and shims are already on PATH from .zshenv.
if (( $+commands[pyenv] )); then
    _load_pyenv() {
        eval "$(pyenv init - zsh)"
        eval "$(pyenv virtualenv-init -)"
    }
    zsh-defer _load_pyenv
fi

if (( $+commands[jenv] )); then
    _load_jenv() {
        eval "$(jenv init -)"
        jenv enable-plugin export
    }
    zsh-defer _load_jenv
fi

if (( $+commands[asdf] )); then
    _load_asdf() {
        local asdf_init="$HOMEBREW_PREFIX/opt/asdf/libexec/asdf.sh"
        [[ -r $asdf_init ]] && source "$asdf_init"
        [[ -r "$HOME/.asdf/plugins/java/set-java-home.zsh" ]] \
            && source "$HOME/.asdf/plugins/java/set-java-home.zsh"
    }
    zsh-defer _load_asdf
fi

# Keep the existing cross-platform agent-file behavior, but defer its process
# checks until the prompt is already visible.
SSH_ENV="$HOME/.ssh/agent-environment"
start_agent() {
    print 'Initialising new SSH agent...'
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "$SSH_ENV"
    chmod 600 "$SSH_ENV"
    source "$SSH_ENV" >/dev/null
    /usr/bin/ssh-add
}
_ssh_agent_setup() {
    if [[ -f $SSH_ENV ]]; then
        source "$SSH_ENV" >/dev/null
        ps -p "$SSH_AGENT_PID" -o comm= 2>/dev/null | grep -q 'ssh-agent$' || start_agent
    else
        start_agent
    fi
}
zsh-defer _ssh_agent_setup

if [[ -r "$ZSH_SCRIPTS/local.sh" ]]; then
    source "$ZSH_SCRIPTS/local.sh"
fi
