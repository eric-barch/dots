-- Set relative line numbers
vim.opt.relativenumber = true

-- Auto save folds when leaving a buffer, but only for buffers associated with a file
vim.cmd([[autocmd BufWinLeave * if !empty(expand('%')) && &buftype == '' | mkview | endif]])

-- Auto load folds when entering a buffer, but only for buffers associated with a file
vim.cmd([[autocmd BufWinEnter * if !empty(expand('%')) && &buftype == '' | silent! loadview | endif]])
