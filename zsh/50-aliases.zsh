# 50-aliases.zsh - aliases

if [[ "$TERM" != "dumb" ]]; then
    alias ls='ls --color=auto -F'                  # colorized, type markers (/ dir, * exec)
    alias dir='ls --color=auto -F'                 # same as ls
    alias grep='grep --color=auto'                 # highlight matches
fi

alias ll='ls -lh'                                  # long listing, human sizes
alias la='ls -Ah'                                  # all files incl. hidden
alias lla='ls -lAh'                                # long listing incl. hidden

alias h='history'                                  # show history
alias j='jobs'                                     # list background jobs

alias python='python3'                             # always python 3
alias pip='pip3'                                   # always pip for python 3

### git (longer-form git aliases live in gitconfig: git lg, last, undo...) ###
alias gs='git status -sb'                          # short status + branch/ahead-behind
alias gd='git diff'                                # unstaged changes
alias gds='git diff --staged'                      # what you're about to commit
alias ga='git add'                                 # stage files
alias gap='git add -p'                             # stage hunk by hunk
alias gc='git commit'                              # commit staged changes
alias gl='git log --oneline --graph --decorate -20' # last 20 commits as a graph
alias gp='git push'                                # push current branch
alias gpf='git push --force-with-lease'            # safe force-push
alias gpl='git pull'                               # pull (fast-forward only)
alias gsw='git switch'                             # switch branches
