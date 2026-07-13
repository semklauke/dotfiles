# plain-zsh interactive shell (no oh-my-zsh)
# layout: $ZSH_SCRIPTS holds shared lib files; this .zshrc orchestrates them.

# colored ls (sets LS_COLORS; needed by completion list-colors zstyle)
eval "$(dircolors)"

ZSH_PROMPT_STYLE=rich

# shared setup
source "$ZSH_SCRIPTS/options.zsh"
source "$ZSH_SCRIPTS/completions.zsh"
source "$ZSH_SCRIPTS/plugins.zsh"
source "$ZSH_SCRIPTS/keybindings.zsh"
source "$ZSH_SCRIPTS/prompt.zsh"
source "$ZSH_SCRIPTS/colorize.zsh"
source "$ZSH_SCRIPTS/aliases.zsh"
source "$ZSH_SCRIPTS/sudo.zsh"

# Debian visual marker: bold hostname. Keep the git segment from prompt.zsh
if [[ ${ZSH_PROMPT_STYLE:-simple} == rich ]]; then
    PROMPT='%f%n@%B%M%b%f:%F{004} %6~%f${GIT_PROMPT}
%* %F{001}❯ %f'
else
    PROMPT='%f%n@%B%M%b%f:%F{004} %6~%f${vcs_info_msg_0_}
%* %F{001}❯ %f'
fi

# User configuration
export EDITOR='vim'
export PROMPT_DIRTRIM=4

# Simple file navigation
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias l='ls $LS_OPTIONS -lAGh'
alias ..="cd ..; l;"
alias size="sudo du -sh"
alias edit="$EDITOR"
alias ff="find . -type f -name"
alias fdd="find . -type d -name"

# Network status
alias ping8="ping 8.8.8.8"
alias openPorts="sudo netstat -lnp"
alias networkstatus="tool network_status"
alias nstat="networkstatus"
alias netstatus="networkstatus"

# fast dir switching
alias dns="cd /etc/bind/zone_semklauke.de"
alias dnsserver="dns"
alias webserver="cd /etc/nginx/"
alias teamspeak="cd /home/teamspeak/server"
alias minecraft="cd /home/minecraft/server; su minecraft"
alias mail-postfix="cd /etc/postfix"
alias lkp="cd /home/semklauke/documents/lkp"

# git
function openghub()  { open $(git remote get-url ${1:-origin}) ;}
function cloneghub() { git clone git@github.com:${1}.git ${2} ${3} ; }
function ghubopen()  { open $(git remote get-url ${1:-origin}) ;}
function ghubclone() { git clone git@github.com:${1}.git ${2} ${3} ; }
function github()    { git clone git@github.com:semklauke/${1}.git ${2} ; }

# tooling
function tool() { ~/tools/$@.sh; }
alias tools='ls -l  ~/tools | awk '\''{ if (NR>1) print substr($9, 1, length($9)-3) }'\'''

# rust: completion is autoloaded from $ZSH_SCRIPTS/completions/_rustup;
# keep this for backward compat with prior workflow.
function load-rustup() { source "$ZSH_SCRIPTS/completions/_rustup"; }

# usefull
alias zshrc="$EDITOR ~/.zshrc"
alias zshenv="$EDITOR ~/.zshenv"

# virtual env
function activate_virtualenv() {
    local VIRTUALENV_DIRECTORY=${1:-'venv'}
    local PATH_TO_VIRTUALENV=$(pwd)

    while [ "$PATH_TO_VIRTUALENV" != '/' ]
    do
        if [ -r "$PATH_TO_VIRTUALENV/$VIRTUALENV_DIRECTORY/bin/activate" ]
        then
            echo "Starting virtual environment:"
            echo "$PATH_TO_VIRTUALENV/$VIRTUALENV_DIRECTORY"
            source "$PATH_TO_VIRTUALENV/$VIRTUALENV_DIRECTORY/bin/activate"
            return 0
        fi
        PATH_TO_VIRTUALENV=$(dirname "$PATH_TO_VIRTUALENV")
    done

    return 1
}
alias activate_venv=activate_virtualenv

# pyenv: deferred — `pyenv init` forks python and is the single slowest
# thing in shell startup (~100ms). PYENV_ROOT/bin is already in PATH from
# .zshenv so the `pyenv` command itself works immediately; only shims for
# python/pip arrive after the first prompt.
if command -v pyenv 1>/dev/null 2>&1; then
    _load_pyenv() {
        eval "$(pyenv init - zsh)"
        eval "$(pyenv virtualenv-init -)"
    }
    zsh-defer _load_pyenv
fi

# jenv: deferred for the same reason
if command -v jenv 1>/dev/null 2>&1; then
    _load_jenv() {
        eval "$(jenv init -)";
        jenv enable-plugin export;
    }
    zsh-defer _load_jenv
fi

# nvm
if [ -s "$NVM_DIR/nvm.sh" ]; then
    _load_nvm() {
        \. "$NVM_DIR/nvm.sh"
        unfunction _load_nvm
    }
    zsh-defer _load_nvm
fi

### ssh-agent (deferred) ###
SSH_ENV="$HOME/.ssh/agent-environment"
function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add
}
_ssh_agent_setup() {
    if [ -f "${SSH_ENV}" ]; then
        . "${SSH_ENV}" > /dev/null
        ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || start_agent
    else
        start_agent
    fi
}
zsh-defer _ssh_agent_setup


## IMPORTANT PATH
export PATH="/usr/lib/llvm-16/bin:$PATH"


## source local file
if [ -f "$ZSH_SCRIPTS/local.sh" ]; then
    source "$ZSH_SCRIPTS/local.sh"
fi
