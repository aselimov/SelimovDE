#!/bin/bash

NVIM_CONF="${HOME}/.config/nvim/init.lua"
GHOSTTY_CONF="${HOME}/.config/ghostty/config"
GEMINI_CONF="${HOME}/repos/SelimovDE/gemini/settings.json"
CLAUDE_CONF="${HOME}/.claude.json"

[ -f "$NVIM_CONF" ] || { echo "Missing $NVIM_CONF"; exit 1; }
[ -f "$GHOSTTY_CONF" ] || { echo "Missing $GHOSTTY_CONF"; exit 1; }
[ -f "$GEMINI_CONF" ] || { echo "Missing $GEMINI_CONF"; exit 1; }
[ -f "$CLAUDE_CONF" ] || { echo "Missing $CLAUDE_CONF"; exit 1; }

set_light_mode() {
    sed -E -i 's/^([[:space:]]*theme[[:space:]]*=[[:space:]]*)zenwritten-dark/\1zenwritten-light/' "$GHOSTTY_CONF"
    sed -E -i 's/(vim.g.light_mode[[:space:]]*=[[:space:]]*).*/\1true/' "$NVIM_CONF"
    sed -i 's/"theme": "Zenwritten Dark"/"theme": "Zenwritten Light"/' "$GEMINI_CONF"
    sed -i 's/"theme": "dark"/"theme": "light"/' "$CLAUDE_CONF"
    sed -i "s/set -g window-style .*/set -g window-style 'bg=#E8E2DF'/" ~/.tmux.conf
    sed -i "s/set -g window-active-style .*/set -g window-active-style 'bg=default'/" ~/.tmux.conf
    MODE="light"
}

set_dark_mode() {
    sed -E -i 's/^([[:space:]]*theme[[:space:]]*=[[:space:]]*)zenwritten-light/\1zenwritten-dark/' "$GHOSTTY_CONF"
    sed -E -i 's/(vim.g.light_mode[[:space:]]*=[[:space:]]*).*/\1false/' "$NVIM_CONF"
    sed -i 's/"theme": "Zenwritten Light"/"theme": "Zenwritten Dark"/' "$GEMINI_CONF"
    sed -i 's/"theme": "light"/"theme": "dark"/' "$CLAUDE_CONF"
    sed -i "s/set -g window-style .*/set -g window-style 'bg=#242424'/" ~/.tmux.conf
    sed -i "s/set -g window-active-style .*/set -g window-active-style 'bg=default'/" ~/.tmux.conf
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


# Reload Ghostty config via signal (no Accessibility permissions required)
kill -SIGUSR2 $(ps aux | grep "[G]hostty.app" | awk '{print $2}')


# Reload tmux config
tmux source-file ~/.tmux.conf

tmux list-clients -F '#{client_tty}' |
while read -r tty; do
    tmux refresh-client -R -t "$tty"
done

echo "Switched to ${MODE} mode"
