#!/bin/bash

## USAGE:
## ./install.sh <shell> <system> [<interactive_mode>] [<homefolder>]
## shell  = zsh  (plain zsh, no oh-my-zsh — debian only for now)
##        | omz  (legacy oh-my-zsh setup, debian|macos)
##        | bash
## system = macos | debian
## interactive_mode (omz/bash only) = basic | full   (default: basic)
## homefolder default is ~

INSTALL_SHELL=$1
INSTALL_SYSTEM=$2
INSTALL_INTERACTIVE=${3:-"basic"}
INSTALL_LOCATION=${4:-~}

# check input
USAGE_PROMT="Usage ./install.sh <shell> <system> [<interactive_mode>] [<homefolder>]\n"\
"- <shell> must be 'zsh', 'omz' or 'bash'\n"\
"- <system> must be 'macos' or 'debian'\n"\
"- <interactive_mode> 'full' or 'basic' (omz/bash only). Default 'basic'\n"\
"- <homefolder> default is ~/\n"
if ! [ "$INSTALL_SYSTEM" = "macos" -o "$INSTALL_SYSTEM" = "debian" ]; then
    printf "$USAGE_PROMT"
    exit 1
fi
if ! [ "$INSTALL_SHELL" = "zsh" -o "$INSTALL_SHELL" = "omz" -o "$INSTALL_SHELL" = "bash" ]; then
    printf "$USAGE_PROMT"
    exit 1
fi
# plain zsh is debian-only for now
if [ "$INSTALL_SHELL" = "zsh" -a "$INSTALL_SYSTEM" != "debian" ]; then
    printf "plain 'zsh' is currently debian-only — use 'omz' for macos.\n"
    printf "See migrate_zsh.md for the macos migration plan.\n"
    exit 1
fi
if [ "$INSTALL_LOCATION" != "~" ]; then
    INSTALL_LOCATION=$(echo $INSTALL_LOCATION | sed 's:/*$::')
fi

INSTALL_FROM=$(dirname "$0")/$INSTALL_SHELL/$INSTALL_SYSTEM
REPO_ROOT=$(cd "$(dirname "$0")" && pwd)
DIFF_FILES=()

# How far back to look when deciding whether a local file is just an
# older revision of the repo file (rather than a real local edit).
HISTORY_DEPTH=3

# Returns 0 if $1's content matches any of the last $HISTORY_DEPTH
# versions of repo path $2 — i.e., $to was installed from a recent
# commit and the user hasn't edited it locally. Used to silently update
# after a `git pull` instead of warning as if the user had made changes.
matches_history () {
    local file=$1 rel=$2 to_blob
    to_blob=$(git -C "$REPO_ROOT" hash-object "$file" 2>/dev/null) || return 1
    git -C "$REPO_ROOT" log -n "$HISTORY_DEPTH" --pretty=format: --raw -- "$rel" 2>/dev/null \
        | awk '{print $4}' | grep -qx "$to_blob"
}

