# ENV + PATH VARIABLES

# PATH

export PATH=${PATH}:/usr/local/bin/

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
export GOPATH=$HOME/Go
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

# java
export PATH="/usr/local/opt/openjdk/bin:$PATH"
export PATH="$HOME/.jenv/bin:$PATH"

# python
#export PKG_CONFIG_PATH="/usr/local/opt/openblas/lib/pkgconfig"
export PATH="/usr/local/lib/python3.11/site-packages:${PATH}"
export PATH="~/.pyenv/versions/3.11.3/lib/python3.11/site-packages:$PATH"
export PATH="/usr/local/Cellar/pypy3.10/7.3.12/libexec/bin:$PATH"


# ENV 
export GRB_LICENSE_FILE="/User/semklauke/Dropbox/UNI/6-Semester/Operations Research/Gurobi/gurobi.lic"
export PLAYDATE_SDK_PATH="/User/semklauke/Developer/PlaydateSDK"