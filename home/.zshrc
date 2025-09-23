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
setopt SHARE_HISTORY         # Share history between all sessions
setopt HIST_IGNORE_DUPS      # Don't save duplicate commands
setopt HIST_IGNORE_SPACE     # Don't save commands starting with space

#==============================================================================
# Environment Variables
#==============================================================================

export OMPI_MCA_rmaps_base_oversubscribe=1
export CLICOLOR=1
export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd
export LS_COLORS='di=1;37:ln=35:so=32:pi=33:ex=1;32:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
export XKB_DEFAULT_OPTIONS="caps:escape"
export PASSWORD_STORE_CHARACTER_SET='a-zA-Z0-9+\-$!*_='
export XDEB_PKGROOT=${HOME}/.config/xdeb

# Custom path additions
source ~/.profile

#==============================================================================
# Aliases
#==============================================================================

alias clip2png="xclip -selection clipboard -target image/png -out"

#==============================================================================
# Gemini Agents
#==============================================================================

function gemini-planner(){
  if  $(echo "$1" | grep "engjira.int.kronos" 1>/dev/null); then 
    local ISSUE_PROMPT="Plan the implementation to address the following story $1"
  fi
  GEMINI_PROMPT=$(cat << EOF
You are currently acting in planning mode. Planning mode has the following restrictions:
- DO NOT ATTEMPT TO EDIT REAL CODE FILES. 
- Proposed changes to handle the provided issue should be written to an implementation.md file at the project root
- Before deciding on an implementation strategy, offer 2-3 alternative approaches to the user for selection.

## Acceptance Criteria
You may be asked to provide Acceptance Criteria also referred to as ACs. 
Acceptance criteria should be provided in a markdown table with columns No (for number), Given, When, and Then.
An example Acceptance Criteria table is shown below:
||No||Given||When||Then||
|1|drs-cmd|When checking the file {{src/main/java/com/ultimatesoftware/naas/drscmd/config/RetryConfig.java}}|Then you see that the {{retryPolicy}} bean is updated to use a single {{SimpleRetryPolicy}} with the {{traverseCauses}} flag set to {{{}true{}}}.|
|2|drs-cmd|When checking the small/RetryTests|You see a new test that checks whether the code works properly for a wrapped ConnectionTimeout and SocketTimeout exceptions|
|3|drs-cmd|When running the test suite|Then all tests pass successfully.|
|4|drs-cmd|When a {{software.amazon.awssdk.core.exception.SdkClientException}} is thrown with a cause of {{java.net.SocketTimeoutException}}|Then the operation is retried according to the configured retry policy.|

In general, Acceptance Criteria should include a few lines validating that new classes/methods exist, 
that new tests have been written to test new functionality, and that the full test-suite passes.

$ISSUE_PROMPT
EOF
)
  gemini -i "$GEMINI_PROMPT" 
}

function gemini-reviewer(){
  if ! $(echo "$1" | grep -E "^https://github.com/.*/pull/[0-9]+$" 1>/dev/null); then
    echo "Usage: gemini-reviewer <github_pr_url>"
    return 1
  fi

  local REVIEW_PROMPT="Please review the following GitHub pull request: $1"

  GEMINI_PROMPT=$(cat << EOF
You are an expert code reviewer. Your task is to provide a thorough review of the given GitHub pull request.

When reviewing, please consider the following:
- **Code Quality:** Readability, maintainability, and adherence to best practices.
- **Functionality:** Does the code do what it says it does? Are there any obvious bugs or edge cases missed?
- **Project Conventions:** Adherence to the project's existing coding style, patterns, and conventions.
- **Security:** Are there any potential security vulnerabilities?
- **Performance:** Could any of the changes introduce performance issues?
- **Testing:** Are the tests adequate? Do they cover the changes effectively?

Please provide your feedback in a clear and constructive manner. Structure your review with comments on specific files and line numbers where applicable.
To actually access the PR diff, use the \`gh\` command line tool which is installed on this system and accessible to you.

$REVIEW_PROMPT
EOF
)
  gemini -i "$GEMINI_PROMPT"
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
  export PATH="$PATH:/opt/homebrew/bin"
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

if [[ -z "$TMUX" ]] && [[ -n "$PS1" ]]; then
 tmux attach -t dev || tmux new -s dev
fi
