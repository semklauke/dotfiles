export PROMPT_DIRTRIM=2
# Path exports
export LS_OPTIONS='--color=auto'

#Ruby
alias irb='irb --prompt simple'

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
function tool() { /home/semklauke/tools/$1.sh ${@:2}; }
alias tools='ls -l  /home/semklauke/tools | awk '\''{ if (NR>1) print substr($9, 1, length($9)-3) }'\'''


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

#lang
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8


#promt look
# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[00m\]\u\[\033[00m\]@\[\033[00m\]\h\[\033[00m\]:\[\033[00;34m\]\w\[\033[00;31m\] \$\[\033[00m\] '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac