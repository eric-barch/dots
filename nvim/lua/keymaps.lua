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
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, {
  desc = 'Show [d]iagnostic messages',
})
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, {
  desc = 'Open diagnostic [q]uickfix list',
})

-- Autoformat
vim.keymap.set('n', '<leader>f', function()
  local conform = require 'conform'
  conform.format()
end, {
  desc = 'Format',
})

-- Cursor navigation in wrapped files
vim.keymap.set('n', 'j', 'v:count == 0 ? "gj" : "j"', {
  silent = true,
  expr = true,
})
vim.keymap.set('n', 'k', 'v:count == 0 ? "gk" : "k"', {
  silent = true,
  expr = true,
})

-- Split navigation
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

-- CodeCompanion
-- https://codecompanion.olimorris.dev/getting-started#suggested-plugin-workflow
vim.keymap.set({ 'n', 'v' }, '<C-a>', '<cmd>CodeCompanionActions<cr>', { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, '<LocalLeader>a', '<cmd>CodeCompanionChat Toggle<cr>', { noremap = true, silent = true })
vim.keymap.set('v', 'ga', '<cmd>CodeCompanionChat Add<cr>', { noremap = true, silent = true })

-- vim: ts=2 sts=2 sw=2 et
