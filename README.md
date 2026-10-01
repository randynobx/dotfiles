# dotfiles

Personal shell and terminal configs for macOS and Linux.

| File | Target |
|---|---|
| `zshrc`, `zsh/` | `~/.zshrc` (a small loader that sources `zsh/*.zsh` in order) |
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

## zsh layout

`zshrc` only loads `zsh/*.zsh` in filename order:

| File | Contents |
|---|---|
| `10-options.zsh` | shell options, vi mode, history |
| `20-env.zsh` | PATH, EDITOR, PAGER and other variables |
| `30-completion.zsh` | completion system, fzf |
| `40-prompt.zsh` | prompt and git status |
| `50-aliases.zsh` | aliases (incl. git shortcuts) |
| `60-functions.zsh` | shell functions |
| `70-tools.zsh` | optional tool integrations (navi), each skipped if not installed |

Per-machine or private settings go in `~/.zshrc.local`, which is loaded last
and not tracked.

## Dependencies

[fzf](https://github.com/junegunn/fzf), [ripgrep](https://github.com/BurntSushi/ripgrep),
[ranger](https://github.com/ranger/ranger), tmux. Everything degrades gracefully
if one is missing.
