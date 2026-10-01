#!/usr/bin/env bash
# install.sh - symlink dotfiles into $HOME and fetch vim plugins.
# Safe to re-run. Existing real files are moved aside to *.bak.<timestamp>.
# What gets linked where is listed in ./links (shared with the homelab Ansible role).
#
# usage: install.sh          link everything, fetch vim plugins
#        install.sh --core   link only "core" entries, no plugins (server-style)
set -euo pipefail

CORE_ONLY=false
case "${1:-}" in
    --core) CORE_ONLY=true ;;
    "") ;;
    *) echo "usage: $0 [--core]" >&2; exit 2 ;;
esac

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

while read -r src dst profile; do
    [[ -z $src || $src == \#* ]] && continue
    $CORE_ONLY && [[ $profile != core ]] && continue
    link "$src" "$HOME/$dst"
done < "$DOTFILES/links"

$CORE_ONLY && exit 0

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
