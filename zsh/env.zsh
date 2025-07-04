export TERM="xterm-256color"
export PAGER=less
export EDITOR=nvim

# XDG environment variables
# https://specifications.freedesktop.org/basedir-spec/latest/index.html#variables
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_DIRS="${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"
export XDG_CONFIG_DIRS="${XDG_CONFIG_DIRS:-/etc/xdg}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/tmp}"

# XDG recommends this location for executables, but does not actually specify 
# an environment variable. Thus, no XDG prefix.
export BIN_HOME="${BIN_HOME:-$HOME/.local/bin}"

# Move zsh config location from default (home) to XDG
export ZDOTDIR="${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}"

# Base16 theme
# https://github.com/chriskempson/base16-shell
export BASE16_THEME="catppuccin-mocha"

# Pyenv
export PYENV_ROOT="${PYENV_ROOT:-$HOME/.pyenv}"

# Add XDG and Homebrew executables to $PATH
# Equivalent to `export PATH="$BIN_HOME:/opt/homebrew/bin:$PATH"`, but de-duped
typeset -U path
path=(
  $BIN_HOME
  /opt/homebrew/bin
  $HOME/.cargo/bin
  $PYENV_ROOT/bin
  $path
)
