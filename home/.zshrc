# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000
setopt extendedglob notify
unsetopt autocd beep
setopt INC_APPEND_HISTORY    # Write to history file immediately, not when shell exits
setopt SHARE_HISTORY         # Share history between all sessions
setopt HIST_IGNORE_DUPS      # Don't save duplicate commands
setopt HIST_IGNORE_SPACE     # Don't save commands starting with space
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/aselimov/.zshrc'

export LS_COLORS='di=1;37:ln=35:so=32:pi=33:ex=1;32:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'

#~/bin/daily_scripture.sh
autoload -Uz compinit
compinit
# End of lines added by compinstall
#
export OMPI_MCA_rmaps_base_oversubscribe=1
export CLICOLOR=1
export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd

load_env() {
  set -a
  . "$1"
  set +a
}

alias clip2png="xclip -selection clipboard -target image/png -out"

export XKB_DEFAULT_OPTIONS="caps:escape"
export PASSWORD_STORE_CHARACTER_SET='a-zA-Z0-9+\-$!*_='

XDEB_PKGROOT=${HOME}/.config/xdeb

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Add cuda to path
export PATH="$PATH:/usr/local/cuda-12.8/bin"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda-12.8/lib64"

[ -f "/home/aselimov/.ghcup/env" ] && . "/home/aselimov/.ghcup/env" # ghcup-env

if [ $(which pyenv 2>&1 1>/dev/null) ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init - zsh)"
fi

eval "$(starship init zsh)"
zstyle -e ':completion:*:hosts' hosts 'reply=(
  ${=${${(f)"$(cat {/etc/ssh_,~/ar.ssh/known_}hosts(|2)(N) 2>/dev/null)"}%%[#| ]*}//,/ }
  ${=${${${${(@M)${(f)"$(cat ~/.ssh/config 2>/dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
)'

source "$HOME/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOME/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$HOME/.config/zsh/zsh-history-substring-search/zsh-history-substring-search.zsh"

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Settings that need to swap between Mac and Linux
if [ "$(uname)" = "Darwin" ]; then
  export PATH="$PATH:/opt/homebrew/bin"
  alias ls="gls --classify --group-directories-first --color"
  alias gemini="(source ~/.gemini_project  && gemini)"
  export NVIM_JDTLS_JAVA_HOME="/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home/"
  # I only start tmux by default on Mac because of dwm+swallow patch
   if [[ -z "$TMUX" ]] && [[ -n "$PS1" ]]; then
    tmux attach -t dev || tmux new -s dev
  fi 
else
  alias ls="ls --classify --group-directories-first --color"
fi
