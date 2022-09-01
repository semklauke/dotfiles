# Path exports
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

#includes + libs
export C_INCLUDE_PATH="/usr/local/opt/libomp/include:$C_INCLUDE_PATH"
export C_INCLUDE_PATH="/usr/local/opt/llvm/lib/clang/7.0.1/include:$C_INCLUDE_PATH"
export CPLUS_INCLUDE_PATH="/usr/local/opt/libomp/include:$CPLUS_INCLUDE_PATH"
export CPLUS_INCLUDE_PATH="/usr/local/opt/llvm/lib/clang/7.0.1/include:$CPLUS_INCLUDE_PATH"
export LIBRARY_PATH="/usr/local/opt/libomp/lib:$LIBRARY_PATH"
export DYLD_LIBRARY_PATH="/usr/local/opt/libomp/lib:$DYLD_LIBRARY_PATH"

export OPENMP="clang -fopenmp -O3 "


# Screen Saver
alias screensaver='open /System/Library/Frameworks/ScreenSaver.framework/Resources/ScreenSaverEngine.app'

#Ruby
alias irb='irb --prompt simple'

#Simple file navigation
alias l='ls -AlG'
alias ..="cd ..; l;"
alias size="sudo du -sh"
function projects() {  cd /Users/semklauke/Documents/Projects/$@ ;}
function ghub() { cd /Users/semklauke/Documents/Develompent/GitHub/$@ ;}

#Network status
alias ping8="ping 8.8.8.8"
alias openPorts='sudo lsof -nP -i4TCP | grep LISTEN'
alias openUDPPorts='sudo lsof -nP -i4UDP | grep LISTEN'

alias networkstatus="/Users/semklauke/tools/network_status.sh"
alias nstat="networkstatus"
alias netstatus="networkstatus"

#open website
function openw() { open "http://$@"; }

#git
function openghub() { open $(git remote get-url ${1:-origin}) ;}
function cloneghub() { git clone git@github.com:${1}.git ${2} ${3} ; }
function ghubopen() { open $(git remote get-url ${1:-origin}) ;}
function ghubclone() { git clone git@github.com:${1}.git ${2} ${3} ; }
function github() { git clone git@github.com:semklauke/${1}.git ${2} ; }

#University
if [ -f ~/.bash/fast_directory_switch_uni.sh ]; then
    . ~/.bash/fast_directory_switch_uni.sh
fi

#PS1 only in bash
export PS1='${debian_chroot:+($debian_chroot)}\[\033[00m\]\u\[\033[00m\]@\[\033[00m\]\h\[\033[00m\]: \[\033[00;34m\]\w\[\033[00;31m\]
$\[\033[00m\] '



#barkeeper project
function bk-switch {
    if [ "$PWD" == "/Users/semklauke/Documents/Projects/barkeeper/bk-server" ]; then
		echo "Switch to App"; projects barkeeper; cd bk-app;
	elif [ "$PWD" == "/Users/semklauke/Documents/Projects/barkeeper/bk-app" ]; then
		echo  "Switch to Server"; projects barkeeper; cd bk-server;
	fi;
}

#2048
alias bash2048="/Users/semklauke/Documents/Develompent/GitHub/Bash2048/test.sh"

#tooling
function tool() { ~/tools/$@.sh; }
alias tools='ls -l  ~/tools | awk '\''{ if (NR>1) print substr($9, 1, length($9)-3) }'\'''


alias numi-extensions="cd /Users/semklauke/Library/Application\ Support/com.nikolaeu.numi-setapp/extensions"
function spotify-cli() { spicetify $@; }

### start ssh-agend ###
SSH_ENV="$HOME/.ssh/agent-environment"

function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}

# Source SSH settings, if applicable
if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi