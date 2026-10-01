# ~/.zprofile - login-shell setup; runs once before zshrc (linked by install.sh)

# Homebrew: sets PATH, MANPATH, etc. (Apple Silicon, Intel Mac, or Linuxbrew)
for brew in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
    if [[ -x $brew ]]; then
        eval "$($brew shellenv)"
        break
    fi
done
unset brew

# JetBrains Toolbox launcher scripts (only on machines that have Toolbox)
toolbox="$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
[[ -d $toolbox ]] && path+=("$toolbox")
unset toolbox
