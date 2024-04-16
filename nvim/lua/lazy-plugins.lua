-- [[ Configure and install plugins ]]
-- Check plugin status: `:Lazy`
-- Update plugins: `:Lazy update`

require('lazy').setup({
  -- <leader>gc comments visual selection
  { 'numToStr/Comment.nvim', opts = {} },

  require 'plugins/vim-sleuth',
  require 'plugins/catppuccin',
  require 'plugins/tokyonight',
  require 'plugins/gitsigns',
  require 'plugins/which-key',
  require 'plugins/telescope',
  require 'plugins/lspconfig',
  require 'plugins/conform',
  require 'plugins/treesitter',
  require 'plugins/cmp',
  require 'plugins/todo-comments',
  require 'plugins/mini',

  -- TODO: Check out these plugins:
  -- require 'plugins.debug',
  -- require 'plugins.indent_line',
  -- require 'plugins.lint',
}, {
  ui = {
    -- If using a Nerd Font, set icons to an empty table. Otherwise define a
    -- unicode icons table.
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- vim: ts=2 sts=2 sw=2 et
