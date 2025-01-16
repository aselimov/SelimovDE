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

~/bin/daily_scripture.sh
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
  ${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) 2>/dev/null)"}%%[#| ]*}//,/ }
  ${=${${${${(@M)${(f)"$(cat ~/.ssh/config 2>/dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
)'

source "/home/aselimov/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "/home/aselimov/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "/home/aselimov/.config/zsh/zsh-history-substring-search/zsh-history-substring-search.zsh"

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
export XKB_DEFAULT_OPTIONS="caps:escape"



function panbeamer (){
  pandoc --pdf-engine=xelatex -o "${1/md/pdf}" -t beamer "$1"
}

export panbeamer

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -f "/home/aselimov/.ghcup/env" ] && . "/home/aselimov/.ghcup/env" # ghcup-env
