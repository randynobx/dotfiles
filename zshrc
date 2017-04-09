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
    eval `dircolors -b`
    alias ls='ls --color=auto -F'
    alias dir='ls --color=auto -F'

    # grep color
    export GREP_COLOR="1;33"
    alias grep='grep --color=auto'
fi

# Zenburn colors for console
 if [ "$TERM" = "linux" ]; then
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


### Window title ###

# user@host:dir
case "$TERM" in
    xterm*|rxvt*)
    precmd () {print -Pn "\e]0;%n@%m: %~\a"}
        ;;
esac

### End Window title ###

### Prompt ###

MAIN_COLOR=$'%{\e[1;30m%}'
#USER_COLOR=$'%{\e[1;32m%}' ## This line is not necessary as USER_COLOR will be set below depending on current user
HOST_COLOR=$'%{\e[1;36m%}'
DIR_COLOR=$'%{\e[0;37m%}'
RESET_COLOR=$'%{\e[0;00m%}'

randy=1000
root=0
if [ $(id -u) -eq $randy ]; then    # Green if user is randy
   USER_COLOR=$'%{\e[1;32m%}'
elif [ $(id -u) -eq $root ]; then   # Red if user is root
   USER_COLOR=$'%{\e[1;31m%}'
else                                # Yellow if user is anyone else
   USER_COLOR=$'%{\e[1;33m%}'
fi

export PROMPT="$MAIN_COLOR($RESET_COLOR%!:$USER_COLOR%n$RESET_COLOR@$HOST_COLOR%m$MAIN_COLOR|$DIR_COLOR%~$MAIN_COLOR)$USER_COLOR%#$RESET_COLOR "
export PROMPT2="$MAIN_COLOR... $RESET_COLOR"

### End Prompt ###


### Variables ###

export BROWSER=firefox
export EDITOR=vim
export PAGER=less
export LESS="-R -iMx4"

# ensure terminal type is set properly for color-capable terminals
if [[ "$COLORTERM" == "gnome-terminal" ]] || [[ "$COLORTERM" == "Terminal" ]] || [[ "$COLORTERM" == "roxterm" ]]; then
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

alias ll='ls -lh'
alias la='ls -Ah'
alias lla='ls -lAh'
alias privatize='chmod go-rwx'

alias tasks='clear;task long;task summary'
alias pdf='mupdf %s & disown'

alias strtx='startx&disown;vlock'

## Arch Linux pacman aliases
alias pacman='pacaur --color auto'
alias pacs='pacaur -s'
alias pacq='pacaur -Qi'
alias paci='pacaur -S'
alias pacu='pacaur -Syu'

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

### End Functions ###

### Git branch info ###

setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:*' actionformats \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats       \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f '
#zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'

zstyle ':vcs_info:*' enable git #cvs svn

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
