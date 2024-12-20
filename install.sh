#!/bin/bash

## USAGE:
## ./install.sh <shell> <system> <?homefolder>
## shell = zsh | bash
## system = macos | debian
## homefolder is default ~

INSTALL_SHELL=$1
INSTALL_SYSTEM=$2
INSTALL_LOCATION=${3:-~}
# check input
USAGE_PROMT="Usage ./install.sh <shell> <system> <?homefolder>\n"\
"- <shell> must be 'zsh' or 'bash'\n"\
"- <system> must be 'macos' or 'debian'\n"\
"- <homefolder> default is ~/\n"
if ! [ "$INSTALL_SYSTEM" = "macos" -o "$INSTALL_SYSTEM" = "debian" ]; then
    printf "$USAGE_PROMT"
    exit 1
fi
if ! [ "$INSTALL_SHELL" = "zsh" -o "$INSTALL_SHELL" = "bash" ]; then
    printf "$USAGE_PROMT"
    exit 1
fi
if [ "$INSTALL_LOCATION" != "~" ]; then
    INSTALL_LOCATION=$(echo $INSTALL_LOCATION | sed 's:/*$::')
fi

INSTALL_FROM=$(dirname "$0")/$INSTALL_SHELL/$INSTALL_SYSTEM
DIFF_FILES=()

install_file () {
    from=$INSTALL_FROM/$1
    to=$INSTALL_LOCATION/$2
    overwrite=${3:-"overwrite"}

    if [ -f "$to" ]; then
        if ! diff $to $from  > $to.diff; then
            if [ $overwrite = "overwrite" ]; then
                DIFF_FILES+=( "$to.diff" )
                rm $to
                cp $from $to
                printf "> $(tput setaf 1)Overwritten$(tput sgr0) $2\n"
                printf "  See $to.diff\n"
            else
                printf "> $(tput setaf 3)Keeping$(tput cuf 4)$(tput sgr0) $2\n"
                printf "  Replace manually with: cp -rf $from $to\n"
                rm "$to.diff"
            fi
        else
            rm "$to.diff"
            printf "> $(tput setaf 2)Installed$(tput cuf 2)$(tput sgr0) $2\n"
            cp $from $to
        fi
    else
        printf "> $(tput setaf 2)Installed$(tput cuf 2)$(tput sgr0) $2\n"
        cp $from $to
    fi
}

# --------------------------------------------------------- #
# --------------------- start install --------------------- #
# --------------------------------------------------------- #

printf -- "$(tput bold)---- Starting install in $INSTALL_LOCATION ----$(tput sgr0)\n"

case $INSTALL_SHELL in
    zsh)
        if ! [ -d "$INSTALL_LOCATION/.oh-my-zsh/custom" ]; then
            printf "Install Oh-my-zsh. Or the folder '$INSTALL_LOCATION/.oh-my-zsh/custom' is missing\n"
            exit 2
        fi
        ZSH_CUSTOM_DIR=.oh-my-zsh/custom

        install_file .zshenv .zshenv
        install_file .zshrc .zshrc
        install_file ../oh-my-zsh/rustup $ZSH_CUSTOM_DIR/rustup
        install_file ../oh-my-zsh/sem.zsh-theme $ZSH_CUSTOM_DIR/themes/sem.zsh-theme
        install_file ../oh-my-zsh/sem_git.zsh-theme $ZSH_CUSTOM_DIR/themes/sem_git.zsh-theme
        if [ "$INSTALL_SYSTEM" = "macos" ]; then
            install_file ../oh-my-zsh/fast_directory_switch_uni.zsh $ZSH_CUSTOM_DIR/fast_directory_switch_uni.zsh
        fi

        # install extern plugins
        if ! [ -d "$INSTALL_LOCATION/$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions" ]; then
            git clone -q https://github.com/zsh-users/zsh-autosuggestions $INSTALL_LOCATION/$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions > /dev/null
        else
            git -C $INSTALL_LOCATION/$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions pull -q --ff-only > /dev/null
        fi
        if ! [ -d "$INSTALL_LOCATION/$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting" ]; then
            git clone -q https://github.com/zsh-users/zsh-syntax-highlighting.git $INSTALL_LOCATION/$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting > /dev/null
        else
            git -C $INSTALL_LOCATION/$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting pull -q --ff-only > /dev/null
        fi
        ;;

    bash)
        install_file .bash_profile .bash_profile
        install_file .bashrc .bashrc
        install_file .bash_aliases .bash_aliases
        if [ "$INSTALL_SYSTEM" = "macos" ]; then
            mkdir -p $INSTALL_LOCATION/.bash
            install_file ../oh-my-zsh/fast_directory_switch_uni.zsh .bash/fast_directory_switch_uni.sh 
        fi
        ;;

    *)
        printf "$USAGE_PROMT"
        exit 1
        ;;
esac

# install for both
install_file ../../git/.gitconfig .gitconfig "keep"
install_file ../../git/.gitignore_global .gitignore_global "overwrite"
install_file ../../configs/vimrc .vimrc "keep"
install_file ../../config/asdfrc .config/asdfrc "overwrite"
install_file ../../config/default-python-packages .config/default-python-packages "overwrite"

printf -- "$(tput bold)---- Done ----$(tput sgr0)\n"

# show command to delete all diff files
if ! [ ${#DIFF_FILES[@]} -eq 0 ]; then
    joined_diff_files=$(printf " %s" "${DIFF_FILES[@]}")
    
    printf -- "If you want to remove all of the .diff files execute\n"
    printf "rm ${joined_diff_files:1}\n"
    if [[ "$INSTALL_SYSTEM" == "macos" ]]; then
        echo "rm ${joined_diff_files:1}" | pbcopy
    fi
fi