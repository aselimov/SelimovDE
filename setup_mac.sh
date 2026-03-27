#!/bin/bash
# Full macOS setup script.
# Deploys dotfiles, sets up neovim config, and installs brew applications.

set -e

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# --- SSH keygen ---
SSH_KEY="$HOME/.ssh/id_ed25519"
echo "=== Setting up SSH key ==="
if [ -f "$SSH_KEY" ]; then
    echo "SSH key already exists at $SSH_KEY, skipping."
else
    read -rp "Enter email for SSH key: " ssh_email
    ssh-keygen -t ed25519 -C "$ssh_email" -f "$SSH_KEY"
    eval "$(ssh-agent -s)"
    ssh-add "$SSH_KEY"
    echo "Public key:"
    cat "${SSH_KEY}.pub"
fi
echo

# --- Deploy dotfiles ---
echo "=== Deploying dotfiles ==="
"$SCRIPT_DIR/deploy.sh"

# --- Neovim config ---
NVIM_CONFIG="$HOME/.config/nvim"
NVIM_REPO="https://forge.alexselimov.com/aselimov/neovim.git"

echo "=== Setting up neovim config ==="
if [ -d "$NVIM_CONFIG" ]; then
    if [ -L "$NVIM_CONFIG" ]; then
        echo "Removing existing symlink at $NVIM_CONFIG"
        rm "$NVIM_CONFIG"
    elif [ -d "$NVIM_CONFIG/.git" ]; then
        echo "Neovim config already cloned at $NVIM_CONFIG, pulling latest..."
        git -C "$NVIM_CONFIG" pull
        echo "Done."
        echo
    else
        echo "Backing up existing $NVIM_CONFIG -> ${NVIM_CONFIG}.bak"
        mv "$NVIM_CONFIG" "${NVIM_CONFIG}.bak"
    fi
fi

if [ ! -d "$NVIM_CONFIG/.git" ]; then
    echo "Cloning neovim config..."
    git clone "$NVIM_REPO" "$NVIM_CONFIG"
    echo "Done."
    echo
fi

# --- Homebrew ---
echo "=== Checking for Homebrew ==="
if ! command -v brew &>/dev/null; then
    echo "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "=== Installing brew formulae ==="
brew install neovim
brew install coreutils
brew install gnu-sed
brew install starship
brew install nvm
brew install kubectl

echo "=== Installing brew casks ==="
brew install --cask anytype
brew install --cask ghostty
brew install --cask helium
brew install --cask flowvision

echo
echo "macOS setup complete!"
