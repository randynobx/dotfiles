################################################################################
## .zshrc - ZSH configuration
## author: randynobx <randynobx@gmail.com>
#################################################################################

### Misc ###

# allow comments
setopt interactive_comments

# use VI keybindings
bindkey -v

### End Misc ###


### History ###

HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt inc_append_history
setopt hist_ignore_dups
setopt hist_ignore_space

### End History ###


### Auto completion ###

autoload -Uz compinit && compinit

# allow approximate
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# tab completion for PID :D
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

# Prefer fzf for search, fallback to built-in if missing
# (sourced after compinit so fzf's completion hooks register)
if (( $+commands[fzf] )); then
    source <(fzf --zsh)
    export FZF_TMUX=1
    export FZF_TMUX_HEIGHT=20
else
    bindkey '^R' history-incremental-search-backward
fi

### End Auto completion ###


### Terminal colors ###

if [[ "$TERM" != "dumb" ]]; then
    alias ls='ls --color=auto -F'
    alias dir='ls --color=auto -F'
    export GREP_COLORS="mt=1;33"
    alias grep='grep --color=auto'
fi

### End Terminal colors ###


### Prompt ###
# %F{n} = palette color n, %B/%b = bold on/off, %f = default color.
# zsh knows these take no screen width, so no %{ %} wrappers needed.

MAIN_COLOR='%B%F{8}'    # bright black (Zenburn grey-green)
HOST_COLOR='%B%F{6}'    # cyan
DIR_COLOR='%b%F{7}'     # light grey, not bold
RESET_COLOR='%b%f'

case $USER in
    randy) USER_COLOR='%B%F{2}' ;;   # green for randy
    root)   USER_COLOR='%B%F{1}' ;;   # red for root
    *)   USER_COLOR='%B%F{3}' ;;   # yellow for anyone else
esac

PROMPT="${MAIN_COLOR}(${USER_COLOR}%n${MAIN_COLOR}@${HOST_COLOR}%m${MAIN_COLOR}|${DIR_COLOR}%1~${MAIN_COLOR})${USER_COLOR}%#${RESET_COLOR} "
PROMPT2="${MAIN_COLOR}... ${RESET_COLOR}"

### End Prompt ###


### Variables ###
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

### End Variables ###


### Aliases ###
alias h='history'
alias j='jobs'

alias python='python3'
alias pip='pip3'

alias ll='ls -lh'
alias la='ls -Ah'
alias lla='ls -lAh'

### End Aliases ###

### Functions ###

# up fuction for cd ..
up() {
    local x=''
    for i in $(seq ${1:-1}); do
        x="$x../"
    done
    cd $x
}

# start new ranger instance only if not already running in current shell
ra() {
    if [ -z "$RANGER_LEVEL" ]
    then
        ranger
    else
        exit
    fi
}

### End Functions ###

### Git branch info ###

setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:*' stagedstr 'S'
zstyle ':vcs_info:*' unstagedstr 'U'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' actionformats \
    '%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats       \
    '%F{3}%c%F{1}%u %F{5}[%F{2}%b%F{5}]%f '

zstyle ':vcs_info:*' enable git

### Display the existence of files not yet known to VCS

### git: Show marker (T) if there are untracked files in repository
# Make sure you have added staged to your 'formats':  %c
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked

+vi-git-untracked(){
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
        git status --porcelain | grep '??' &> /dev/null ; then
        # This will show the marker if there are any untracked files in repo.
        # If instead you want to show the marker only if there are untracked
        # files in $PWD, use:
        #[[ -n $(git ls-files --others --exclude-standard) ]] ; then
        hook_com[staged]+='T'
    fi
}

# refresh vcs_info once per prompt via precmd (no subshell per prompt)
autoload -Uz add-zsh-hook
add-zsh-hook precmd vcs_info
RPROMPT='${vcs_info_msg_0_}'

### End Git branch info ###

export PATH="$PATH:$HOME/bin"
