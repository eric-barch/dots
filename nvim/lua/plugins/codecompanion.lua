-- AI chat and completions.
-- See `:help codecompanion`.

return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'hrsh7th/nvim-cmp',
    'nvim-telescope/telescope.nvim',
    { 'stevearc/dressing.nvim', opts = {} },
  },
  config = function()
    require('codecompanion').setup {
      adapters = {
        openai = function()
          return require('codecompanion.adapters').extend('openai', {
            env = {
              api_key = os.getenv 'OPENAI_API_KEY',
            },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = 'openai',
        },
        inline = {
          adapter = 'openai',
        },
        agent = {
          adapter = 'openai',
        },
      },
    }
  end,
}

-- vim: ts=2 sts=2 sw=2 et
