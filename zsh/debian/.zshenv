# ENV + PATH VARIABLES

if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

## ZSH
export ZSH_SCRIPTS="$HOME/.config/zsh"

# asdf settings
export ASDF_CONFIG_FILE="$HOME/.config/asdfrc"
export ASDF_NPM_DEFAULT_PACKAGES_FILE="$HOME/.config/default-npm-packages"
export ASDF_PYTHON_DEFAULT_PACKAGES_FILE="$HOME/.config/default-python-packages"

# OpenSSL
export PATH="$PATH:/usr/local/opt/openssl@3/bin"
export LDFLAGS="-L/usr/local/opt/openssl@3/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@3/include"

# lua OpenSSL
export OPENSSL_DIR=/usr/local/opt/openssl@3/

. "$HOME/.cargo/env"
export PATH="/usr/local/bin/:${PATH}"

# java
export JAVA_HOME=/usr/lib/jvm/jdk-18
export PATH="$PATH:$JAVA_HOME/bin"

# GO
export PATH="$PATH:/usr/local/go/bin"

#lang
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export LS_OPTIONS='--color=auto'

export PATH="/usr/lib/llvm-16/bin:$PATH"