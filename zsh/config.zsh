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
export STARSHIP_CONFIG="${STARSHIP_CONFIG:=$XDG_CONFIG_HOME/starship/starship.toml}"

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

# Completion
autoload -Uz compinit && compinit -i  # Do not load completions from world-writable directories
setopt GLOB_COMPLETE                  # Glob is useful for finding branches e.g. ls/*-topic
zmodload zsh/complist		      # For MENU complete
setopt AUTO_MENU		      # MENU completion for <TAB> <TAB> in multiple-match situations
unsetopt MENU_COMPLETE		      # Unset in favor of AUTO_MENU
setopt COMPLETE_IN_WORD		      # <TAB> completions work in-word
_comp_options+=(globdots)	      # Show hidden files in completion
zstyle ':completion:*:*:*:*:*' menu select					    # Show completions in menu
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*' # Completions are case insensitive
zstyle ':completion:*' list-colors '${LS_COLORS}'			      	    # Completions colored by type
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=29=34'      # Kill completions colored by type

# Vi mode
bindkey -v	    # Vim mode
export KEYTIMEOUT=1 # Snappier <ESC>

# Vi completion navigation (must be after complist)
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# Set up fzf key bindings and fuzzy completion
# https://github.com/junegunn/fzf?tab=readme-ov-file#setting-up-shell-integration
eval "$(fzf --zsh)"
