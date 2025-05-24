# full features interactive shell

ZSH_THEME="sem_git"
plugins=(
    git-prompt 
    colorize 
    aliases 
    history-substring-search 
    macos 
    mix 
    sudo 
    zsh-autosuggestions 
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh


# source asdf if installed
if command -v asdf 1>/dev/null 2>&1; then 
    export ASDF_DATA_DIR="$HOME/.asdf"
    export PATH="$ASDF_DATA_DIR/shims:$PATH"
    source "$(brew --prefix asdf)/libexec/asdf.sh"
    source ~/.asdf/plugins/java/set-java-home.zsh
    #asdf reshim
fi