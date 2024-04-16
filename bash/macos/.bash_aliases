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

#2048
alias bash2048="/Users/semklauke/Documents/Develompent/GitHub/Bash2048/test.sh"

#tooling
function tool() { ~/tools/$@.sh; }
alias tools='ls -l  ~/tools | awk '\''{ if (NR>1) print substr($9, 1, length($9)-3) }'\'''

# virtual env
function activate_virtualenv()
{
    local VIRTUALENV_DIRECTORY=${1:-'venv'}
    local PATH_TO_VIRTUALENV=$(pwd)

    # move up the path tree, but stop at root node
    while [ "$PATH_TO_VIRTUALENV" != '/' ]
    do
        # is virtualenv's "activate" script accessible from current
        # directory?
        if [ -r "$PATH_TO_VIRTUALENV/$VIRTUALENV_DIRECTORY/bin/activate" ]
        then
            echo "Starting virtual environment:"
            echo "$PATH_TO_VIRTUALENV/$VIRTUALENV_DIRECTORY"

            # run "activate" script
            source "$PATH_TO_VIRTUALENV/$VIRTUALENV_DIRECTORY/bin/activate"

            # signal success
            return 0
        fi

        # move up the path to parent directory
        PATH_TO_VIRTUALENV=$(dirname "$PATH_TO_VIRTUALENV")
    done

    # signal failure
    return 1
}
alias activate_venv=activate_virtualenv


alias numi-extensions="cd /Users/semklauke/Library/Application\ Support/com.nikolaeu.numi-setapp/extensions"
function spotify-cli() { spicetify $@; }