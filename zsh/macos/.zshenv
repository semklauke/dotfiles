# ENV + PATH VARIABLES
# --------------------

## PATH Important
export PATH=/usr/local/bin/:${PATH}

## ENV 
export GRB_LICENSE_FILE="/User/semklauke/Dropbox/UNI/6-Semester/Operations Research/Gurobi/gurobi.lic"
export PLAYDATE_SDK_PATH="/User/semklauke/Developer/PlaydateSDK"
export ASDF_CONFIG_FILE="$HOME/.config/asdfrc"
export ASDF_NPM_DEFAULT_PACKAGES_FILE="$HOME/.config/default-npm-packages"
export ASDF_PYTHON_DEFAULT_PACKAGES_FILE="$HOME/.config/default-python-packages"

## Homebrew
if command -v brew 1>/dev/null 2>&1; then
    eval "$(brew shellenv)"
else
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

## OpenSSL
export PATH="$PATH:$HOMEBREW_PREFIX/opt/openssl@3/bin"
export LDFLAGS="-L$HOMEBREW_PREFIX/opt/openssl@3/lib"
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
#export PKG_CONFIG_PATH="${HOMEBREW_PREFIX}/opt/openblas/lib/pkgconfig"
# brew + pyenv
#export PATH="${HOMEBREW_PREFIX}/lib/python3.11/site-packages:${PATH}"
#export PATH="${HOMEBREW_PREFIX}/lib/python3.12/site-packages:${PATH}"
#export PATH="~/.pyenv/versions/3.11.3/lib/python3.11/site-packages:$PATH"


## JS
# deno
export PATH="/Users/semklauke/.deno/bin:$PATH"

## Path Unimportant
export PATH="$PATH:/Users/semklauke/Library/Application Support/JetBrains/Toolbox/scripts"