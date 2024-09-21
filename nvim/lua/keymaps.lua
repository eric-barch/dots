-- Keymaps
-- See `:help vim.keymap`

-- <Esc>
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>') -- Un-highlight any search

-- Diagnostics
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, {
  desc = 'Go to previous [d]iagnostic message',
})
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, {
  desc = 'Go to next [d]iagnostic message',
})
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, {
  desc = 'Show diagnostic [e]rror messages',
})
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, {
  desc = 'Open diagnostic [q]uickfix list',
})

-- Directional navigation
vim.keymap.set('n', 'j', 'gj', { silent = true })
vim.keymap.set('n', 'k', 'gk', { silent = true })
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', {
  desc = 'Focus split to left',
})
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', {
  desc = 'Focus split to right',
})
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', {
  desc = 'Focus split below',
})
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', {
  desc = 'Focus split above',
})

-- vim: ts=2 sts=2 sw=2 et
