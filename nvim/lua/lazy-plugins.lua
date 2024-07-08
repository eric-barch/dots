-- Configure and install plugins.
-- Check plugin status: `:Lazy`
-- Update plugins: `:Lazy update`

require('lazy').setup {
  require 'plugins/vim-sleuth',
  require 'plugins/comment',
  require 'plugins/catppuccin',
  require 'plugins/tokyonight',
  require 'plugins/onedarkpro',
  require 'plugins/gitsigns',
  require 'plugins/which-key',
  require 'plugins/telescope',
  require 'plugins/lspconfig',
  require 'plugins/conform',
  require 'plugins/treesitter',
  require 'plugins/cmp',
  require 'plugins/todo-comments',
  require 'plugins/mini',
  require 'plugins/vim-tmux-navigator',

  -- TODO: Check out these plugins:
  -- require 'plugins.debug',
  -- require 'plugins.indent_line',
  -- require 'plugins.lint',
}

-- vim: ts=2 sts=2 sw=2 et
