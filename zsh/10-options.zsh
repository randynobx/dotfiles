# 10-options.zsh - shell options, keybinding mode, history

# allow comments in interactive shells
setopt interactive_comments

# vi keybindings (must come before anything that binds keys, e.g. fzf)
bindkey -v

### History ###

HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

setopt inc_append_history    # write each command as it runs; new shells see it
setopt hist_ignore_all_dups  # keep only the most recent copy of a command
setopt hist_ignore_space     # " cmd" (leading space) is never saved

# only archive commands with arguments; bare commands (ls, clear, htop...)
# stay usable with ↑ this session but aren't written to the history file
zshaddhistory() {
    [[ ${1%%$'\n'} == *' '* ]] || return 2
}
