# Two-line prompt. Two styles, switched via $ZSH_PROMPT_STYLE:
#   simple (default) — vcs_info, branch + staged/unstaged glyphs only. ~3-10 ms.
#   rich             — port of omz sem_git.zsh-theme: clean/staged/changed/
#                      deleted/untracked counts + stash + ahead/behind RPROMPT.
#                      One `git status --porcelain=v2` fork per precmd.
#
# Switch at any time:  ZSH_PROMPT_STYLE=rich exec zsh
# Or persist in .zshenv:  export ZSH_PROMPT_STYLE=rich

autoload -Uz add-zsh-hook

if [[ ${ZSH_PROMPT_STYLE:-simple} == rich ]]; then

    # 256-color codes used by the original theme:
    #   022 dark green   042 teal           088 dark red
    #   124 medium red   202 orange
    _zsh_git_prompt() {
        GIT_PROMPT=""
        GIT_PROMPT_R=""

        local out
        out=$(command git status --porcelain=v2 --branch --show-stash \
                                  --ignore-submodules=dirty 2>/dev/null) || return
        [[ -z $out ]] && return

        local branch="" oid="" upstream="" ab="" line x y
        local -i ahead=0 behind=0 stash=0
        local -i staged=0 changed=0 deleted=0 untracked=0

        for line in ${(f)out}; do
            case $line in
                '# branch.head '*)     branch=${line#'# branch.head '} ;;
                '# branch.oid '*)      oid=${line#'# branch.oid '} ;;
                '# branch.upstream '*) upstream=${line#'# branch.upstream '} ;;
                '# branch.ab '*)
                    ab=${line#'# branch.ab '}
                    ahead=${${ab%% *}#+}
                    behind=${${ab##* }#-}
                    ;;
                '# stash '*)           stash=${line#'# stash '} ;;
                '? '*)                 (( untracked++ )) ;;
                '1 '*|'2 '*)
                    x=${line[3]}; y=${line[4]}
                    [[ $x != '.' ]] && (( staged++ ))
                    case $y in
                        D)           (( deleted++ )) ;;
                        M|T|R|C|A|U) (( changed++ )) ;;
                    esac
                    ;;
                'u '*) (( changed++ )) ;;  # unmerged counts as a worktree change
            esac
        done

        [[ -z $branch ]] && return
        [[ $branch == '(detached)' ]] && branch="detached@${oid[1,7]}"

        local pre="" post="" color=""
        if (( staged + changed + deleted + untracked == 0 )); then
            pre="%B%F{green}✔%f%b"; color="%B%F{green}"
        fi
        if (( staged )); then
            pre="%F{022}✔%f"; color="%F{022}"
        fi
        if (( untracked )); then
            pre="%B%F{202}✘%f%b"; color="%B%F{202}"
            post+=" %F{202}✚${untracked}%f"
        fi
        if (( changed )); then
            pre="%B%F{088}✘%f%b"; color="%B%F{088}"
            post+=" %F{088}<${changed}>%f"
        fi
        if (( deleted )); then
            pre="%B%F{088}✘%f%b"; color="%B%F{088}"
            post+=" %F{124}-${deleted}%f"
        fi
        (( staged )) && post+=" %F{022}●${staged}%f"
        (( stash ))  && post+=" %F{042}[⚑${stash}]%f"

        GIT_PROMPT=" ${pre} ${color}${branch}%f%b${post}"

        if (( ahead || behind )); then
            local r="|"
            (( behind )) && r+="%F{red}↓%f${behind}"
            (( ahead ))  && r+="%F{green}↑%f${ahead}"
            GIT_PROMPT_R="${r} ${upstream}"
        fi
    }

    add-zsh-hook precmd _zsh_git_prompt

    PROMPT='%f%n@%M:%F{004} %6~%f${GIT_PROMPT}
%* %F{001}❯ %f'
    RPROMPT='${GIT_PROMPT_R}'

else

    # simple: built-in vcs_info, no count parsing.
    autoload -Uz vcs_info

    zstyle ':vcs_info:*'      enable git
    zstyle ':vcs_info:git:*'  check-for-changes true
    zstyle ':vcs_info:git:*'  stagedstr   '%F{022}●%f'
    zstyle ':vcs_info:git:*'  unstagedstr '%F{088}✗%f'
    zstyle ':vcs_info:git:*'  formats       ' %F{green}%b%f %c%u'
    zstyle ':vcs_info:git:*'  actionformats ' %F{green}%b%f|%F{red}%a%f %c%u'

    add-zsh-hook precmd vcs_info

    PROMPT='%f%n@%M:%F{004} %6~%f${vcs_info_msg_0_}
%* %F{001}❯ %f'
    RPROMPT=''

fi
