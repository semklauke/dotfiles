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

install_file () {
    from=$INSTALL_FROM/$1
    to=$INSTALL_LOCATION/$2
    if [ -f "$to" ]; then
        if ! diff $from $to > $to.diff; then
            printf "REMOVED / CHANGED FROM $2:\n"
            diff -u $from $to | grep '^\+' | sed -E 's/^\+//' | tail -n +2
            printf -- "---- See $to.diff ----\n"
        fi
    fi
    rm $to
    cp $from $to
}

case $INSTALL_SHELL in
    zsh)
        if ! [ -d "$INSTALL_LOCATION/.oh-my-zsh/custom" ]; then
            printf "Install Oh-my-zsh. Or the folder '$INSTALL_LOCATION/.oh-my-zsh/custom' is missing\n"
            exit 2
        fi

        install_file .zshenv .zshenv
        install_file .zshrc .zshrc
        install_file ../oh-my-zsh/rustup .oh-my-zsh/custom/rustup
        install_file ../oh-my-zsh/sem.zsh-theme .oh-my-zsh/custom/themes/sem.zsh-theme
        install_file ../../git/.gitconfig .gitconfig
        install_file ../../git/.gitignore_global .gitignore_global
        install_file ../../vimrc .vimrc
        if [ "$INSTALL_SYSTEM" = "macos" ]; then
            install_file ../oh-my-zsh/fast_directory_switch_uni.zsh .oh-my-zsh/custom/fast_directory_switch_uni.zsh
        fi
        # install plugins
        git clone https://github.com/zsh-users/zsh-autosuggestions $INSTALL_LOCATION/.oh-my-zsh/custom/plugins/zsh-autosuggestions
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $INSTALL_LOCATION/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
        ;;

    bash)
        install_file .bash_profile .bash_profile
        install_file .bashrc .bashrc
        install_file ../../git/.gitconfig .gitconfig
        install_file ../../git/.gitignore_global .gitignore_global
        install_file ../../vimrc .vimrc
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