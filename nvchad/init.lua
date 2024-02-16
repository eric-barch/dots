-- Set relative line numbers
vim.opt.relativenumber = true

-- Auto save folds when leaving a buffer
vim.cmd([[autocmd BufWinLeave * mkview]])

-- Auto load folds when entering a buffer
vim.cmd([[autocmd BufWinEnter * silent! loadview]])
