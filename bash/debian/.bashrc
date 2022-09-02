# Executent by non-login and login shells

export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

##### PATH ######
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

PATH="$HOME/.cargo/bin:$PATH"
export JAVA_HOME=/usr/lib/jvm/jdk-18
PATH="$PATH:$JAVA_HOME/bin"

export PATH

# load aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# HISTORY
HISTCONTROL=ignoreboth
HISTFILESIZE=999999999
HISTSIZE=999999999

shopt -s histappend