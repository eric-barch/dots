-- [[ Set options ]]

-- Set highlight on search
vim.o.hlsearch = false

-- Line numbers
vim.wo.number = true

-- Relative line numbers
vim.wo.relativenumber = true

-- Sync clipboard between OS and Neovim
vim.o.clipboard = 'unnamedplus'

-- Disable line wrapping globally
vim.wo.wrap = false

-- Handle line wrapping in Markdown files
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.wo.wrap = true
    vim.wo.linebreak = true
  end,
})

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Enable 24-bit color schemes
vim.o.termguicolors = true

-- vim: ts=2 sts=2 sw=2 et
