# ENV + PATH variables (sourced for every shell, including non-interactive)

if [ -d "$HOME/bin" ]; then
    PATH="$HOME/bin:$PATH"
fi

## ZSH locations
export ZSH_SCRIPTS="$HOME/.zsh"
export ZSH_PLUGINS="$ZSH_SCRIPTS/plugins"
export ZSH_COMPDUMP="$ZSH_SCRIPTS/.zcompdump-${HOST}"

# asdf settings
export ASDF_CONFIG_FILE="$HOME/.config/asdfrc"
export ASDF_NPM_DEFAULT_PACKAGES_FILE="$HOME/.config/default-npm-packages"
export ASDF_PYTHON_DEFAULT_PACKAGES_FILE="$HOME/.config/default-python-packages"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
[[ -d "$PYENV_ROOT/shims" ]] && export PATH="$PYENV_ROOT/shims:$PATH"

# nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"

# OpenSSL
export PATH="$PATH:/usr/local/opt/openssl@3/bin"
export LDFLAGS="-L/usr/local/opt/openssl@3/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@3/include"

# lua OpenSSL
export OPENSSL_DIR=/usr/local/opt/openssl@3/

#. "$HOME/.cargo/env"
export PATH="/usr/local/bin/:${PATH}"
export PATH="$HOME/.local/bin:$PATH"

# java
#export JAVA_HOME=/usr/lib/jvm/jdk-18
#export PATH="$PATH:$JAVA_HOME/bin"
export PATH="$HOME/.jenv/bin:$PATH"
#[[ -d "$HOME/.jenv/shims" ]] && export PATH="$HOME/.jenv/shims:$PATH"

# GO
export PATH="$PATH:/usr/local/go/bin"

# lang
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export LS_OPTIONS='--color=auto'

export PATH="/usr/lib/llvm-16/bin:$PATH"
