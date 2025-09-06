#!/bin/bash
# This script deploys dotfiles by creating symlinks.

# Exit immediately if a command exits with a non-zero status.
set -e

# Get the absolute path of the project root directory.
PROJECT_ROOT=$(pwd)

# Function to deploy all entries (files and directories) from the root of a source directory.
# Arguments:
#   $1: Source directory (e.g., "$PROJECT_ROOT/config")
#   $2: Destination directory (e.g., "$HOME/.config")
#   $3: A friendly name for logging (e.g., "config")
deploy_links() {
    local src_base="$1"
    local dest_base="$2"
    local name="$3"

    echo "--- Deploying $name ---"

    # Ensure the base destination directory exists.
    mkdir -p "$dest_base"

    # Find all files and directories in the source directory (depth 1).
    find "$src_base" -mindepth 1 -maxdepth 1 | while read -r src_path; do
        local entry_name=$(basename "$src_path")
        local dest_link="$dest_base/$entry_name"

        # If a file or symlink already exists at the destination...
        if [ -e "$dest_link" ] || [ -L "$dest_link" ]; then
            # If it's a symlink, remove it.
            if [ -L "$dest_link" ]; then
                echo "Replacing existing symlink: $dest_link"
                rm "$dest_link"
            # If it's a directory or file, back it up.
            else
                echo "Backing up existing entry: $dest_link -> ${dest_link}.bak"
                mv "$dest_link" "${dest_link}.bak"
            fi
        fi

        # Get the absolute path to the source entry for a robust symlink.
        local abs_src_path=$(realpath "$src_path")

        # Create the new symlink.
        echo "Linking: $dest_link -> $abs_src_path"
        ln -s "$abs_src_path" "$dest_link" 
    done
    echo "Done."
    echo
}


# --- Execute Deployments ---
deploy_links "$PROJECT_ROOT/bin"    "$HOME/bin"        "bin"
deploy_links "$PROJECT_ROOT/home"   "$HOME"            "home"
deploy_links "$PROJECT_ROOT/config" "$HOME/.config"    "config"
deploy_links "$PROJECT_ROOT/wallpapers" "$HOME/media/wallpapers"    "wallpapers"

echo "All deployments complete!"
