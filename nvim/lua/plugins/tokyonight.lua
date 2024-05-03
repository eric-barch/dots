-- Tokyonight colorscheme.
-- See `:help tokyonight` and
-- `https://github.com/folke/tokyonight.nvim?tab=readme-ov-file#%EF%B8%8F-configuration`.
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
