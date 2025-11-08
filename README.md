# dots

My dotfiles.

## Setup

```sh
git clone https://github.com/eric-barch/dots.git ~/.dots
cd ~/.dots
make setup
```

## Issues

1. vim.lsp.util.jump_to_location is deprecated. Run ":checkhealth
   vim.deprecated" for more information.
1. When you open a new buffer by jumping using language server linking, can end
   up in the wrong spot if file was open before because of how I've implemented
   remebering the last place in the file.
1. Folds behave weirdly in some cases. When I was working on the `scheme` shell
   script, when I would paste in a function, the function and all its inner
   blocks would be automatically folded.
1. Code Companion is not actually connected to an LLM API anymore lol.
1. Collapsing an ordered list item at root level causes the whole section under
   that header to collapse. I want it to only collapse the ordered item.
1. In my shell, when I type a full word I can't seem to backspace it, even in
   insert mode. Some vim mode zsh extension I have installed?
1. `.env` and probably other filetypes are not included in telescope file
   search.
1. Formatter 'black' timeout (and other formatters). Make it async and give it
   more time or figure out why it's taking so long.
1. Linting large JSON files takes forever and blocks other execution. Make it
   async.
1. Sometimes when I paste a multiline function in it starts in a folded state.
1. `yazi` is broken.
1. Log when saving scheme.

## Wishlist

1. Install
   [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim?tab=readme-ov-file).
1. Set up better CSV display in nvim, probably
   [csvviem.nvim](https://github.com/hat0uma/csvview.nvim).
   [olimorris uses it](https://github.com/hat0uma/csvview.nvim/issues/50).
1. Dark/light selection for `scheme` bin
1. Set up vertical line at col 80, probably
   [virt-column.nvim](https://github.com/lukas-reineke/virt-column.nvim).
