# ENV + PATH VARIABLES

# PATH

export PATH=${PATH}:/usr/local/bin/
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

# ENV 
export GRB_LICENSE_FILE="/User/semklauke/Dropbox/UNI/6-Semester/Operations Research/Gurobi/gurobi.lic"