# dots

My dotfiles.

## Setup

```sh
git clone https://github.com/eric-barch/dots.git ~/.dots
cd ~/.dots
make setup
```

## TODO

I always come up with new feature ideas in the middle of some other project. I write them down here so I can come back and implement it during dedicated dotfiles time.

### New Applications

- A tiling window manager, maybe [Yabai](https://github.com/koekeishiya/yabai)
- [Raycast](https://www.raycast.com/)
- [Hammerspoon](https://github.com/Hammerspoon/hammerspoon)

### Neovim

- Customize [CodeCompanion](https://github.com/olimorris/codecompanion.nvim) prompts.
- Learn to switch between CodeCompanion models and default to Claude or Ollama instead of GPT.
- Persist folds and mark visually in sign column.
- Keymap to minimize pane width to widest row.
    - Implement keymap to do this for all open panes.
- Keymap that jumps to next line with LSP feedback.
- Consider replacing telescope with fzf lua.
- Angle statusline mode and location indicators to match style of tmux.
- Statusline background should be the same color as buffer background (currently darker).

### Tmux

- Consider adding session name to statusline.
