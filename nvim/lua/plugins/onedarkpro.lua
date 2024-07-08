-- One Dark Pro colorscheme.
-- See `:help onedarkpro`.

return {
  {
    'olimorris/onedarkpro.nvim',
    lazy = false,
    config = function()
      local onedarkpro = require 'onedarkpro'
      onedarkpro.setup {}
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
