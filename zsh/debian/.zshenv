# ENV + PATH VARIABLES

if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

. "$HOME/.cargo/env"
PATH=${PATH}:/usr/local/bin/

# java
export JAVA_HOME=/usr/lib/jvm/jdk-18
PATH="$PATH:$JAVA_HOME/bin"

export PATH

#lang
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export LS_OPTIONS='--color=auto'
