# Source all functions
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=$HOME/.config}"
ZDOTDIR="${ZDOTDIR:=$XDG_CONFIG_HOME/zsh}"

for file in "$ZDOTDIR/functions"/*.zsh; do
  source "$file"
done
