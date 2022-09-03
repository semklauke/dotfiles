# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$ZSH/custom"
export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="sem"

DISABLE_UNTRACKED_FILES_DIRTY="true"
ZSH_DISABLE_COMPFIX=true

HIST_STAMPS="dd.mm.yyyy"

# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(
    git-prompt 
    colorize 
    aliases 
    history-substring-search 
    macos 
    mix 
    sudo 
    zsh-autosuggestions 
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration

export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR='subl -w'
export PROMPT_DIRTRIM=4

# Simple file navigation
alias l='ls -AlGh'
alias ..="cd ..; l;"
alias size="sudo du -sh"
alias edit="subl"
alias ff="find . -type f -name"
alias fdd="find . -type d -name"
function projects() {  cd /Users/semklauke/Documents/Projects/$@ ;}

# Network status
alias ping8="ping 8.8.8.8"
alias openPorts='sudo lsof -nP -i4TCP | grep LISTEN'
alias openUDPPorts='sudo lsof -nP -i4UDP | grep LISTEN'
alias networkstatus="/Users/semklauke/tools/network_status.sh"
alias nstat="networkstatus"
alias netstatus="networkstatus"

# open website
function openw() { open "http://$@"; }

# git
function openghub() { open $(git remote get-url ${1:-origin}) ;}
function cloneghub() { git clone git@github.com:${1}.git ${2} ${3} ; }
function ghubopen() { open $(git remote get-url ${1:-origin}) ;}
function ghubclone() { git clone git@github.com:${1}.git ${2} ${3} ; }
function github() { git clone git@github.com:semklauke/${1}.git ${2} ; }

# tooling
function tool() { ~/tools/$@.sh; }
alias tools='ls -l  ~/tools | awk '\''{ if (NR>1) print substr($9, 1, length($9)-3) }'\'''

function spotify-cli() { spicetify $@; }

# rust
function load-rustup() { source ~/.oh-my-zsh/custom/rustup }

# usefull
alias zshrc="subl ~/.zshrc"

# start pyenv if installed
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi

# start jenv if installed
if command -v jenv 1>/dev/null 2>&1; then
    eval "$(jenv init -)"
fi

### start ssh-agend ###
SSH_ENV="$HOME/.ssh/agent-environment"

function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}

# Source SSH settings, if applicable
if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi