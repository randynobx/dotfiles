# dotfiles

Personal shell and terminal configs for macOS and Linux.

The authoritative list is [`links`](links), which `install.sh` and the homelab
Ansible role both read. To add a dotfile, add one line there.

| File | Target |
|---|---|
| `zprofile` | `~/.zprofile` (Homebrew PATH; login shells only) |
| `zshrc`, `zsh/` | `~/.zshrc` (a small loader that sources `zsh/*.zsh` in order) |
| `bashrc` | `~/.bashrc` |
| `vimrc`, `vim/` | `~/.vimrc`, `~/.vim` |
| `tmux.conf` | `~/.tmux.conf` (tmux ≥ 3.2) |
| `gitconfig` | `~/.gitconfig` |
| `gitignore_global` | `~/.config/git/ignore` (ignored in every repo) |
| `ranger/` | `~/.config/ranger` |
| `ghostty/` | `~/.config/ghostty` |

## Bootstrap

On a blank Mac, `bootstrap.sh` installs Homebrew and Bitwarden, generates this machine's
SSH key, clones this repo, runs `install.sh`, sets the hostname and firewall, turns on
commit signing, and installs the Brewfiles. It pauses for the GitHub key and for the App
Store sign-in. Safe to re-run.

```sh
bash <(curl -fsSL https://raw.githubusercontent.com/randynobx/dotfiles/main/bootstrap.sh) [--brew <set>]... [ws-<name>]
```

The base Brewfile is always installed. Each `--brew <set>` adds one more: `--brew dev` on a
lab workstation, `--brew audio` on `ws-mouse`, `--brew dev --brew audio` for both. Pass the
same flags on a re-run; without them only the base set is checked.

## Install

```sh
git clone https://github.com/randynobx/dotfiles.git ~/Projects/dotfiles
~/Projects/dotfiles/install.sh
```

`install.sh --core` links only the shell, vim, tmux and git files and skips
plugins, which is what servers get.

The script symlinks each file listed in `links` into place (backing up anything already there to
`*.bak.<timestamp>`) and clones vim plugins into `vim/pack/`. Re-run it to
update plugins.

## Releases

Lab hosts don't follow `main`. The infra repo's Ansible deploys the `production`
branch, which moves only when promoted:

```sh
make pending     # commits on main not yet in production
make release     # production := origin/main (fast-forward only)
```

`make release REF=<sha>` promotes an earlier pushed commit. To roll back:
`git push --force origin <sha>:production`. Either way, `make run` in infra deploys it.

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

Run `cheat` (or `cheat <word>` to filter) for a list of every alias, git alias
and function with its description, generated from the comments in these files.

Per-machine or private settings go in `~/.zshrc.local`, which is loaded last
and not tracked.

## Homebrew

`Brewfiles/` splits the CLI tools and apps for a new Mac into sets:

| File | Contents | Installed by |
|---|---|---|
| `Brewfile` | base tools and apps, every Mac | `bootstrap.sh`, always |
| `Brewfile.dev` | developer and lab-admin tools | `bootstrap.sh --brew dev` |
| `Brewfile.audio` | live sound and recording | `bootstrap.sh --brew audio` |
| `Brewfile.optional` | catalog of vetted extras | nothing; copy single lines out |

By hand: `brew bundle --file=Brewfiles/Brewfile.dev`. The `mas` lines need the App Store
app signed in, and install only apps the Apple ID already owns.

## Dependencies

[fzf](https://github.com/junegunn/fzf), [ripgrep](https://github.com/BurntSushi/ripgrep),
[ranger](https://github.com/ranger/ranger), tmux. Everything degrades gracefully
if one is missing.
