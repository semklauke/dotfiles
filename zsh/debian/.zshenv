# ENV + PATH VARIABLES

if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

. "$HOME/.cargo/env"
export PATH=${PATH}:/usr/local/bin/

#lang
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export LS_OPTIONS='--color=auto'