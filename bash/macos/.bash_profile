# executet only for login shells

#PS1 only in bash
export PS1='${debian_chroot:+($debian_chroot)}\[\033[00m\]\u\[\033[00m\]@\[\033[00m\]\h\[\033[00m\]: \[\033[00;34m\]\w\[\033[00;31m\]
$\[\033[00m\] '


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