# Executent by non-login and login shells

export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

##### PATH ######
export PATH=${PATH}:/usr/local/mysql/bin
export PATH=${PATH}:/usr/local/bin/
export PATH=${PATH}:/usr/local/share/dotnet/dotnet
export PATH=${PATH}:/usr/local/Cellar/python/3.7.5/Frameworks/Python.framework/Versions/3.7/bin
export PATH="$HOME/.cargo/bin:$PATH"
export PROMPT_DIRTRIM=2
export GOPATH=$HOME/Go
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin
export PATH="$HOME/.cargo/bin:$PATH"

#includes + libs
export C_INCLUDE_PATH="/usr/local/opt/libomp/include:$C_INCLUDE_PATH"
export C_INCLUDE_PATH="/usr/local/opt/llvm/lib/clang/7.0.1/include:$C_INCLUDE_PATH"
export CPLUS_INCLUDE_PATH="/usr/local/opt/libomp/include:$CPLUS_INCLUDE_PATH"
export CPLUS_INCLUDE_PATH="/usr/local/opt/llvm/lib/clang/7.0.1/include:$CPLUS_INCLUDE_PATH"
export LIBRARY_PATH="/usr/local/opt/libomp/lib:$LIBRARY_PATH"
export DYLD_LIBRARY_PATH="/usr/local/opt/libomp/lib:$DYLD_LIBRARY_PATH"

export OPENMP="clang -fopenmp -O3 "

##### load aliases #####
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
