git_sem_status() {
    precmd_update_git_vars
    if [ -n "$__CURRENT_GIT_STATUS" ]; then
        PRE_BRANCH=""
        POST_BRANCH=""
        BRANCH_COLOR=""
        if [ "$GIT_CLEAN" -eq "1" ]; then
            PRE_BRANCH="%{$fg_bold[green]%}%{✔%G%}"
            BRANCH_COLOR="%{$fg_bold[green]%}"
        fi
        if [ "$GIT_STAGED" -ne "0" ]; then
            PRE_BRANCH="%{$FG[022]%}%{✔%G%}"
            BRANCH_COLOR="%{$FG[022]%}"
        fi
        if [ "$GIT_UNTRACKED" -ne "0" ]; then
            PRE_BRANCH="%{$FX[bold]%}%{$FG[202]%}%{✘%G%}"
            BRANCH_COLOR="%{$FX[bold]%}%{$FG[202]%}"
            POST_BRANCH="$POST_BRANCH %{$FG[202]%}%{✚%G%}$GIT_UNTRACKED"
        fi
        if [ "$GIT_CHANGED" -ne "0" ]; then
            PRE_BRANCH="%{$FX[bold]%}%{$FG[088]%}%{✘%G%}"
            BRANCH_COLOR="%{$FX[bold]%}%{$FG[088]%}"
            POST_BRANCH="$POST_BRANCH %{$FG[088]%}%{<%G%}$GIT_CHANGED%{>%G%}"
        fi
        if [ "$GIT_DELETED" -ne "0" ]; then
            PRE_BRANCH="%{$FX[bold]%}%{$FG[088]%}%{✘%G%}"
            BRANCH_COLOR="%{$FX[bold]%}%{$FG[088]%}"
            POST_BRANCH="$POST_BRANCH %{$FG[124]%}%{-%G%}$GIT_DELETED"
        fi
        if [ "$GIT_STAGED" -ne "0" ]; then
            POST_BRANCH="$POST_BRANCH %{$FG[022]%}%{●%G%}$GIT_STAGED"
        fi
        if [ "$GIT_STASHED" -ne "0" ]; then
            POST_BRANCH="$POST_BRANCH %{$FG[042]%}[%{⚑%G%}$GIT_STASHED]"
        fi
        OUT="$PRE_BRANCH $BRANCH_COLOR$GIT_BRANCH%{$reset_color%}$POST_BRANCH%{$reset_color%}"
        echo "$OUT"
    fi
}

git_sem_status_r() {
    if [ -n "$__CURRENT_GIT_STATUS" ]; then
        OUT="%{$reset_color%}|"
        if [ "$GIT_BEHIND" -ne "0" ]; then
            OUT="$OUT$ZSH_THEME_GIT_PROMPT_BEHIND$GIT_BEHIND%{${reset_color}%}"
        fi
        if [ "$GIT_AHEAD" -ne "0" ]; then
            OUT="$OUT$ZSH_THEME_GIT_PROMPT_AHEAD$GIT_AHEAD%{${reset_color}%}"
        fi
        if [ "$GIT_AHEAD" -ne "0" ] || [ "$GIT_BEHIND" -ne "0" ]; then
            echo "$OUT$GIT_UPSTREAM"
        fi
    fi
}

PROMPT='%{$reset_color%}%n@%M%{$reset_color%}:%{$FG[004]%} %6~ $(git_sem_status)%{$reset_color%}
%* %{$FG[001]%}❯ %{$reset_color%}'

RPROMPT='$(git_sem_status_r)'