export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

##### PATH ######
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi
export PATH="$HOME/.cargo/bin:$PATH"


# if we want to outsource the aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# load bash profile
if [ -f ~/.bash_profile ]; then
    . ~/.bash_profile
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

shopt -s checkwinsize

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi