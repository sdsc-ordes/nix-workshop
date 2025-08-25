#!/usr/bin/env bash
# shellcheck disable=SC1090,SC1091
set -e
set -u
set -o pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
. "$DIR/common/log.sh"

export PATH="$1"

print_info "Installing Zsh shell ..."

# Config for general all shells
cat <<EOF >~/.zshenv
# Initial file
EOF

# Config for interactive shells
cp "$CONTAINER_SETUP_DIR/shell/.zplugins" ~/.zplugins
cp "$CONTAINER_SETUP_DIR/shell/.zshrc" ~/.zshrc
cp "$CONTAINER_SETUP_DIR/shell/.zshrc-install-plugins.zsh" ~/.zshrc-install-plugins.zsh
chmod +x ~/.zshrc ~/.zshrc-install-plugins.zsh

# Copy p10k config.
cp "$CONTAINER_SETUP_DIR/shell/.p10k.zsh" ~/.p10k.zsh
chmod +x ~/.p10k.zsh

# Install Antidote and install all plugins.
git clone --depth=1 --branch v1.8.6 https://github.com/mattmc3/antidote.git ~/.antidote
zsh -c "source ~/.zshrc-install-plugins.zsh; install_plugins"

# Remove ZSH's internal Git completion which is slow:
dirs=("/usr/share/zsh/5.9/functions/Completion/Unix/_git"
    "/usr/share/zsh/functions/Completion/Unix/_git")
for dir in "${dirs[@]}"; do
    dd=$(dirname "$dir")
    if [ -d "$dir" ]; then
        sudo mv "$dir" "$dd/_disabledgit"
    fi
done

cp "$CONTAINER_SETUP_DIR/shell/.shell-entry-splash.sh" ~/.shell-entry-splash.sh
chmod +x ~/.shell-entry-splash.sh
