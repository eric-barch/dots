-- Neovim LSP client configurations for various LSP servers
-- See `:help lspconfig`

return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = {
      'williamboman/mason.nvim',
      'mason-org/mason-lspconfig.nvim',
    },
    config = function()
      local servers = {
        'clangd',
        'lua_ls',
        'prismals',
        'pyright',
        'rust_analyzer',
        'tailwindcss',
        'ts_ls',
        'ty',
      }

      require('mason').setup()
      require('mason-lspconfig').setup {
        automatic_enable = true,
        ensure_installed = servers,
      }
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
