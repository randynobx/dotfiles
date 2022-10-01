# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"
################################################################################
## .zshrc - ZSH configuration
## author: randynobx <randynobx@gmail.com>
#################################################################################

### Misc ###

# allow comments
setopt interactive_comments

# use VI keybindings
bindkey -v
bindkey '^R' history-incremental-search-backward

### End Misc ###


### History ###

HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt appendhistory
setopt hist_ignore_dups
setopt hist_ignore_space

### End History ###


### Auto completion ###

zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit && compinit

# allow approximate
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# tab completion for PID :D
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

### End Auto completion ###


### Terminal colors ###

# directory colors
if [ "$TERM" != "dumb" ]; then
    # directory colors
    alias ls='ls --color=auto -F'
    alias dir='ls --color=auto -F'

   # grep color
    export GREP_COLOR="1;33"
    alias grep='grep --color=auto'
fi

# Zenburn colors for console
 if [ "$TERM" = "xterm-256color" ]; then
     echo -en "\e]P03f3f3f" # zenburn black (normal black)
     echo -en "\e]P8709080" # bright-black (darkgrey)
     echo -en "\e]P1705050" # red (darkred)
     echo -en "\e]P9dca3a3" # bright-red (red)
     echo -en "\e]P260b48a" # green (darkgreen)
     echo -en "\e]PAc3bf9f" # bright-green (green)
     echo -en "\e]P3dfaf8f" # yellow (brown)
     echo -en "\e]PBf0dfaf" # bright-yellow (yellow)
     echo -en "\e]P4506070" # blue (darkblue)
     echo -en "\e]PC94bff3" # bright-blue (blue)
     echo -en "\e]P5dc8cc3" # purple (darkmagenta)
     echo -en "\e]PDec93d3" # bright-purple (magenta)
     echo -en "\e]P68cd0d3" # cyan (darkcyan)
     echo -en "\e]PE93e0e3" # bright-cyan (cyan)
     echo -en "\e]P7dcdccc" # white (lightgrey)
     echo -en "\e]PFffffff" # bright-white (white)
 fi

### End Terminal colors ###


### Prompt ###

MAIN_COLOR=$'%{\e[1;30m%}'
#USER_COLOR=$'%{\e[1;32m%}' ## This line is not necessary as USER_COLOR will be set below depending on current user
HOST_COLOR=$'%{\e[1;36m%}'
DIR_COLOR=$'%{\e[0;37m%}'
RESET_COLOR=$'%{\e[0;00m%}'

randy=501
root=0
if [ $(id -u) -eq $randy ]; then    # Green if user is randy
   USER_COLOR=$'%{\e[1;32m%}'
elif [ $(id -u) -eq $root ]; then   # Red if user is root
   USER_COLOR=$'%{\e[1;31m%}'
else                                # Yellow if user is anyone else
   USER_COLOR=$'%{\e[1;33m%}'
fi

export PROMPT="$MAIN_COLOR($USER_COLOR%n$MAIN_COLOR|$DIR_COLOR%1~$MAIN_COLOR)$USER_COLOR%#$RESET_COLOR "
export PROMPT2="$MAIN_COLOR... $RESET_COLOR"

### End Prompt ###


### Variables ###

export BROWSER=chrome
#export EDITOR=vim
export EDITOR="/usr/local/bin/mate -w"
export PAGER=less
export LESS="-R -iMx4"

# ensure terminal type is set properly for color-capable terminals
if [[ "$COLORTERM" == "truecolor" ]] || [[ "$COLORTERM" == "Terminal" ]] || [[ "$COLORTERM" == "roxterm" ]]; then
   # make sure $TERM is xterm-256color if the terminal supports 256 colors
   export TERM=xterm-256color
fi

if [ -n "$TMUX" ]; then
   # set $TERM for tmux
   export TERM=screen-256color
fi

### End Variables ###


### Aliases ###
alias h='history'
alias j='jobs'
alias p='pinky'

alias python='python3'

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
rg() {
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

# or use pre_cmd, see man zshcontrib
vcs_info_wrapper() {
  vcs_info
  if [ -n "$vcs_info_msg_0_" ]; then
    echo "%{$fg[grey]%}${vcs_info_msg_0_}%{$reset_color%}$del"
  fi
}
RPROMPT=$'$(vcs_info_wrapper)'

### End Git branch info ###

export PATH=$PATH:$HOME/bin/:$HOME/.gem/ruby/2.2.0/bin

### Source fzf files
#source /usr/share/fzf/key-bindings.zsh
#source /usr/share/fzf/completion.zsh


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/randy/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/randy/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/randy/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/randy/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export PATH="/usr/local/opt/openjdk@8/bin:$PATH"

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"
