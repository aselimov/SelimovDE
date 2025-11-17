#==============================================================================
# Zsh Configuration
#==============================================================================
# History settings
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000
setopt extendedglob notify
unsetopt autocd beep
setopt INC_APPEND_HISTORY    # Write to history file immediately, not when shell exits
setopt APPEND_HISTORY        # Append instead of overwriting the file
setopt HIST_IGNORE_DUPS      # Don't save duplicate commands
setopt HIST_IGNORE_SPACE     # Don't save commands starting with space

#==============================================================================
# Environment Variables
#==============================================================================

source ~/.profile

export OMPI_MCA_rmaps_base_oversubscribe=1
export CLICOLOR=1
export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd
export LS_COLORS='di=1;37:ln=35:so=32:pi=33:ex=1;32:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
export XKB_DEFAULT_OPTIONS="caps:escape"
export PASSWORD_STORE_CHARACTER_SET='a-zA-Z0-9+\-$!*_='
export XDEB_PKGROOT=${HOME}/.config/xdeb
export EDITOR=nvim
export TERMINAL=ghostty

# Custom path additions
source ~/.profile

#==============================================================================
# Aliases
#==============================================================================

alias clip2png="xclip -selection clipboard -target image/png -out"
alias k="kubectl"

ssh() {
    NO_TMUX=1 nohup ghostty --command="ssh $*" >/dev/null 2>&1 &
}

#==============================================================================
# Functions
#==============================================================================

load_env() {
  set -a
  . "./$1"
  set +a
}

#==============================================================================
# Completions
#==============================================================================

autoload -Uz compinit
compinit
zstyle ':compinstall' filename '/home/aselimov/.zshrc'
zstyle -e ':completion:*:hosts' hosts 'reply=(
  ${=${${(f)"$(cat {/etc/ssh_,~/ar.ssh/known_}hosts(|2)(N) 2>/dev/null)"}%%[#| ]*}//,/ }
  ${=${${${${(@M)${(f)"$(cat ~/.ssh/config 2>/dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
)'

#==============================================================================
# Plugins & Tools
#==============================================================================

# nvm
# Lazy-load nvm - only initialize when first used
export NVM_DIR="$HOME/.nvm"

# Function to load nvm (called only once)
load_nvm() {
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}

# Create placeholder functions that load nvm once, then call the real command
nvm() {
    unset -f nvm node npm gemini
    load_nvm
    nvm "$@"
}

node() {
    unset -f nvm node npm gemini
    load_nvm
    node "$@"
}

npm() {
    unset -f nvm node npm gemini
    load_nvm
    npm "$@"
}

gemini() {
  unset -f nvm node npm gemini
  load_nvm
  gemini "$@"
}

claude() {
  unset -f claude
  export ANTHROPIC_BASE_URL=https://api.z.ai/api/anthropic
  export ANTHROPIC_AUTH_TOKEN="$(pass list zai_token)"
  npm 2>&1 1>/dev/null
  claude "$@"
}

codex() {
  unset -f codex
  npm 2>&1 1>/dev/null
  codex "$@"
}
# ghcup
[ -f "/home/aselimov/.ghcup/env" ] && . "/home/aselimov/.ghcup/env" # ghcup-env

# pyenv
if command -v pyenv >/dev/null 2>&1; then
  export PYENV_ROOT="$HOME/.pyenv"
  [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init - zsh)"
fi

# jenv
if command -v jenv >/dev/null 2>&1; then
  export PATH="$HOME/.jenv/bin:$PATH"
  eval "$(jenv init -)"
fi

# starship
eval "$(starship init zsh)"

# zsh-autosuggestions
source "$HOME/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"

# zsh-syntax-highlighting
source "$HOME/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# zsh-history-substring-search
source "$HOME/.config/zsh/zsh-history-substring-search/zsh-history-substring-search.zsh"

#==============================================================================
# Keybindings
#==============================================================================

bindkey -v
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

#==============================================================================
# OS-Specific Configuration
#==============================================================================

if [ "$(uname)" = "Darwin" ]; then
  export PATH="/opt/homebrew/bin:$PATH"
  alias ls="gls --classify --group-directories-first --color"
  GEMINI_BIN=$(which gemini)
  function gemini(){
    source ~/.gemini_project && $GEMINI_BIN "$@"
  }
  export NVIM_JDTLS_JAVA_HOME="/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home/"
  # I only start tmux by default on Mac because of dwm+swallow patch
else
  alias ls="ls --classify --group-directories-first --color"
fi

if [[ -z "$TMUX" ]] && [[ -n "$PS1" ]] && [[ -z "$NO_TMUX" ]]; then
 tmux attach -t dev || tmux new -s dev
fi

# pnpm
export PNPM_HOME="/home/aselimov/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
