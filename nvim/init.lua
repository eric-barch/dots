vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [[ Install `lazy.nvim` plugin manager ]]
require 'lazy-bootstrap'

-- [[ Configure plugins ]]
require 'lazy-plugins'

-- [[ Set options ]]
require 'options'

-- [[ Set keymaps ]]
require 'keymaps'

-- [[ Configure Telescope (fuzzy finder) ]]
require 'telescope-setup'

-- [[ Configure Treesitter (syntax parser for highlighting) ]]
require 'treesitter-setup'

-- [[ Configure LSP (Language Server Protocol)]]
require 'lsp-setup'

-- [[ Configure nvim-cmp (completion)]]
require 'cmp-setup'

-- vim: ts=2 sts=2 sw=2 et
