### Prompt ###

ROOT=0
randy=1000
ID=$(id | cut -d'=' -f2 | cut -d'(' -f1)

OFF="\[\033[00m\]"
GREY="\[\033[01;30m\]"
RED="\[\033[01;31m\]"
GREEN="\[\033[01;32m\]"
YELLOW="\[\033[01;33m\]"
BLUE="\[\033[01;34m\]"
PINK="\[\033[01;35m\]"
TEAL="\[\033[01;36m\]"
WHITE="\[\033[01;37m\]"

if [ "${ID}" == ${randy} ] ; then
    COLOR=${GREEN}
else if [ "${ID}" == "${ROOT}" ] ; then
    COLOR=${RED}
else
    COLOR=${YELLOW}
fi fi

export PS1="\!:${COLOR}\u${OFF}@${TEAL}\h${OFF}:\W${COLOR}\$${OFF} "

### End Prompt ###

### Completion ###

if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

### End Completion ###

### History ###

export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTTIMEFORMAT="%Y/%m/%d %H:%M:%S "

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

### End History ###

### Color modes ###

alias ls='ls --color=auto '
alias grep='grep --color=auto '

### End Color modes ###

### Aliases ###

alias h='history'
alias j='jobs'
alias p='pinky'
alias ls='ls -F'
alias ll='ls -lF'
alias la='ls -AF'
alias lla='ls -lAF'

### End Aliases

if [ -n "$TMUX" ]; then
    # set $TERM for tmux
    export TERM=screen-256color
fi
