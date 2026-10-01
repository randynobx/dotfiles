# 40-prompt.zsh - prompt and git status (vcs_info) in the right prompt
# %F{n} = palette color n, %B/%b = bold on/off, %f = default color.
# zsh knows these take no screen width, so no %{ %} wrappers needed.

MAIN_COLOR='%B%F{8}'    # bright black (Zenburn grey-green)
HOST_COLOR='%B%F{6}'    # cyan
DIR_COLOR='%b%F{7}'     # light grey, not bold
RESET_COLOR='%b%f'

case $USER in
    randy) USER_COLOR='%B%F{2}' ;;   # green for randy
    root)  USER_COLOR='%B%F{1}' ;;   # red for root
    *)     USER_COLOR='%B%F{3}' ;;   # yellow for anyone else
esac

PROMPT="${MAIN_COLOR}(${USER_COLOR}%n${MAIN_COLOR}@${HOST_COLOR}%m${MAIN_COLOR}|${DIR_COLOR}%1~${MAIN_COLOR})${USER_COLOR}%#${RESET_COLOR} "
PROMPT2="${MAIN_COLOR}... ${RESET_COLOR}"

### Git branch info ###

setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' stagedstr 'S'
zstyle ':vcs_info:*' unstagedstr 'U'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' actionformats '%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats       '%F{3}%c%F{1}%u %F{5}[%F{2}%b%F{5}]%f '

# show a T marker when the repo has untracked files
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked
+vi-git-untracked() {
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
        git status --porcelain | grep -q '??'; then
        hook_com[staged]+='T'
    fi
}

# refresh vcs_info once per prompt via precmd (no subshell per prompt)
autoload -Uz add-zsh-hook
add-zsh-hook precmd vcs_info
RPROMPT='${vcs_info_msg_0_}'
