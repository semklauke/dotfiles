# ENV + PATH VARIABLES

if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# asdf settings
export ASDF_CONFIG_FILE="$HOME/.config/asdfrc"
export ASDF_NPM_DEFAULT_PACKAGES_FILE="$HOME/.config/default-npm-packages"
export ASDF_PYTHON_DEFAULT_PACKAGES_FILE="$HOME/.config/default-python-packages"

# OpenSSL
export PATH="/usr/local/opt/openssl@3/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/openssl@3/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@3/include"

# lua OpenSSL
export OPENSSL_DIR=/usr/local/opt/openssl@3/

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
