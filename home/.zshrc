# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt extendedglob notify
unsetopt autocd beep
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/aselimov/.zshrc'

export LS_COLORS='di=1;37:ln=35:so=32:pi=33:ex=1;32:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
alias ls="ls --classify --group-directories-first --color"

#~/bin/daily_scripture.sh
autoload -Uz compinit
compinit
# End of lines added by compinstall
#
export OMPI_MCA_rmaps_base_oversubscribe=1
export CLICOLOR=1
export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd
alias vi="nvim"
alias vim="nvim"
alias mergepdf="gs -dBATCH -dNOPAUSE -dQUIET -sDEVICE=pdfwrite -sOutputFile=output.pdf"
alias ddg="w3m ddg.gg"
alias cal="khal calendar"
#alias sxiv="sxiv-rifle"
function addbin(){
    ln -s $PWD/$1 /home/aselimov/bin
}
eval "$(starship init zsh)"
zstyle -e ':completion:*:hosts' hosts 'reply=(
  ${=${${(f)"$(cat {/etc/ssh_,~/ar.ssh/known_}hosts(|2)(N) 2>/dev/null)"}%%[#| ]*}//,/ }
  ${=${${${${(@M)${(f)"$(cat ~/.ssh/config 2>/dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
)'

source "/home/aselimov/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "/home/aselimov/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "/home/aselimov/.config/zsh/zsh-history-substring-search/zsh-history-substring-search.zsh"

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
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

if [ -z "$TMUX" ]; then 
  tmux
fi
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"
