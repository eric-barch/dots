-- Show pending keybindings.
-- See `:help which-key`.

return {
  {
    'folke/which-key.nvim',
    -- Load WhichKey before all UI elements.
    event = 'VimEnter',
    -- Runs AFTER WhichKey has loaded.
    config = function()
      require('which-key').setup()
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
