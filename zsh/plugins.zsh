ANTIDOTE="$XDG_CONFIG_HOME/antidote/antidote.zsh"
if [ -f "$ANTIDOTE" ]; then
  source "$ANTIDOTE"
  antidote load "$XDG_CONFIG_HOME/zsh/antidote_plugins.txt"
fi
