# Path exports
export PATH=${PATH}:/usr/local/mysql/bin
export PATH=${PATH}:/usr/local/bin/
export PATH="$HOME/.cargo/bin:$PATH"
export PS1='\[\033[00m\]\u\[\033[00m\]@\[\033[00m\]\h\[\033[00m\]:\[\033[00;34m\]\w\[\033[00;31m\] \$\[\033[00m\] '

# Screen Saver
alias screensaver='open /System/Library/Frameworks/ScreenSaver.framework/Resources/ScreenSaverEngine.app'

#Ruby
alias irb='irb --prompt simple'

#Simple file navigation
alias l='ls -AlG'
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
function cloneghub() { git clone https://github.com/${2:-semklauke}/${1} ; }


#University
if [ -f ~/.fast_directory_switch_uni.sh ]; then
    . ~/.fast_directory_switch_uni.sh
fi



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