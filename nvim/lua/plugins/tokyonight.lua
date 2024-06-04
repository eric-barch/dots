-- Tokyonight colorscheme.
-- See `:help tokyonight`.

return {
  {
    'folke/tokyonight.nvim',
    lazy = false,
    config = function()
      local tokyonight = require 'tokyonight'
      tokyonight.setup {}
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
