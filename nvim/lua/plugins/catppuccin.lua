-- Catppuccin colorscheme.
-- See `:help catppuccin`.

return {
  {
    'catppuccin/nvim',
    lazy = false,
    config = function()
      local catppuccin = require 'catppuccin'
      catppuccin.setup {}
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
