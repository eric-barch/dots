-- Automatic commands
-- See `:help nvim_create_autocmd`

-- Wrap Markdown lines on word boundaries
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.opt_local.wrap = true -- Enable line wrapping
    vim.opt_local.linebreak = true -- Break lines on word boundaries
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight on yank',
  group = vim.api.nvim_create_augroup('highlight_on_yank', {
    clear = true,
  }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- vim: ts=2 sts=2 sw=2 et
