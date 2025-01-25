-- Configure LuaLS for editing Neovim config
-- See `:help lazydev`

return {
  {
    'folke/lazydev.nvim',
    opts = {
      library = {
        -- Load luvit types
        { path = '${3rd}/luv/library' },
        -- Load `lazy.nvim` types
        { path = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim/lua' },
      },
    },
  },
}

-- vim: ts=2 sts=2 sw=2 et
