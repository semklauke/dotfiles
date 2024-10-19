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
PATH="$HOME/.jenv/bin:$PATH"

export PATH

# OpenSSL
export PATH="/usr/local/opt/openssl@3/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/openssl@3/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@3/include"

# lua OpenSSL
export OPENSSL_DIR=/usr/local/opt/openssl@3/

## Rust
. "$HOME/.cargo/env"

## MySql
export PATH=${PATH}:/usr/local/mysql/bin

## GO
export GOPATH="$HOME/Go"
#export GOROOT="$HOMEBREW_PREFIX/opt/go/libexec"
#export PATH="$PATH:$GOPATH/bin"
#export PATH="$PATH:$GOROOT/bin"

# start pyenv if installed
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi

# start jenv if installed
if command -v jenv 1>/dev/null 2>&1; then
    eval "$(jenv init -)"
    export PATH="$HOME/.jenv/bin:$PATH"
fi

# asdf
. "$HOME/.asdf/asdf.sh"

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