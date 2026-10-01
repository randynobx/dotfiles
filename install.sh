#!/usr/bin/env bash
# install.sh - symlink dotfiles into $HOME and fetch vim plugins.
# Safe to re-run. Existing real files are moved aside to *.bak.<timestamp>.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d%H%M%S)"

link() {
    local src="$DOTFILES/$1" dst="$2"
    mkdir -p "$(dirname "$dst")"
    if [[ -L "$dst" ]]; then
        [[ "$(readlink "$dst")" == "$src" ]] && { echo "ok      $dst"; return; }
        rm "$dst"
    elif [[ -e "$dst" ]]; then
        mv "$dst" "$dst.bak.$STAMP"
        echo "backup  $dst -> $dst.bak.$STAMP"
    fi
    ln -s "$src" "$dst"
    echo "linked  $dst -> $src"
}

link zshrc     "$HOME/.zshrc"
link zprofile  "$HOME/.zprofile"
link bashrc    "$HOME/.bashrc"
link vimrc     "$HOME/.vimrc"
link vim       "$HOME/.vim"
link tmux.conf "$HOME/.tmux.conf"
link gitconfig "$HOME/.gitconfig"
link gitignore_global "${XDG_CONFIG_HOME:-$HOME/.config}/git/ignore"
link ranger    "${XDG_CONFIG_HOME:-$HOME/.config}/ranger"
link ghostty   "${XDG_CONFIG_HOME:-$HOME/.config}/ghostty"

# vim plugins (native packages, gitignored)
plug() {
    local repo="$1" dir="$DOTFILES/vim/pack/vendor/start/${1##*/}"
    if [[ -d "$dir/.git" ]]; then
        git -C "$dir" pull --ff-only --quiet && echo "updated $repo"
    else
        git clone --depth 1 --quiet "https://github.com/$repo" "$dir" && echo "cloned  $repo"
    fi
}
plug junegunn/fzf.vim

# reminders for tools the configs expect
for cmd in fzf rg ranger tmux; do
    command -v "$cmd" >/dev/null || echo "note: '$cmd' not found - install it for full functionality"
done
