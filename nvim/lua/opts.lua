-- Options
-- See `:help vim.opt`

-- Buffer
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Make line numbers relative
vim.opt.wrap = false -- Disable line wrapping
vim.opt.showmode = false -- Don't show mode (already in statusline)
vim.opt.signcolumn = 'yes' -- Always show sign column, even when empty
vim.opt.list = true -- Identify whitespace characters
vim.opt.scrolloff = 10 -- Minimum visible lines above and below cursor
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' } -- Identifiers
vim.opt.fillchars = { eob = ' ' } -- Remove tildes on empty lines
vim.opt.viewoptions:append 'folds' -- Include folds in view files
-- Set buffer filetype if configured in .editorconfig
require('editorconfig').properties.filetype = function(buf, val)
  vim.api.nvim_set_option_value('filetype', val, { buf = buf })
end

-- Clipboard and history
vim.opt.clipboard = 'unnamedplus' -- Sync OS and Neovim clipboards
vim.opt.undofile = true -- Save undo history

-- Color
vim.opt.termguicolors = false -- Derive colors from terminal palette

-- Search
vim.opt.hlsearch = true -- Highlight on search
vim.opt.ignorecase = true -- Case-insensitive search
vim.opt.smartcase = true -- Case sensitive if \C or capital letters

-- Splits
vim.opt.splitright = true -- Focus new pane on right split
vim.opt.splitbelow = true -- Focus new pane on down split
vim.opt.inccommand = 'nosplit' -- Preview substitutions in buffer

-- vim: ts=2 sts=2 sw=2 et
