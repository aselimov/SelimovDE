#!/bin/bash

# Directory where the script is located
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
SWAP_MODE_SCRIPT="$SCRIPT_DIR/swap_mode.sh"

# Listen for changes in the color-scheme setting
gsettings monitor org.gnome.desktop.interface color-scheme | while read -r line; do
    # 'default' usually corresponds to light mode in GNOME
    if [[ "$line" == *"default"* ]]; then
        echo "Detected light mode change..."
        "$SWAP_MODE_SCRIPT" light
    
    # 'prefer-dark' corresponds to dark mode
    elif [[ "$line" == *"prefer-dark"* ]]; then
        echo "Detected dark mode change..."
        "$SWAP_MODE_SCRIPT" dark
    fi
done
