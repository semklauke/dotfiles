# Color shortcuts
RED=$fg[red]
YELLOW=$fg[yellow]
GREEN=$fg[green]
WHITE=$fg[white]
BLUE=$fg[blue]
RED_BOLD=$fg_bold[red]
YELLOW_BOLD=$fg_bold[yellow]
GREEN_BOLD=$fg_bold[green]
WHITE_BOLD=$fg_bold[white]
BLUE_BOLD=$fg_bold[blue]
RESET_COLOR=$reset_color


ZSH_THEME_GIT_PROMPT_UNMERGED=" %{$FG[088]%}unmerged"
ZSH_THEME_GIT_PROMPT_DELETED=" %{$FG[088]%}deleted"
ZSH_THEME_GIT_PROMPT_RENAMED=" %{$fg[yellow]%}renamed"
ZSH_THEME_GIT_PROMPT_MODIFIED=" %{$fg[yellow]%}modified"
ZSH_THEME_GIT_PROMPT_ADDED=" %{$fg[green]%}added"
ZSH_THEME_GIT_PROMPT_UNTRACKED=" %{$reset_color%}untracked"

ZSH_THEME_GIT_COMMITS_BEHIND_PREFIX="[%{$reset_color%}behind %{$FG[088]%}"
ZSH_THEME_GIT_COMMITS_BEHIND_SUFFIX="%{$reset_color%}]"

# Format for git_prompt_long_sha() and git_prompt_short_sha()
ZSH_THEME_GIT_PROMPT_SHA_BEFORE=" %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$FX[reset]%}%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$FX[bold]%}%{$FG[088]%}%{✘%G%} "
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}%{✔%G%} "

PROMPT='%{$reset_color%}%n@%M%{$reset_color%}:%{$FG[004]%} %6~ $(parse_git_dirty)$(git_current_branch)%{$FX[reset]%}%{$reset_color%}
%* %{$FG[001]%}❯ %{$reset_color%}'

RPROMPT='$(git_commits_behind)$(git_remote_status)'