. "$HOME/.cargo/env"

[ -f "/home/aselimov/.ghcup/env" ] && . "/home/aselimov/.ghcup/env" # ghcup-env

export PATH="$PATH:$HOME/.local/bin"

if [ "$(uname)" = "Darwin" ]; then
    export PATH="$HOME/bin:/opt/homebrew/opt/gnu-sed/libexec/gnubin:/opt/homebrew/bin:$PATH"
fi

export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda-12.8/lib64"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/aselimov/.lmstudio/bin"
# End of LM Studio CLI section

