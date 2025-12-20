# Set up fzf key bindings and fuzzy completion
# https://github.com/junegunn/fzf?tab=readme-ov-file#setting-up-shell-integration
eval "$(fzf --zsh)"

# Set default scheme
command -v scheme >/dev/null && scheme 2>/dev/null
