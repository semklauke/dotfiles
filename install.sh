#!/bin/bash

## USAGE:
## ./install.sh <shell> <system> [<interactive_mode>] [<homefolder>]
## shell  = zsh  (plain zsh, no oh-my-zsh)
##        | omz  (legacy oh-my-zsh setup, debian|macos)
##        | bash
## system = macos | debian
## interactive_mode (omz/bash only) = basic | full   (default: basic)
## homefolder default is $HOME. For zsh it may also be the third argument.

INSTALL_SHELL=${1:-}
INSTALL_SYSTEM=${2:-}
INSTALL_INTERACTIVE=${3:-"basic"}
if [ "$INSTALL_SHELL" = "zsh" ] && [ $# -eq 3 ] \
    && [ "$3" != "basic" ] && [ "$3" != "full" ]; then
    INSTALL_LOCATION=$3
    INSTALL_INTERACTIVE=full
else
    INSTALL_LOCATION=${4:-$HOME}
fi

# check input
USAGE_PROMPT="Usage: ./install.sh <shell> <system> [<interactive_mode>] [<homefolder>]\n"\
"- <shell> must be 'zsh', 'omz' or 'bash'\n"\
"- <system> must be 'macos' or 'debian'\n"\
"- <interactive_mode> 'full' or 'basic' (omz/bash only). Default 'basic'\n"\
"- <homefolder> defaults to \$HOME\n"
if [ "$INSTALL_SYSTEM" != "macos" ] && [ "$INSTALL_SYSTEM" != "debian" ]; then
    printf '%b' "$USAGE_PROMPT"
    exit 1
fi
if [ "$INSTALL_SHELL" != "zsh" ] && [ "$INSTALL_SHELL" != "omz" ] \
    && [ "$INSTALL_SHELL" != "bash" ]; then
    printf '%b' "$USAGE_PROMPT"
    exit 1
fi
if [ "$INSTALL_SHELL" != "zsh" ] && [ "$INSTALL_INTERACTIVE" != "basic" ] \
    && [ "$INSTALL_INTERACTIVE" != "full" ]; then
    printf '%b' "$USAGE_PROMPT"
    exit 1
fi
[[ $INSTALL_LOCATION == '~' ]] && INSTALL_LOCATION=$HOME
while [ "$INSTALL_LOCATION" != "/" ] && [ "${INSTALL_LOCATION%/}" != "$INSTALL_LOCATION" ]; do
    INSTALL_LOCATION=${INSTALL_LOCATION%/}
done

REPO_ROOT=$(cd "$(dirname "$0")" && pwd)
INSTALL_FROM="$REPO_ROOT/$INSTALL_SHELL/$INSTALL_SYSTEM"
DIFF_FILES=()

if [ ! -d "$INSTALL_FROM" ]; then
    printf 'No configuration exists for %s/%s.\n' "$INSTALL_SHELL" "$INSTALL_SYSTEM" >&2
    exit 1
fi

if [ -t 1 ] && command -v tput >/dev/null 2>&1; then
    STYLE_BOLD=$(tput bold)
    STYLE_RESET=$(tput sgr0)
    COLOR_GREEN=$(tput setaf 2)
    COLOR_YELLOW=$(tput setaf 3)
    COLOR_RED=$(tput setaf 1)
else
    STYLE_BOLD=
    STYLE_RESET=
    COLOR_GREEN=
    COLOR_YELLOW=
    COLOR_RED=
fi

# Returns 0 if $1 matches any committed version of repo path $2. This
# distinguishes an older install after git pull from an actual local edit.
matches_history () {
    local file=$1 rel=$2 blob
    blob=$(git -C "$REPO_ROOT" hash-object "$file" 2>/dev/null) || return 1
    git -C "$REPO_ROOT" rev-list --objects --all -- "$rel" 2>/dev/null \
        | grep -Fqx "$blob $rel"
}

# Old installer versions appended the interactive mode directly to .zshenv.
# Treat those generated lines as installer state, while still detecting every
# other local edit. This also makes omz -> plain-zsh migration warning-free.
matches_managed_zshenv () {
    local file=$1 destination=$2 candidate installed_content candidate_content
    local relpath commits commit
    [[ $destination == .zshenv ]] || return 1

    installed_content=$(sed -E \
        -e '/^[[:space:]]*(export[[:space:]]+)?INTERACTIVE_SHELL=(basic|full)[[:space:]]*$/d' \
        -e '/\.config\/zsh\/interactive_mode/d' \
        -e '/^[[:space:]]*$/d' "$file")

    for candidate in "$REPO_ROOT/omz/$INSTALL_SYSTEM/.zshenv" \
                     "$REPO_ROOT/zsh/$INSTALL_SYSTEM/.zshenv"; do
        [ -f "$candidate" ] || continue
        candidate_content=$(sed -E \
            -e '/^[[:space:]]*(export[[:space:]]+)?INTERACTIVE_SHELL=(basic|full)[[:space:]]*$/d' \
            -e '/\.config\/zsh\/interactive_mode/d' \
            -e '/^[[:space:]]*$/d' "$candidate")
        [ "$installed_content" = "$candidate_content" ] && return 0
    done

    # Also recognize older tracked versions, including before zsh was renamed
    # to omz in the repository.
    for relpath in "omz/$INSTALL_SYSTEM/.zshenv" "zsh/$INSTALL_SYSTEM/.zshenv"; do
        commits=$(git -C "$REPO_ROOT" log --format=%H --all -- "$relpath" 2>/dev/null)
        for commit in $commits; do
            candidate_content=$(git -C "$REPO_ROOT" show "$commit:$relpath" 2>/dev/null \
                | sed -E \
                    -e '/^[[:space:]]*(export[[:space:]]+)?INTERACTIVE_SHELL=(basic|full)[[:space:]]*$/d' \
                    -e '/\.config\/zsh\/interactive_mode/d' \
                    -e '/^[[:space:]]*$/d')
            [ "$installed_content" = "$candidate_content" ] && return 0
        done
    done
    return 1
}

install_file () {
    local from="$INSTALL_FROM/$1"
    local to="$INSTALL_LOCATION/$2"
    local display=$2
    local overwrite=${3:-overwrite}
    local abs_from rel_from

    if [ ! -f "$from" ]; then
        printf 'Missing source file: %s\n' "$from" >&2
        return 1
    fi

    # Fresh install
    if [ ! -f "$to" ]; then
        mkdir -p "$(dirname "$to")"
        cp "$from" "$to" || return
        printf '> %sInstalled%s %s\n' "$COLOR_GREEN" "$STYLE_RESET" "$display"
        return
    fi

    # Already up to date
    if cmp -s "$from" "$to"; then
        rm -f "$to.diff"
        printf '> %sUp to date%s %s\n' "$COLOR_GREEN" "$STYLE_RESET" "$display"
        return
    fi

    # $to matches a recent historical version of $from → repo moved
    # forward but the user didn't touch the local file. Silent overwrite.
    abs_from=$(cd "$(dirname "$from")" && pwd)/$(basename "$from")
    rel_from=${abs_from#$REPO_ROOT/}
    if matches_history "$to" "$rel_from" || matches_managed_zshenv "$to" "$display"; then
        cp "$from" "$to" || return
        rm -f "$to.diff"
        printf '> %sUpdated%s %s\n' "$COLOR_GREEN" "$STYLE_RESET" "$display"
        return
    fi

    # Real local divergence
    diff -u "$to" "$from" > "$to.diff"
    if [ "$overwrite" = "overwrite" ]; then
        DIFF_FILES+=( "$to.diff" )
        cp "$from" "$to" || return
        printf '> %sOverwritten%s %s\n' "$COLOR_RED" "$STYLE_RESET" "$display"
        printf '  See %s\n' "$to.diff"
    else
        printf '> %sKeeping%s %s\n' "$COLOR_YELLOW" "$STYLE_RESET" "$display"
        printf '  Replace manually with: cp %q %q\n' "$from" "$to"
        rm "$to.diff"
    fi
}

# clone a git repo, or fast-forward if it already exists
clone_or_pull () {
    local url=$1 dir=$2
    if [ -d "$dir/.git" ]; then
        git -C "$dir" pull -q --ff-only || {
            printf 'Could not update plugin: %s\n' "$dir" >&2
            return 1
        }
    elif [ -e "$dir" ]; then
        printf 'Plugin path exists but is not a git checkout: %s\n' "$dir" >&2
        return 1
    else
        mkdir -p "$(dirname "$dir")"
        git clone --depth 1 -q "$url" "$dir" || {
            printf 'Could not install plugin: %s\n' "$url" >&2
            return 1
        }
    fi
}

# --------------------------------------------------------- #
# --------------------- start install --------------------- #
# --------------------------------------------------------- #

printf '%s---- Starting install in %s ----%s\n' "$STYLE_BOLD" "$INSTALL_LOCATION" "$STYLE_RESET"

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
        install_file ../lib/aliases.zsh      .zsh/aliases.zsh
        install_file ../lib/sudo.zsh         .zsh/sudo.zsh

        # completions (autoloaded via fpath)
        install_file ../completions/_rustup  .zsh/completions/_rustup
        install_file ../completions/_mix     .zsh/completions/_mix

        if [ "$INSTALL_SYSTEM" = "macos" ]; then
            install_file ../lib/macos.zsh .zsh/macos.zsh
            install_file ../../omz/oh-my-zsh/fast_directory_switch_uni.zsh \
                .zsh/fast_directory_switch_uni.zsh
        fi

        # external plugins
        clone_or_pull https://github.com/romkatv/zsh-defer.git \
            "$INSTALL_LOCATION/.zsh/plugins/zsh-defer" || exit 3
        clone_or_pull https://github.com/zsh-users/zsh-autosuggestions.git \
            "$INSTALL_LOCATION/.zsh/plugins/zsh-autosuggestions" || exit 3
        clone_or_pull https://github.com/zsh-users/zsh-syntax-highlighting.git \
            "$INSTALL_LOCATION/.zsh/plugins/zsh-syntax-highlighting" || exit 3
        clone_or_pull https://github.com/zsh-users/zsh-history-substring-search.git \
            "$INSTALL_LOCATION/.zsh/plugins/zsh-history-substring-search" || exit 3
        ;;

    omz)
        # legacy: oh-my-zsh-based setup
        if ! [ -d "$INSTALL_LOCATION/.oh-my-zsh/custom" ]; then
            printf "Install Oh-my-zsh. Or the folder '$INSTALL_LOCATION/.oh-my-zsh/custom' is missing\n"
            exit 2
        fi
        ZSH_CUSTOM_DIR=.oh-my-zsh/custom

        mkdir -p "$INSTALL_LOCATION/.config/zsh"

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
        # file. The tracked .zshenv sources it, so the installed file is never
        # mutated and reinstalls remain idempotent.
        MODE_FILE="$INSTALL_LOCATION/.config/zsh/interactive_mode"
        printf 'export INTERACTIVE_SHELL=%s\n' "$INSTALL_INTERACTIVE" > "$MODE_FILE"

        # install extern plugins
        clone_or_pull https://github.com/zsh-users/zsh-autosuggestions \
            "$INSTALL_LOCATION/$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions" || exit 3
        clone_or_pull https://github.com/zsh-users/zsh-syntax-highlighting.git \
            "$INSTALL_LOCATION/$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting" || exit 3
        ;;

    bash)
        install_file .bash_profile .bash_profile
        install_file .bashrc .bashrc
        install_file .bash_aliases .bash_aliases
        if [ "$INSTALL_SYSTEM" = "macos" ]; then
            mkdir -p "$INSTALL_LOCATION/.bash"
            install_file ../../omz/oh-my-zsh/fast_directory_switch_uni.zsh .bash/fast_directory_switch_uni.sh
        fi
        ;;

    *)
        printf '%b' "$USAGE_PROMPT"
        exit 1
        ;;
esac

# install for both
install_file ../../git/.gitconfig .gitconfig "keep"
install_file ../../git/.gitignore_global .gitignore_global "overwrite"
install_file ../../configs/vimrc .vimrc "keep"
#install_file ../../config/default-python-packages .config/default-python-packages "overwrite"
#install_file ../../config/asdfrc .config/asdfrc "overwrite"

printf '%s---- Done ----%s\n' "$STYLE_BOLD" "$STYLE_RESET"

# Reshim only when installing the active home, not a test/remote home.
if [ "$INSTALL_LOCATION" = "$HOME" ] && command -v asdf 1>/dev/null 2>&1; then
    asdf reshim || printf 'Warning: asdf reshim failed.\n' >&2
fi

# show command to delete all diff files
if ! [ ${#DIFF_FILES[@]} -eq 0 ]; then
    joined_diff_files=$(printf " %s" "${DIFF_FILES[@]}")

    printf 'If you want to remove all of the .diff files execute\n'
    printf 'rm %s\n' "${joined_diff_files:1}"
    if [[ "$INSTALL_SYSTEM" == "macos" ]] && command -v pbcopy >/dev/null 2>&1; then
        printf 'rm %s' "${joined_diff_files:1}" | pbcopy || true
    fi
fi

exit 0
