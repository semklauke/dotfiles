# ENV + PATH VARIABLES

if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# OpenSSL
export PATH="/usr/local/opt/openssl@3/bin:$PATH"

export LDFLAGS="-L/usr/local/opt/openssl@3/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@3/includ"

. "$HOME/.cargo/env"
PATH=${PATH}:/usr/local/bin/

# java
export JAVA_HOME=/usr/lib/jvm/jdk-18
PATH="$PATH:$JAVA_HOME/bin"

PATH="$HOME/.jenv/bin:$PATH"

export PATH

#lang
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export LS_OPTIONS='--color=auto'
