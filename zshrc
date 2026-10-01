################################################################################
## .zshrc - ZSH configuration (loader)
## author: randynobx <randynobx@gmail.com>
##
## Real config lives in zsh/*.zsh next to this file, loaded in filename order.
## Machine-specific or private settings go in ~/.zshrc.local (not tracked).
################################################################################

# directory of this file, resolving the ~/.zshrc symlink back into the repo
ZSH_CONFIG_DIR=${${(%):-%x}:A:h}/zsh

for f in $ZSH_CONFIG_DIR/*.zsh(N); do source $f; done
unset f

[[ -r ~/.zshrc.local ]] && source ~/.zshrc.local
