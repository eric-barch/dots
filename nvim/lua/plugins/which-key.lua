-- Show pending keybindings
-- See `:help which-key`

return {
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    config = function()
      require('which-key').setup()
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
