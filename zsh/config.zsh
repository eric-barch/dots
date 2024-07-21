# Environment variables
export EDITOR=nvim
export VISUAL=nvim
export PAGER=less
export TERM="xterm-256color"

# Export environment variables if not already defined
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:=$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:=$HOME/.cache}"
export BIN_HOME="${BIN_HOME:=$HOME/.local/bin}"
export ZDOTDIR="${ZDOTDIR:=$XDG_CONFIG_HOME/zsh}"
export IDF_TOOLS_PATH="${IDF_TOOLS_PATH:=$XDG_DATA_HOME/espressif}"

# Environment paths
path=(
  $HOME/.local/bin
  /opt/homebrew/bin
  $path
)

# History
HISTFILE=$ZDOTDIR/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt INC_APPEND_HISTORY

# Vi mode
bindkey -v          # Vim mode
export KEYTIMEOUT=1 # Snappier <ESC>

# Set up fzf key bindings and fuzzy completion
# https://github.com/junegunn/fzf?tab=readme-ov-file#setting-up-shell-integration
eval "$(fzf --zsh)"

# Load Node Version Manager
# https://formulae.brew.sh/formula/nvm
. /opt/homebrew/opt/nvm/nvm.sh
