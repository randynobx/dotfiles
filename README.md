# dotfiles

Personal shell and terminal configs for macOS and Linux.

| File | Target |
|---|---|
| `zshrc` | `~/.zshrc` |
| `bashrc` | `~/.bashrc` |
| `vimrc`, `vim/` | `~/.vimrc`, `~/.vim` |
| `tmux.conf` | `~/.tmux.conf` (tmux ≥ 3.2) |
| `gitconfig` | `~/.gitconfig` |
| `ranger/` | `~/.config/ranger` |
| `ghostty/` | `~/.config/ghostty` |

## Install

```sh
git clone https://github.com/randynobx/dotfiles.git ~/GitHub/dotfiles
~/GitHub/dotfiles/install.sh
```

The script symlinks each file into place (backing up anything already there to
`*.bak.<timestamp>`) and clones vim plugins into `vim/pack/`. Re-run it to
update plugins.

## Dependencies

[fzf](https://github.com/junegunn/fzf), [ripgrep](https://github.com/BurntSushi/ripgrep),
[ranger](https://github.com/ranger/ranger), tmux, [git-lfs](https://git-lfs.com). Everything degrades gracefully
if one is missing.
