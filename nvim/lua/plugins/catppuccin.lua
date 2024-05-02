-- Catppuccin colorscheme.
-- See `:help catppuccin` and
-- `https://github.com/catppuccin/nvim?tab=readme-ov-file#configuration`.
return {
  {
    'catppuccin/nvim',
    priority = 1000,
    lazy = false,
    config = function()
      local catppuccin = require 'catppuccin'
      catppuccin.setup {
        styles = {
          comments = {},
        },
      }
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
