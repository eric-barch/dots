-- Options
-- See `:help vim.opt`

-- Buffer
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Make line numbers relative
vim.opt.wrap = false -- Disable line wrapping
vim.opt.showmode = false -- Don't show mode since it's already in statusline
vim.opt.signcolumn = 'yes' -- Always show sign column
vim.opt.list = true -- Identify whitespace characters
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' } -- Identifiers
vim.opt.fillchars = { eob = ' ' } -- Remove tildes on empty lines

-- Clipboard and history
vim.opt.clipboard = 'unnamedplus' -- Sync clipboard between OS and Neovim
vim.opt.undofile = true -- Save undo history

-- Color
vim.opt.termguicolors = false -- Derive colors from terminal palette

-- Cursor
vim.opt.scrolloff = 10 -- Minimum number of lines above and below the cursor

-- Search
vim.opt.hlsearch = true -- Highlight on search
vim.opt.ignorecase = true -- Case-insensitive search
vim.opt.smartcase = true -- Case sensitive if \C or capital letters

-- Splits
vim.opt.splitright = true -- Focus new pane on right split
vim.opt.splitbelow = true -- Focus new pane on down split
vim.opt.inccommand = 'nosplit' -- Preview substitutions in buffer

-- vim: ts=2 sts=2 sw=2 et
