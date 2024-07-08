-- AI chat and completions.
-- See `:help codecompanion`.

return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'nvim-telescope/telescope.nvim',
    {
      'stevearc/dressing.nvim', -- Optional: Improves the default Neovim UI
      opts = {},
    },
  },
  config = true,
}

-- vim: ts=2 sts=2 sw=2 et
