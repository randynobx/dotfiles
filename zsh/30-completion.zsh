# 30-completion.zsh - completion system and fzf

autoload -Uz compinit && compinit

# allow approximate matches
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# menu-select PIDs for kill
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

# fzf: Ctrl+r history, Ctrl+t files, Alt+c cd (after compinit so its
# completion hooks register); fall back to built-in history search
if (( $+commands[fzf] )); then
    source <(fzf --zsh)
    # use ripgrep to list files: faster, and skips anything gitignored
    if (( $+commands[rg] )); then
        export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
        export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
    fi
    export FZF_TMUX=1
    export FZF_TMUX_HEIGHT=20
else
    bindkey '^R' history-incremental-search-backward
fi
