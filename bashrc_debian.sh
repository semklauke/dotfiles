PS1='${debian_chroot:+($debian_chroot)}\[\033[00m\]\u\[\033[00m\]@\[\033[00m\]\h\[\033[00m\]:\[\033[00;34m\]\w\[\033[00;31m\] \$\[\033[00m\] '
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8