-- Configure and install plugins.
-- Check plugin status: `:Lazy`
-- Update plugins: `:Lazy update`

require('lazy').setup {
  require 'plugins/onedarkpro',
  require 'plugins/catppuccin',
  require 'plugins/tokyonight',
  require 'plugins/vim-tmux-navigator',
  require 'plugins/telescope',
  require 'plugins/lspconfig',
  require 'plugins/which-key',
  require 'plugins/treesitter',
  require 'plugins/gitsigns',
  require 'plugins/vim-sleuth',
  require 'plugins/autopairs',
  require 'plugins/conform',
  require 'plugins/comment',
  require 'plugins/todo-comments',
  require 'plugins/cmp',
  require 'plugins/mini',
  require 'plugins/codecompanion',
  require 'plugins/dap',

  -- TODO: Check out these plugins from kickstart.nvim:
  -- require 'plugins/indent_line',
  -- require 'plugins/lint',
}

-- vim: ts=2 sts=2 sw=2 et
