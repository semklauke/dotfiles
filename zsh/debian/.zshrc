# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$ZSH/custom"
export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="sem"

DISABLE_UNTRACKED_FILES_DIRTY="true"

HIST_STAMPS="dd.mm.yyyy"

# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(
    git-prompt 
    colorize 
    aliases 
    history-substring-search 
    mix 
    sudo 
    zsh-autosuggestions 
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration
export EDITOR='vim'

export LANG=en_US.UTF-8

export PROMPT_DIRTRIM=4

# Simple file navigation
eval "`dircolors`"
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

# git
function openghub() { open $(git remote get-url ${1:-origin}) ;}
function cloneghub() { git clone git@github.com:${1}.git ${2} ${3} ; }
function ghubopen() { open $(git remote get-url ${1:-origin}) ;}
function ghubclone() { git clone git@github.com:${1}.git ${2} ${3} ; }
function github() { git clone git@github.com:semklauke/${1}.git ${2} ; }

# tooling
function tool() { ~/tools/$@.sh; }
alias tools='ls -l  ~/tools | awk '\''{ if (NR>1) print substr($9, 1, length($9)-3) }'\'''

# rust
function load-rustup() { source ~/.oh-my-zsh/custom/rustup }

# usefull
alias zshrc="$EDITOR ~/.zshrc"
alias zshenv="$EDITOR ~/.zshenv"

# virtual env
function activate_virtualenv()
{
    local VIRTUALENV_DIRECTORY=${1:-'venv'}
    local PATH_TO_VIRTUALENV=$(pwd)

    # move up the path tree, but stop at root node
    while [ "$PATH_TO_VIRTUALENV" != '/' ]
    do
        # is virtualenv's "activate" script accessible from current
        # directory?
        if [ -r "$PATH_TO_VIRTUALENV/$VIRTUALENV_DIRECTORY/bin/activate" ]
        then
            echo "Starting virtual environment:"
            echo "$PATH_TO_VIRTUALENV/$VIRTUALENV_DIRECTORY"

            # run "activate" script
            source "$PATH_TO_VIRTUALENV/$VIRTUALENV_DIRECTORY/bin/activate"

            # signal success
            return 0
        fi

        # move up the path to parent directory
        PATH_TO_VIRTUALENV=$(dirname "$PATH_TO_VIRTUALENV")
    done

    # signal failure
    return 1
}
alias activate_venv=activate_virtualenv

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