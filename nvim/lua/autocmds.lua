-- Automatic commands
-- See `:help nvim_create_autocmd`

-- Enable line wrapping for certain filetypes
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Enable line wrapping for text files',
  pattern = { '*.md', '*.txt', '*.log' },
  callback = function()
    vim.opt_local.wrap = true -- Enable line wrapping
    vim.opt_local.linebreak = true -- Break lines on word boundaries
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight on yank',
  group = vim.api.nvim_create_augroup('highlight_on_yank', {
    clear = true, -- Clear any existing highlight group
  }),
  callback = function()
    vim.highlight.on_yank() -- Highlight yanked text
  end,
})

-- vim: ts=2 sts=2 sw=2 et
