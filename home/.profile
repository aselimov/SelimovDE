. "$HOME/.cargo/env"

[ -f "/home/aselimov/.ghcup/env" ] && . "/home/aselimov/.ghcup/env" # ghcup-env

export PATH="$PATH:/usr/local/cuda-12.8/bin:$HOME/bin:$HOME/.local/bin"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda-12.8/lib64"
