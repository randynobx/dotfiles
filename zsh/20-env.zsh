# 20-env.zsh - environment variables and PATH (before anything checks $commands)

export PATH="$PATH:$HOME/bin"
typeset -U path               # no duplicates
path=($HOME/.local/bin $path) # pipx, Claude Code; first, so pipx Ansible beats any system copy

if [[ $OSTYPE == darwin* ]]; then
    if (( $+commands[mate] )); then
        export EDITOR="${commands[mate]} -w"
    else
        export EDITOR=vim
    fi
    export BROWSER=brave
else
    export EDITOR=vim
fi

export PAGER=less
export LESS="-R -iMx4"
export GREP_COLORS="mt=1;33"
