# Set up fzf key bindings and fuzzy completion
# https://github.com/junegunn/fzf?tab=readme-ov-file#setting-up-shell-integration
eval "$(fzf --zsh)"

# Initialize pyenv so it can manage Python versions and switch them per project
eval "$(pyenv init - zsh)"
