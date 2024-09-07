export TERM="xterm-256color"
export PAGER=less
export EDITOR=nvim

# XDG environment variables
# https://specifications.freedesktop.org/basedir-spec/latest/index.html#variables
export XDG_DATA_HOME="${XDG_DATA_HOME:=$HOME/.local/share}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=$HOME/.config}"
export XDG_STATE_HOME="${XDG_STATE_HOME:=$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:=$HOME/.cache}"
export XDG_DATA_DIRS="${XDG_DATA_DIRS:=/usr/local/share/:/usr/share/}"
export XDG_CONFIG_DIRS="${XDG_CONFIG_DIRS:=/etc/xdg}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:=/run/user/$UID}"

# XDG recommends this location for executables, but does not actually specify 
# an environment variable. Thus, no XDG prefix.
export BIN_HOME="${BIN_HOME:=$HOME/.local/bin}"

# Move zsh config location from default (home) to XDG
export ZDOTDIR="${ZDOTDIR:=$XDG_CONFIG_HOME/zsh}"

# Base16 theme
# https://github.com/chriskempson/base16-shell
export BASE16_THEME="gruvbox-material-dark-hard"

# Specify ESP-IDF install location
# https://docs.espressif.com/projects/esp-idf/en/stable/esp32/api-guides/tools/idf-tools.html#tools-installation-directory
# TODO: Kind of annoying I need a whole environment variable for one rarely-
# used application. Consider refactoring somehow.
export IDF_TOOLS_PATH="${IDF_TOOLS_PATH:=$XDG_DATA_HOME/espressif}"

# Add XDG and Homebrew executables to $PATH
# Equivalent to `export PATH="$BIN_HOME:/opt/homebrew/bin:$PATH"`, but de-duped
path=(
  $BIN_HOME
  /opt/homebrew/bin
  $path
)
