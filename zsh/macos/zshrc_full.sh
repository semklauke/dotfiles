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

# start pyenv if installed
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi

# start jenv 
if command -v jenv 1>/dev/null 2>&1; then
    eval "$(jenv init -)"
fi

# source asdf if installed
if command -v asdf 1>/dev/null 2>&1; then 
    #source "$(brew --prefix asdf)/libexec/asdf.sh"
    #source ~/.asdf/plugins/java/set-java-home.zsh
    #asdf reshim
fi
