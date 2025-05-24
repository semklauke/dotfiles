# ENV + PATH VARIABLES
# --------------------

## ZSH
export ZSH_SCRIPTS="$HOME/.config/zsh"

## ENV 
export GRB_LICENSE_FILE="/Users/semklauke/Dropbox/UNI/14-Semester/Practical Optimization with Modeling Languages/stuff/${HOST}_gurobi.lic"
export PLAYDATE_SDK_PATH="/Users/semklauke/Developer/PlaydateSDK"
export ASDF_CONFIG_FILE="$HOME/.config/asdfrc"
export ASDF_NPM_DEFAULT_PACKAGES_FILE="$HOME/.config/default-npm-packages"
export ASDF_PYTHON_DEFAULT_PACKAGES_FILE="$HOME/.config/default-python-packages"

## Homebrew
if command -v brew 1>/dev/null 2>&1; then
    eval "$(brew shellenv)"
else
    if [[ $(uname -m) == 'arm64' ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi


## OpenSSL
export PATH="$PATH:$HOMEBREW_PREFIX/opt/openssl@3/bin"
export LDFLAGS="$LDFLAGS -L$HOMEBREW_PREFIX/opt/openssl@3/lib"
export CPPFLAGS="$CPPFLAGS -I$HOMEBREW_PREFIX/opt/openssl@3/include"
# lua OpenSSL
export OPENSSL_DIR="$HOMEBREW_PREFIX/opt/openssl@3/"

## Rust
. "$HOME/.cargo/env"

## MySql
export PATH=${PATH}:/usr/local/mysql/bin

## GO
export GOPATH="$HOME/Go"
export GOROOT="$HOMEBREW_PREFIX/opt/go/libexec"
export PATH="$PATH:$GOPATH/bin"
export PATH="$PATH:$GOROOT/bin"

## Java

# Standalone: 
#export PATH="$HOMEBREW_PREFIX/opt/openjdk/bin:$PATH"
# jenv: 
export PATH="$HOME/.jenv/bin:$PATH"

## Python

# openblas
export PKG_CONFIG_PATH="${HOMEBREW_PREFIX}/opt/openblas/lib/pkgconfig"
# brew + pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
#export PATH="${HOMEBREW_PREFIX}/lib/python3.11/site-packages:${PATH}"
#export PATH="${HOMEBREW_PREFIX}/lib/python3.12/site-packages:${PATH}"
#export PATH="~/.pyenv/versions/3.11.3/lib/python3.11/site-packages:$PATH"


## PATH Important
export PATH=/usr/local/bin/:${PATH}

# C
export PATH="$HOMEBREW_PREFIX/opt/make/libexec/gnubin:$PATH"

## JS
# deno
export PATH="/Users/semklauke/.deno/bin:$PATH"

## Haskell
export PATH="$PATH:~/.ghcup/bin"

## Path Unimportant
export PATH="$PATH:/Users/semklauke/Library/Application Support/JetBrains/Toolbox/scripts"

# Compile / LD / DyLD stuff
export DYLD_LIBRARY_PATH="$HOMEBREW_PREFIX/lib"
export LIBRARY_PATH="$HOMEBREW_PREFIX/lib"
export C_INCLUDE_PATH="$HOMEBREW_PREFIX/include"
export CPLUS_INCLUDE_PATH="$HOMEBREW_PREFIX/include"
export CPPFLAGS="$CPPFLAGS -I$HOMEBREW_PREFIX/opt/curl/include"

# scip + zimpl
#export PATH="$PATH:/usr/local/scIPOptSuite-9.0.0/build/bin"
#export DYLD_LIBRARY_PATH="${DYLD_LIBRARY_PATH}:/usr/local/scIPOptSuite-9.0.0/build/lib"
#export LIBRARY_PATH="${LIBRARY_PATH}:/usr/local/scIPOptSuite-9.0.0/build/lib"
#export SCIPOPTDIR="$HOMEBREW_PREFIX/Cellar/scip/9.0.0"
#export C_INCLUDE_PATH="${C_INCLUDE_PATH}:/usr/local/scIPOptSuite-9.0.0/build/include"

## Compiler/lib shit
export LDFLAGS="$LDFLAGS -L$HOMEBREW_PREFIX/opt/openblas/lib"
export CPPFLAGS="$CPPFLAGS -I$HOMEBREW_PREFIX/opt/openblas/include"
#export LDFLAGS="$LDFLAGS -L$HOMEBREW_PREFIX/opt/curl/lib"
#export CPPFLAGS="$CPPFLAGS -I$HOMEBREW_PREFIX/opt/curl/include"