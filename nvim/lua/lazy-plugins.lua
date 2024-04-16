-- [[ Configure and install plugins ]]
-- Check plugin status: `:Lazy`
-- Update plugins: `:Lazy update`

require('lazy').setup({
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- <leader>gc comments visual selection
  { 'numToStr/Comment.nvim', opts = {} },

  -- NOTE: Using `require 'path/name'` will include a plugin definition from
  -- file lua/path/name.lua

  require 'plugins/catppuccin',
  require 'plugins/gitsigns',
  require 'plugins/which-key',
  require 'plugins/telescope',
  require 'plugins/lspconfig',
  -- Customized up to here.
  require 'plugins/conform',
  require 'plugins/cmp',
  require 'plugins/todo-comments',
  require 'plugins/mini',
  require 'plugins/treesitter',

  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  -- require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.indent_line',
  -- require 'kickstart.plugins.lint',
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
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
