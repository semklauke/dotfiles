# Path exports
export LS_OPTIONS='--color=auto'

#Simple file navigation
eval "`dircolors`"
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias l='ls $LS_OPTIONS -lAGh'
alias ..="cd ..; l;"
alias size="sudo du -sh"


#Network status
alias ping8="ping 8.8.8.8"
alias openPorts="sudo netstat -lnp"

alias networkstatus="tool network_status"
alias nstat="networkstatus"
alias netstatus="networkstatus"


#tooling
function tool() { ~/tools/$1.sh ${@:2}; }
alias tools='ls -l  ~/tools | awk '\''{ if (NR>1) print substr($9, 1, length($9)-3) }'\'''


# fast dir switching
alias dns="cd /etc/bind/zone_semklauke.de"
alias dnsserver="dns"
alias webserver="cd /etc/nginx/"
alias teamspeak="cd /home/teamspeak/server"
alias minecraft="cd /home/minecraft/server; su minecraft"
alias mail-postfix="cd /etc/postfix"

#git
function openghub() { open $(git remote get-url ${1:-origin}) ;}
function cloneghub() { git clone git@github.com:${1}.git ${2} ${3} ; }
function ghubopen() { open $(git remote get-url ${1:-origin}) ;}
function ghubclone() { git clone git@github.com:${1}.git ${2} ${3} ; }
function github() { git clone git@github.com:semklauke/${1}.git ${2} ; }