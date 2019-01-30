# Path exports
export LS_OPTIONS='--color=auto'

#Ruby
alias irb='irb --prompt simple'

#Simple file navigation
eval "`dircolors`"
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias l='ls $LS_OPTIONS -lA'

alias size="sudo du -sh"


#Network status
alias ping8="ping 8.8.8.8"
alias openPorts="sudo netstat -lnp"

alias networkstatus="tool network_status"
alias nstat="networkstatus"
alias netstatus="networkstatus"


#tooling
function tool() { /home/semklauke/tools/$@.sh;  }
alias tools='ls -l  /home/semklauke/tools | awk '\''{ if (NR>1) print substr($9, 1, length($9)-3) }'\'''


# fast dir switching
alias dns="cd /etc/bind/zone_semklauke.de"
alias dnsserver="dns"
alias webserver="cd /etc/nginx/"
alias teamspeak="cd /home/teamspeak/server"
alias minecraft="cd /home/minecraft/server; su minecraft"