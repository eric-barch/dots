# dots

My dotfiles.

## Setup

```sh
git clone https://github.com/eric-barch/dots.git ~/.dots
cd ~/.dots
make setup
```

## TODO

I ususally discover the need for a new feature when I'm in the middle of some other project. Instead of derailing my workflow by implementing it immediately, I write it down here so I can come back to it during dedicated dotfiles time.

### New Applications

- Set up a tiling window manager, maybe [Yabai](https://github.com/koekeishiya/yabai).
- Set up [Raycast](https://www.raycast.com/).
- Set up [Hammerspoon](https://github.com/Hammerspoon/hammerspoon).

### Neovim

- Customize [CodeCompanion](https://github.com/olimorris/codecompanion.nvim) prompts.
- Learn to switch between CodeCompanion models and default to Claude or Ollama instead of GPT.
- Make folds persistent and mark visually in sign column.
- Implement keymap to minimize pane width to widest row.
    - Implement keymap to do this for all open panes.
- Move filepath from bottom to top of pane.
- Delete nvim powerline or at least remove useless crap.
- LSP warnings/errors and other virtual text should wrap instead of overflowing pane.
- Keymap that jumps to next line with an LSP error
- Explore replacing telescope with fzf lua
- Make directional keys NOT repeat so I actually start using other methods to jump around page

### Tmux

- Character-wise visual mode selection seems to be unavailable... not sure when I broke that.
