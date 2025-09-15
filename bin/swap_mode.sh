#!/bin/bash

NVIM_CONF="${HOME}/.config/nvim/init.lua"
GHOSTTY_CONF="${HOME}/.config/ghostty/config"

[ -f "$NVIM_CONF" ] || { echo "Missing $NVIM_CONF"; exit 1; }
[ -f "$GHOSTTY_CONF" ] || { echo "Missing $GHOSTTY_CONF"; exit 1; }

# Toggle Ghostty theme between zenwritten-dark and zenwritten-light
sed -E -i '' \
    -e 's/^([[:space:]]*theme[[:space:]]*=[[:space:]]*)zenwritten-dark/\1zenwritten-light/' \
    -e 't' \
    -e 's/^([[:space:]]*theme[[:space:]]*=[[:space:]]*)zenwritten-light/\1zenwritten-dark/' \
    "$GHOSTTY_CONF"

# Toggle Neovim vim.g.light_mode true/false
sed -E -i '' \
    -e 's/(vim\.g\.light_mode[[:space:]]*=[[:space:]]*)true/\1false/' \
    -e 't' \
    -e 's/(vim\.g\.light_mode[[:space:]]*=[[:space:]]*)false/\1true/' \
    "$NVIM_CONF"

# Determine new mode from Ghostty theme
if grep -Eq '^\s*theme\s*=\s*zenwritten-light' "$GHOSTTY_CONF"; then
    MODE="light"
else
    MODE="dark"
fi

# Reload neovim theme
if [ "$MODE" = "light" ]; then
    keys=$'<C-\\><C-n>:silent! let g:light_mode=1 | set background=light |  doautocmd ColorScheme | redraw!<CR>'
else
    keys=$'<C-\\><C-n>:silent! let g:light_mode=0 | set background=dark  |  doautocmd ColorScheme | redraw!<CR>'
fi
for dir in "${XDG_RUNTIME_DIR:-}" "${TMPDIR:-/tmp}" "/tmp" "$HOME/.local/state/nvim"; do
    [ -d "$dir" ] || continue
    find "$dir" -type s -name 'nvim*' 2>/dev/null | while read -r sock; do
        if command -v timeout >/dev/null 2>&1; then
            timeout 1s nvim --server "$sock" --remote-send "$keys" >/dev/null 2>&1 || true
        else
            ( nvim --server "$sock" --remote-send "$keys" >/dev/null 2>&1 & )
        fi
    done
done


# Reload Ghostty: send SIGUSR2 to running ghostty processes (macOS/Linux)
if command -v pkill >/dev/null 2>&1; then
    pkill -USR2 -x ghostty 2>/dev/null || true
elif command -v killall >/dev/null 2>&1; then
    killall -USR2 ghostty 2>/dev/null || true
else
    pids=$(pgrep -x ghostty 2>/dev/null || true)
    [ -n "${pids:-}" ] && kill -USR2 $pids || true
fi

echo "Switched to ${MODE} mode"

# Script for changing between light and dark modes on Linux
if [ "$(uname)" != "Darwin" ]; then
    if [ "$MODE" == "dark" ]; then
        echo "Swapping to dark mode"
        # GTK Theme
        sed -i -e 's@Net/ThemeName.*@Net/ThemeName "Orchis-Grey-Dark"@' ~/.xsettingsd
        # Rofi theme
        sed -i -e "s/light.rasi/dark.rasi/" $HOME/.config/rofi/config.rasi

        # Swap ST colors and reset
        echo " st*color0:#191919
     st*color1:#DE6E7C
     st*color2:#819B69
     st*color3:#B77E64
     st*color4:#6099C0
     st*color5:#B279A7
     st*color6:#66A5AD
     st*color7:#BBBBBB
     st*color8:#3d3839
     st*color9:#E8838F
     st*color10:#8BAE68
     st*color11:#D68C67
     st*color12:#61ABDA
     st*color13:#CF86C1
     st*color14:#65B8C1
     st*color15:#8e8e8e
        " > ~/.Xresources
        xrdb merge ~/.Xresources
        killall st -s "USR1"

    else
        echo "Swapping to light mode"
        # GTK Theme
        sed -i -e 's@Net/ThemeName.*@Net/ThemeName "Orchis-Grey-Light"@' ~/.xsettingsd
        # Rofi theme
        sed -i -e "s/dark.rasi/light.rasi/" $HOME/.config/rofi/config.rasi

        #    # Update ST colors
        echo " st*color0:#F0EDEC
     st*color1:#A8334C
     st*color2:#4F6C31
     st*color3:#944927
     st*color4:#286486
     st*color5:#88507D
     st*color6:#3B8992
     st*color7:#2C363C
     st*color8:#CFC1BA
     st*color9:#94253E
     st*color10:#3F5A22
     st*color11:#803D1C
     st*color12:#1D5573
     st*color13:#7B3B70
     st*color14:#2B747C
     st*color15:#4F5E68
        " > ~/.Xresources
        xrdb merge ~/.Xresources
        killall st -s "USR1"
    fi

    killall -HUP xsettingsd
fi
