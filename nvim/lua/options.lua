-- Setting options
-- See `:help vim.opt`.
-- NOTE: For more options, see `:help option-list`

-- Line number settings.
vim.opt.number = true
vim.opt.relativenumber = true

-- Don't show the mode, since it's already in the status line.
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
-- See `:help 'clipboard'`.
vim.opt.clipboard = 'unnamedplus'

-- Disable line wrapping globally.
vim.wo.wrap = false

-- Handle line wrapping in Markdown files.
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.wo.wrap = true
    vim.wo.linebreak = true
  end,
})

-- Save undo history.
vim.opt.undofile = true

-- Case-insensitive searching unless \C or one or more capital letters in the
-- search term.
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default.
vim.opt.signcolumn = 'yes'

-- Set folds by indent (which should be set by autoformatter).
vim.opt.foldmethod = 'indent'

-- Expand all folds.
vim.opt.foldlevel = 99

-- Decrease update time (writes swap file and fires CursorHold).
vim.opt.updatetime = 250

-- Display which-key popup sooner.
vim.opt.timeoutlen = 300

-- Focus new pane on split.
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Identify whitespace characters.
-- See `:help 'list'`.
-- and `:help 'listchars'`.
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions.
vim.opt.inccommand = 'split'

-- Minimum number of lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Enable 24-bit colorschemes.
vim.opt.termguicolors = true

-- vim: ts=2 sts=2 sw=2 et
