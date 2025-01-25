-- Configure LuaLS for editing Neovim config
-- See `:help lazydev`

return {
  {
    'folke/lazydev.nvim',
    opts = {
      library = {
        -- Load luvit types
        { path = '${3rd}/luv/library' },
      },
    },
  },
}

-- vim: ts=2 sts=2 sw=2 et
