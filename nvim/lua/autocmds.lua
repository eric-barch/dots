-- Autocommands
-- See `:help nvim_create_autocmd`

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Enable line wrapping for text files',
  pattern = { 'markdown', 'text', 'log' },
  callback = function()
    vim.opt_local.wrap = true -- Enable line wrapping
    vim.opt_local.linebreak = true -- Break lines on word boundaries
  end,
})

vim.api.nvim_create_autocmd({ 'FileType', 'BufReadPost' }, {
  desc = 'Enable folding in YAML files',
  pattern = 'yaml',
  callback = function()
    vim.opt_local.foldmethod = 'indent'
    vim.opt_local.foldenable = true
    -- If no saved view exists, open all folds
    if vim.fn.empty(vim.fn.glob(vim.fn.stdpath 'state' .. '/view/' .. vim.fn.expand('%:p'):gsub('/', '='))) == 1 then
      vim.cmd 'normal! zR'
    end
  end,
})

vim.api.nvim_create_autocmd('BufWinLeave', {
  desc = 'Save view on buffer leave',
  pattern = '*',
  callback = function()
    if vim.fn.filereadable(vim.fn.expand '%:p') == 1 and vim.bo.buftype == '' then
      vim.cmd 'mkview'
    end
  end,
})

vim.api.nvim_create_autocmd('BufWinEnter', {
  desc = 'Load view on buffer enter',
  pattern = '*',
  callback = function()
    if vim.fn.filereadable(vim.fn.expand '%:p') == 1 and vim.bo.buftype == '' then
      vim.cmd 'loadview'
    end
  end,
})

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
