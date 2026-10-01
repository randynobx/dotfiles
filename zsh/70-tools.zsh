# 70-tools.zsh - optional third-party tool integrations (each skipped if absent)

# navi: Ctrl+g searches cheatsheets and puts the command on the prompt
(( $+commands[navi] )) && eval "$(navi widget zsh)"
