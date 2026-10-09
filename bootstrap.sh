#!/usr/bin/env bash
# bootstrap.sh - take a blank Mac as far as Homebrew, an SSH key, dotfiles and commit signing.
# Safe to re-run: every step checks first and prints "ok" when there is nothing to do.
# Steps and order come from infra's docs/runbooks/workstation-setup.md.
#
# usage: bash <(curl -fsSL https://raw.githubusercontent.com/randynobx/dotfiles/main/bootstrap.sh) [--brew <set>]... [ws-<name>]
#   --brew <set>   also install Brewfiles/Brewfile.<set> (dev, audio); repeat for more than one.
#                  Brewfiles/Brewfile is always installed.
# Runs under macOS's /bin/bash 3.2, and not from a clone: nothing here may rely on
# BASH_SOURCE or on bash 4 features.
set -euo pipefail

die() { echo "error: $*" >&2; exit 1; }

usage() { die "usage: bootstrap.sh [--brew <set>]... [ws-<name>]"; }

NAME=""
BREWFILES=(Brewfile)
set_re='^[a-z0-9]+$'
while [[ $# -gt 0 ]]; do
    case "$1" in
        --brew)
            [[ $# -ge 2 ]] || usage
            [[ $2 =~ $set_re ]] || die "bad Brewfile set '$2'"
            [[ $2 != optional ]] || die "Brewfile.optional is a catalog, not a set"
            [[ " ${BREWFILES[*]} " == *" Brewfile.$2 "* ]] || BREWFILES+=("Brewfile.$2")
            shift 2
            ;;
        -*) usage ;;
        *)
            [[ -z $NAME ]] || usage
            NAME="$1"
            shift
            ;;
    esac
done
[[ "$(uname -s)" == Darwin ]] || die "macOS only"
[[ "$(id -u)" -ne 0 ]] || die "run as yourself, not root (Homebrew refuses root)"

DOTFILES="$HOME/Projects/dotfiles"
KEY="$HOME/.ssh/id_ed25519"
FIREWALL=/usr/libexec/ApplicationFirewall/socketfilterfw

# HostName is unset on a blank Mac, and scutil then exits non-zero.
name_of() { scutil --get "$1" 2>/dev/null || true; }

# Asked for now, set later: the key comment needs the name before the hostname step runs.
if [[ -z $NAME ]]; then
    NAME="$(name_of LocalHostName)"
    if [[ $NAME != ws-* || "$(name_of ComputerName)" != "$NAME" || "$(name_of HostName)" != "$NAME" ]]; then
        read -r -p "hostname (ws-<name>): " NAME
    fi
fi
name_re='^ws-[a-z0-9]+(-[a-z0-9]+)*$'
[[ $NAME =~ $name_re ]] || die "hostname must be ws-<name>, got '$NAME'"

# 1. Xcode Command Line Tools: Homebrew's installer installs them and waits, so no
#    xcode-select --install here (it returns before the install finishes).
if xcode-select -p >/dev/null 2>&1; then
    echo "ok      command line tools"
else
    echo "note    command line tools missing - Homebrew's installer adds them"
fi

# 2. Homebrew: /opt/homebrew on Apple Silicon, /usr/local on Intel
brew_bin() {
    local prefix
    for prefix in /opt/homebrew /usr/local; do
        if [[ -x $prefix/bin/brew ]]; then
            echo "$prefix/bin/brew"
            return
        fi
    done
}
BREW="$(brew_bin)"
if [[ -n $BREW ]]; then
    echo "ok      homebrew"
else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    BREW="$(brew_bin)"
    [[ -n $BREW ]] || die "brew not found after the Homebrew installer ran"
    echo "installed homebrew"
fi
eval "$("$BREW" shellenv)"
xcode-select -p >/dev/null 2>&1 || die "command line tools still missing: run xcode-select --install, then re-run"

# 3. Bitwarden, ahead of the Brewfile: the pause below needs it
if brew list --cask bitwarden >/dev/null 2>&1 || [[ -d /Applications/Bitwarden.app ]]; then
    echo "ok      bitwarden"
else
    brew install --cask bitwarden
fi

# 4. SSH key: one per machine, never regenerated. ssh-keygen prompts for the passphrase.
if [[ -f $KEY ]]; then
    echo "ok      $KEY"
else
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
    ssh-keygen -t ed25519 -C "randy@$NAME" -f "$KEY"
fi
fingerprint="$(ssh-keygen -lf "$KEY.pub" | awk '{print $2}')"
# /usr/bin: --apple-use-keychain exists only in Apple's ssh-add.
loaded="$(/usr/bin/ssh-add -l 2>/dev/null || true)"
if [[ $loaded == *"$fingerprint"* ]]; then
    echo "ok      ssh-agent"
else
    /usr/bin/ssh-add --apple-use-keychain "$KEY"
fi

# 5. Pause until GitHub accepts the key. ssh -T exits 1 even on success.
github_ok() {
    local out
    out="$(ssh -T git@github.com 2>&1 || true)"
    [[ $out == *"successfully authenticated"* ]]
}
if github_ok; then
    echo "ok      github accepts this key"
else
    cat <<EOF

Now, by hand:
  1. Open Bitwarden and sign in.
  2. GitHub -> Settings -> SSH and GPG keys: add the key below twice,
     once as an Authentication key and once as a Signing key.

$(cat "$KEY.pub")

EOF
    while :; do
        read -r -p "Press Enter when both are added: " _
        github_ok && break
        echo "GitHub has not accepted the key yet (ssh -T git@github.com)"
    done
    echo "ok      github accepts this key"
fi

# 6. Clone dotfiles
if [[ -d $DOTFILES/.git ]]; then
    echo "ok      $DOTFILES"
else
    mkdir -p "$HOME/Projects"
    git clone git@github.com:randynobx/dotfiles.git "$DOTFILES"
fi

# An existing clone is not pulled, so it may predate Brewfiles/ or the set asked for.
for f in "${BREWFILES[@]}"; do
    [[ -f $DOTFILES/Brewfiles/$f ]] ||
        die "no Brewfiles/$f in $DOTFILES: check the set name, or git -C $DOTFILES pull"
done

# 7. Link them (prints its own ok lines)
"$DOTFILES/install.sh"

# 8. Hostname and firewall
if [[ "$(name_of ComputerName)" == "$NAME" && "$(name_of HostName)" == "$NAME" && "$(name_of LocalHostName)" == "$NAME" ]]; then
    echo "ok      hostname $NAME"
else
    for key in ComputerName HostName LocalHostName; do
        sudo scutil --set "$key" "$NAME"
    done
    echo "set     hostname $NAME"
fi
firewall="$("$FIREWALL" --getglobalstate 2>/dev/null || true)"
if [[ $firewall == *enabled* ]]; then
    echo "ok      firewall"
else
    sudo "$FIREWALL" --setglobalstate on
fi

# 9. Commit signing with this machine's key, and the default commit email. After install.sh:
#    it links the gitconfig that includes ~/.gitconfig.local. The email is asked for here
#    because it is kept out of this repo.
if [[ -e $HOME/.gitconfig.local ]]; then
    echo "ok      ~/.gitconfig.local"
else
    cat > "$HOME/.gitconfig.local" <<'EOF'
[user]
    signingkey = ~/.ssh/id_ed25519.pub
[gpg]
    format = ssh
[gpg "ssh"]
    allowedSignersFile = ~/.ssh/allowed_signers
[commit]
    gpgsign = true
[tag]
    gpgsign = true
EOF
    echo "wrote   ~/.gitconfig.local"
fi
email="$(git config -f "$HOME/.gitconfig.local" user.email || true)"
if [[ -n $email ]]; then
    echo "ok      git email $email"
else
    read -r -p "default git commit email (github.com repos use the noreply address): " email
    [[ -n $email ]] || die "no email given"
    git config -f "$HOME/.gitconfig.local" user.email "$email"
    echo "set     git email $email"
fi
signer="$email namespaces=\"git\" $(cat "$KEY.pub")"
if [[ -f $HOME/.ssh/allowed_signers ]] && grep -qxF "$signer" "$HOME/.ssh/allowed_signers"; then
    echo "ok      ~/.ssh/allowed_signers"
else
    echo "$signer" >> "$HOME/.ssh/allowed_signers"
    echo "added   this key to ~/.ssh/allowed_signers"
fi

# 10. Brewfiles, last: a failed app install must not block the steps above.
failed=""
for f in "${BREWFILES[@]}"; do
    if brew bundle check --file="$DOTFILES/Brewfiles/$f" >/dev/null 2>&1; then
        echo "ok      $f"
        continue
    fi
    # mas cannot sign in, and installs only apps this Apple ID already owns.
    if grep -q '^mas ' "$DOTFILES/Brewfiles/$f"; then
        read -r -p "$f has App Store apps. Sign in to the App Store app, then press Enter: " _
    fi
    brew bundle --file="$DOTFILES/Brewfiles/$f" || failed="$failed $f"
done

# 11. What is left needs a human
cat <<'EOF'

Done. Still by hand, from infra's docs/runbooks/workstation-setup.md:
  Phase 1  software updates, FileVault (recovery key into Bitwarden)
  Phase 2  Bitwarden: Touch ID unlock, browser extensions
  Phase 3  restore ~/.zshrc.local, open a new shell, app sign-ins
  Phase 6  a test commit shows Verified on GitHub
Lab admin only: Phase 2 step 4 (authorise the key on the lab), then Phases 4 and 5.
EOF
[[ -z $failed ]] || die "brew bundle failed for:$failed - fix and re-run"
