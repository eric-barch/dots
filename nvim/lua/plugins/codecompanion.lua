-- AI chat and completions
-- See `:help codecompanion`

return {
  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      -- https://github.com/olimorris/codecompanion.nvim/issues/377
      { 'nvim-lua/plenary.nvim', branch = 'master' },
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      interactions = {
        chat = {
          adapter = 'openai',
        },
        inline = {
          adapter = 'openai',
        },
        cmd = {
          adapter = 'openai',
        },
        background = {
          adapter = 'openai',
        },
      },
    },
    version = '^18.0.0',
  },
}

-- vim: ts=2 sts=2 sw=2 et
