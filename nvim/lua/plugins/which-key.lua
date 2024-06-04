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

      -- Register prefixes.
      require('which-key').register {
        ['<leader>b'] = { name = '[b]rowse', _ = 'which_key_ignore' },
        ['<leader>c'] = { name = '[c]ode', _ = 'which_key_ignore' },
        ['<leader>d'] = { name = '[d]ocument', _ = 'which_key_ignore' },
        ['<leader>r'] = { name = '[r]ename', _ = 'which_key_ignore' },
        ['<leader>s'] = { name = '[s]earch', _ = 'which_key_ignore' },
        ['<leader>w'] = { name = '[w]orkspace', _ = 'which_key_ignore' },
      }
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
