# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Update $PATH.
export PATH=$HOME/bin:/opt/homebrew/bin:/usr/local/bin:$PATH

# Map zsh to Oh My Zsh.
export ZSH="$HOME/.oh-my-zsh"


# Set p10k theme.
ZSH_THEME="powerlevel10k/powerlevel10k"

# Load Oh My Zsh plugins.
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Run Oh My Zsh startup script.
source $ZSH/oh-my-zsh.sh

# Source p10k theme if it exists.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Switch to vi mode
bindkey -v
