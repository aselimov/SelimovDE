#!/bin/bash

NVIM_CONF="${HOME}/.config/nvim/init.lua"
GHOSTTY_CONF="${HOME}/.config/ghostty/config"

[ -f "$NVIM_CONF" ] || { echo "Missing $NVIM_CONF"; exit 1; }
[ -f "$GHOSTTY_CONF" ] || { echo "Missing $GHOSTTY_CONF"; exit 1; }

set_light_mode() {
    sed -E -i '' 's/^([[:space:]]*theme[[:space:]]*=[[:space:]]*)zenwritten-dark/\1zenwritten-light/' "$GHOSTTY_CONF"
    sed -E -i '' 's/(vim.g.light_mode[[:space:]]*=[[:space:]]*).*/\1true/' "$NVIM_CONF"
    MODE="light"
}

set_dark_mode() {
    sed -E -i '' 's/^([[:space:]]*theme[[:space:]]*=[[:space:]]*)zenwritten-light/\1zenwritten-dark/' "$GHOSTTY_CONF"
    sed -E -i '' 's/(vim.g.light_mode[[:space:]]*=[[:space:]]*).*/\1false/' "$NVIM_CONF"
    MODE="dark"
}

toggle_mode() {
    if grep -Eq '^\s*theme\s*=\s*zenwritten-light' "$GHOSTTY_CONF"; then
        set_dark_mode
    else
        set_light_mode
    fi
}

case "$1" in
    light)
        set_light_mode
        ;;
    dark)
        set_dark_mode
        ;;
    toggle|*)
        toggle_mode
        ;;
esac

# Reload neovim theme
if [ "$MODE" = "light" ]; then
    keys=$'<C-\\><C-n>:silent! let g:light_mode=1 | set background=light |  doautocmd ColorScheme | redraw!<CR>'
else
    keys=$'<C-\\><C-n>:silent! let g:light_mode=0 | set background=dark  |  doautocmd ColorScheme | redraw!<CR>'
fi
for dir in "${XDG_RUNTIME_DIR:-}" "${TMPDIR:-/tmp}" "/tmp" "$HOME/.local/state/nvim"; do
    [ -d "$dir" ] || continue
    find "$dir" -type s -name 'nvim*' 2>/dev/null | while read -r sock; do
        timeout 1s nvim --server "$sock" --remote-send "$keys" >/dev/null 2>&1 || true
    done
done


# Reload Ghostty: send SIGUSR2 to running ghostty processes (macOS/Linux)
pkill -USR2 -x ghostty 2>/dev/null

echo "Switched to ${MODE} mode"

# Script for changing between light and dark modes on Linux
if [ "$(uname)" != "Darwin" ]; then
    if [ "$MODE" == "dark" ]; then
        echo "Swapping to dark mode"
        # GTK Theme
        gsettings set org.gnome.desktop.interface gtk-theme ''
        gsettings set org.gnome.desktop.interface gtk-theme 'WhiteSur-Dark'
        # Rofi theme
        sed -i -e "s/light.rasi/dark.rasi/" $HOME/.config/rofi/config.rasi

    else
        echo "Swapping to light mode"
        # GTK Theme
        gsettings set org.gnome.desktop.interface gtk-theme ''
        gsettings set org.gnome.desktop.interface gtk-theme 'WhiteSur-Light'
        # Rofi theme
        sed -i -e "s/dark.rasi/light.rasi/" $HOME/.config/rofi/config.rasi

    fi

    killall -HUP xsettingsd
fi
