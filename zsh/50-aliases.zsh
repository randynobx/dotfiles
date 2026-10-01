# 50-aliases.zsh - aliases

if [[ "$TERM" != "dumb" ]]; then
    alias ls='ls --color=auto -F'
    alias dir='ls --color=auto -F'
    alias grep='grep --color=auto'
fi

alias ll='ls -lh'
alias la='ls -Ah'
alias lla='ls -lAh'

alias h='history'
alias j='jobs'

alias python='python3'
alias pip='pip3'

### git (longer-form git aliases live in gitconfig: git lg, last, undo...) ###
alias gs='git status -sb'                  # short status + branch/ahead-behind
alias gd='git diff'
alias gds='git diff --staged'              # what you're about to commit
alias ga='git add'
alias gap='git add -p'                     # stage hunk by hunk
alias gc='git commit'
alias gl='git log --oneline --graph --decorate -20'
alias gp='git push'
alias gpf='git push --force-with-lease'    # safe force-push
alias gpl='git pull'
alias gsw='git switch'