install_file () {
    from=$INSTALL_FROM/$1
    to=$INSTALL_LOCATION/$2
    overwrite=${3:-"overwrite"}

    # Fresh install
    if [ ! -f "$to" ]; then
        mkdir -p "$(dirname "$to")"
        cp $from $to
        printf "> $(tput setaf 2)Installed$(tput cuf 2)$(tput sgr0) $2\n"
        return
    fi

    # Already up to date
    if cmp -s "$from" "$to"; then
        cp $from $to
        printf "> $(tput setaf 2)Installed$(tput cuf 2)$(tput sgr0) $2\n"
        return
    fi

    # $to matches a recent historical version of $from → repo moved
    # forward but the user didn't touch the local file. Silent overwrite.
    abs_from=$(cd "$(dirname "$from")" && pwd)/$(basename "$from")
    rel_from=${abs_from#$REPO_ROOT/}
    if matches_history "$to" "$rel_from"; then
        cp $from $to
        printf "> $(tput setaf 2)Installed$(tput cuf 2)$(tput sgr0) $2\n"
        return
    fi

    # Real local divergence
    diff $to $from > $to.diff
    if [ "$overwrite" = "overwrite" ]; then
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
}

# clone a git repo, or fast-forward if it already exists
clone_or_pull () {
    url=$1
    dir=$2
    if [ ! -d "$dir" ]; then
        git clone -q "$url" "$dir" > /dev/null
    else
        git -C "$dir" pull -q --ff-only > /dev/null
    fi
}

# --------------------------------------------------------- #
# --------------------- start install --------------------- #
# --------------------------------------------------------- #

printf -- "$(tput bold)---- Starting install in $INSTALL_LOCATION ----$(tput sgr0)\n"

case $INSTALL_SHELL in
    zsh)
        # plain zsh — no oh-my-zsh dependency
        # Everything (lib files, plugins, completions, compdump cache) lives
        # under ~/.zsh/. Only .zshrc and .zshenv stay in $HOME.
        mkdir -p "$INSTALL_LOCATION/.zsh/completions"
        mkdir -p "$INSTALL_LOCATION/.zsh/plugins"

        install_file .zshenv .zshenv
        install_file .zshrc  .zshrc

        # shared lib files (sourced by .zshrc from $ZSH_SCRIPTS = ~/.zsh)
        install_file ../lib/options.zsh      .zsh/options.zsh
        install_file ../lib/completions.zsh  .zsh/completions.zsh
        install_file ../lib/keybindings.zsh  .zsh/keybindings.zsh
        install_file ../lib/prompt.zsh       .zsh/prompt.zsh
        install_file ../lib/colorize.zsh     .zsh/colorize.zsh
        install_file ../lib/plugins.zsh      .zsh/plugins.zsh

        # rustup completion (autoloaded via fpath)
        install_file ../completions/_rustup  .zsh/completions/_rustup

        # external plugins
        clone_or_pull https://github.com/romkatv/zsh-defer.git \
            "$INSTALL_LOCATION/.zsh/plugins/zsh-defer"
        clone_or_pull https://github.com/zsh-users/zsh-autosuggestions.git \
            "$INSTALL_LOCATION/.zsh/plugins/zsh-autosuggestions"
        clone_or_pull https://github.com/zsh-users/zsh-syntax-highlighting.git \
            "$INSTALL_LOCATION/.zsh/plugins/zsh-syntax-highlighting"
        ;;

    omz)
        # legacy: oh-my-zsh-based setup
        if ! [ -d "$INSTALL_LOCATION/.oh-my-zsh/custom" ]; then
            printf "Install Oh-my-zsh. Or the folder '$INSTALL_LOCATION/.oh-my-zsh/custom' is missing\n"
            exit 2
        fi
        ZSH_CUSTOM_DIR=.oh-my-zsh/custom

        if ! [ -d "$INSTALL_LOCATION/.config" ]; then
            mkdir $INSTALL_LOCATION/.config
        fi
        if ! [ -d "$INSTALL_LOCATION/.config/zsh" ]; then
            mkdir $INSTALL_LOCATION/.config/zsh
        fi

        install_file .zshenv .zshenv
        install_file .zshrc .zshrc
        install_file zshrc_full.sh .config/zsh/zshrc_full.sh
        install_file ../oh-my-zsh/rustup $ZSH_CUSTOM_DIR/rustup
        install_file ../oh-my-zsh/sem.zsh-theme $ZSH_CUSTOM_DIR/themes/sem.zsh-theme
        install_file ../oh-my-zsh/sem_git.zsh-theme $ZSH_CUSTOM_DIR/themes/sem_git.zsh-theme
        if [ "$INSTALL_SYSTEM" = "macos" ]; then
            install_file ../oh-my-zsh/fast_directory_switch_uni.zsh $ZSH_CUSTOM_DIR/fast_directory_switch_uni.zsh
        fi

        # set basic or full interactive shell (write the mode into a dedicated
        # file rather than appending to .zshenv each run — appending used to
        # pile up duplicate INTERACTIVE_SHELL lines on re-install).
        MODE_FILE="$INSTALL_LOCATION/.config/zsh/interactive_mode"
        echo "export INTERACTIVE_SHELL=$INSTALL_INTERACTIVE" > "$MODE_FILE"
        # ensure .zshenv sources it (idempotent)
        if ! grep -q 'interactive_mode' "$INSTALL_LOCATION/.zshenv" 2>/dev/null; then
            printf '\n[ -f "$HOME/.config/zsh/interactive_mode" ] && source "$HOME/.config/zsh/interactive_mode"\n' \
                >> "$INSTALL_LOCATION/.zshenv"
        fi

        # install extern plugins
        clone_or_pull https://github.com/zsh-users/zsh-autosuggestions \
            "$INSTALL_LOCATION/$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions"
        clone_or_pull https://github.com/zsh-users/zsh-syntax-highlighting.git \
            "$INSTALL_LOCATION/$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting"
        ;;

    bash)
        install_file .bash_profile .bash_profile
        install_file .bashrc .bashrc
        install_file .bash_aliases .bash_aliases
        if [ "$INSTALL_SYSTEM" = "macos" ]; then
            mkdir -p $INSTALL_LOCATION/.bash
            install_file ../../omz/oh-my-zsh/fast_directory_switch_uni.zsh .bash/fast_directory_switch_uni.sh
        fi
        # set basic or full interative shell
        echo -e "\nINTERACTIVE_SHELL=$INSTALL_INTERACTIVE" >> $INSTALL_LOCATION/.bash_profile
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
#install_file ../../config/default-python-packages .config/default-python-packages "overwrite"
#install_file ../../config/asdfrc .config/asdfrc "overwrite"

printf -- "$(tput bold)---- Done ----$(tput sgr0)\n"

# reshim if asdf is installed
if command -v asdf 1>/dev/null 2>&1; then
    asdf reshim
fi

# show command to delete all diff files
if ! [ ${#DIFF_FILES[@]} -eq 0 ]; then
    joined_diff_files=$(printf " %s" "${DIFF_FILES[@]}")

    printf -- "If you want to remove all of the .diff files execute\n"
    printf "rm ${joined_diff_files:1}\n"
    if [[ "$INSTALL_SYSTEM" == "macos" ]]; then
        echo -n "rm ${joined_diff_files:1}" | pbcopy
    fi
fi
