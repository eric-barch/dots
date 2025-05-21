-- Autocommands
-- See `:help nvim_create_autocmd`

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Enable line wrapping for text files',
  pattern = { 'markdown', 'text', 'log' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true -- Break lines on word boundaries
  end,
})

vim.api.nvim_create_autocmd('BufWinEnter', {
  desc = 'Restore view',
  callback = function()
    if vim.fn.empty(vim.fn.expand '%:p') == 0 and vim.bo.buftype == '' then
      vim.schedule(function()
        vim.cmd 'silent! loadview'
      end)
    end
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight on yank',
  group = vim.api.nvim_create_augroup('highlight_on_yank', {
    clear = true,
  }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd('BufWinLeave', {
  desc = 'Save view',
  callback = function()
    if vim.fn.empty(vim.fn.expand '%:p') == 0 and vim.bo.buftype == '' then
      vim.cmd 'silent! mkview'
    end
  end,
})

-- vim: ts=2 sts=2 sw=2 et
