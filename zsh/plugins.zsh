# Antidote ZSH Plugin Manager
# https://github.com/mattmc3/antidote?tab=readme-ov-file#usage
ANTIDOTE="$XDG_CONFIG_HOME/antidote/antidote.zsh"
if [ -f "$ANTIDOTE" ]; then
  source "$ANTIDOTE"
  antidote load "$XDG_CONFIG_HOME/zsh/plugins/antidote_plugins.txt"
fi
