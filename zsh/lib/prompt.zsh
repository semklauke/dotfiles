# prompt with git status via built-in vcs_info (no fork/python per prompt)

autoload -Uz vcs_info
autoload -Uz add-zsh-hook

zstyle ':vcs_info:*'      enable git
zstyle ':vcs_info:git:*'  check-for-changes true
zstyle ':vcs_info:git:*'  stagedstr   '%F{022}●%f'
zstyle ':vcs_info:git:*'  unstagedstr '%F{088}✗%f'
zstyle ':vcs_info:git:*'  formats       ' %F{green}%b%f %c%u'
zstyle ':vcs_info:git:*'  actionformats ' %F{green}%b%f|%F{red}%a%f %c%u'

add-zsh-hook precmd vcs_info

# Two-line prompt, ported from sem.zsh-theme / sem_git.zsh-theme to native
# zsh prompt escapes (%F{...}, %B, %f) — no $FG[]/$reset_color spectrum dep.
PROMPT='%f%n@%M:%F{004} %6~%f${vcs_info_msg_0_}
%* %F{001}❯ %f'
RPROMPT=''
