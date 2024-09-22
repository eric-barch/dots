-- Install plugins
-- See `:help lazy.nvim`

require('lazy').setup {
  require 'plugins/autopairs',
  require 'plugins/base16',
  require 'plugins/codecompanion',
  require 'plugins/cmp',
  require 'plugins/conform',
  require 'plugins/comment',
  require 'plugins/dap',
  require 'plugins/gitsigns',
  require 'plugins/lspconfig',
  require 'plugins/mini',
  require 'plugins/telescope',
  require 'plugins/treesitter',
  require 'plugins/vim-sleuth',
  require 'plugins/vim-tmux-navigator',
  require 'plugins/which-key',

  -- TODO: Check out these plugins from kickstart.nvim:
  -- require 'plugins/indent_line',
  -- require 'plugins/lint',
}

-- vim: ts=2 sts=2 sw=2 et
