# .bashrc - bash configuration (kept in step with zshrc)

# only run for interactive shells
[[ $- != *i* ]] && return

### Prompt ###

OFF="\[\033[00m\]"
GREY="\[\033[01;30m\]"
RED="\[\033[01;31m\]"
GREEN="\[\033[01;32m\]"
YELLOW="\[\033[01;33m\]"
BLUE="\[\033[01;34m\]"
PINK="\[\033[01;35m\]"
TEAL="\[\033[01;36m\]"
WHITE="\[\033[01;37m\]"

case $USER in
    randy) COLOR=${GREEN} ;;   # green for randy
    root)  COLOR=${RED} ;;     # red for root
    *)     COLOR=${YELLOW} ;;  # yellow for anyone else
esac

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

# ignore duplicate lines and lines starting with a space
export HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

### End History ###

### Color modes ###

alias ls='ls --color=auto -F'
alias grep='grep --color=auto'

### End Color modes ###

### Aliases ###

alias h='history'
alias j='jobs'
alias ll='ls -lh'
alias la='ls -Ah'
alias lla='ls -lAh'

### End Aliases

### Functions ###

up() {
    local x=''
    for i in $(seq ${1:-1}); do
        x="$x../"
    done
    cd $x
}

### End Functions ###
