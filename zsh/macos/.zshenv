# Environment and PATH variables (sourced for every Zsh invocation).

export ZSH_SCRIPTS="$HOME/.zsh"
export ZSH_PLUGINS="$ZSH_SCRIPTS/plugins"
export ZSH_COMPDUMP="$ZSH_SCRIPTS/.zcompdump-${HOST}"

export GRB_LICENSE_FILE="$HOME/Dropbox/UNI/14-Semester/Practical Optimization with Modeling Languages/stuff/${HOST}_gurobi.lic"
export PLAYDATE_SDK_PATH="$HOME/Developer/PlaydateSDK"
export ASDF_CONFIG_FILE="$HOME/.config/asdfrc"
export ASDF_DATA_DIR="$HOME/.asdf"
export ASDF_NPM_DEFAULT_PACKAGES_FILE="$HOME/.config/default-npm-packages"
export ASDF_PYTHON_DEFAULT_PACKAGES_FILE="$HOME/.config/default-python-packages"

# `brew shellenv` is constant for a given installation. Set its values without
# forking brew in every interactive and non-interactive shell.
if [[ -x /opt/homebrew/bin/brew ]]; then
    export HOMEBREW_PREFIX=/opt/homebrew
    export HOMEBREW_CELLAR=/opt/homebrew/Cellar
    export HOMEBREW_REPOSITORY=/opt/homebrew
elif [[ -x /usr/local/bin/brew ]]; then
    export HOMEBREW_PREFIX=/usr/local
    export HOMEBREW_CELLAR=/usr/local/Cellar
    export HOMEBREW_REPOSITORY=/usr/local/Homebrew
elif [[ $MACHTYPE == arm64-* ]]; then
    export HOMEBREW_PREFIX=/opt/homebrew
    export HOMEBREW_CELLAR=/opt/homebrew/Cellar
    export HOMEBREW_REPOSITORY=/opt/homebrew
else
    export HOMEBREW_PREFIX=/usr/local
    export HOMEBREW_CELLAR=/usr/local/Cellar
    export HOMEBREW_REPOSITORY=/usr/local/Homebrew
fi
if [[ -n $HOMEBREW_PREFIX ]]; then
    path=("$HOMEBREW_PREFIX/bin" "$HOMEBREW_PREFIX/sbin" $path)
    export MANPATH="$HOMEBREW_PREFIX/share/man${MANPATH+:$MANPATH}:"
    export INFOPATH="$HOMEBREW_PREFIX/share/info:${INFOPATH:-}"
fi

export PATH="$PATH:$HOMEBREW_PREFIX/opt/openssl@3/bin"
export LDFLAGS="$LDFLAGS -L$HOMEBREW_PREFIX/opt/openssl@3/lib"
export CPPFLAGS="$CPPFLAGS -I$HOMEBREW_PREFIX/opt/openssl@3/include"
export OPENSSL_DIR="$HOMEBREW_PREFIX/opt/openssl@3/"

[[ -r "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
export PATH="$PATH:/usr/local/mysql/bin"

export GOPATH="$HOME/Go"
export GOROOT="$HOMEBREW_PREFIX/opt/go/libexec"
export PATH="$PATH:$GOPATH/bin:$GOROOT/bin"

export PATH="$HOME/.jenv/bin:$PATH"

export PKG_CONFIG_PATH="$HOMEBREW_PREFIX/opt/openblas/lib/pkgconfig"
export PYENV_ROOT="$HOME/.pyenv"
[[ -d "$PYENV_ROOT/bin" ]] && export PATH="$PYENV_ROOT/bin:$PATH"
[[ -d "$PYENV_ROOT/shims" ]] && export PATH="$PYENV_ROOT/shims:$PATH"
[[ -d "$ASDF_DATA_DIR/shims" ]] && export PATH="$ASDF_DATA_DIR/shims:$PATH"

export PATH="/usr/local/bin:$HOMEBREW_PREFIX/opt/make/libexec/gnubin:$PATH"
export PATH="$HOME/.deno/bin:$PATH"
export PATH="$PATH:$HOME/.ghcup/bin"
export PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"

export PATH="$HOMEBREW_PREFIX/opt/llvm/bin:$PATH"
export LDFLAGS="$LDFLAGS -L$HOMEBREW_PREFIX/opt/llvm/lib -L$HOMEBREW_PREFIX/opt/openblas/lib"
export CPPFLAGS="$CPPFLAGS -I$HOMEBREW_PREFIX/opt/llvm/include -I$HOMEBREW_PREFIX/opt/curl/include -I$HOMEBREW_PREFIX/opt/openblas/include"
export DYLD_LIBRARY_PATH="$HOMEBREW_PREFIX/lib"
export LIBRARY_PATH="$HOMEBREW_PREFIX/lib"
export C_INCLUDE_PATH="$HOMEBREW_PREFIX/include"
export CPLUS_INCLUDE_PATH="$HOMEBREW_PREFIX/include"

export AMPL=/Applications/AMPL
