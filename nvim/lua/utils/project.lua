-- Shared utility for loading per-project `.nvim.lua` config files
-- Usage: require('utils.project').load_config()

local M = {}

function M.load_config()
  local name = vim.api.nvim_buf_get_name(0)

  local start

  if name == '' then
    start = vim.fn.getcwd()
  else
    if vim.fn.isdirectory(name) then
      start = name
    else
      start = vim.fs.dirname(name)
    end
  end

  local found = vim.fs.find('.nvim.lua', {
    path = start,
    upward = true,
    type = 'file',
  })[1]

  if found then
    pcall(vim.cmd.source, found)
  end
end

return M

-- vim: ts=2 sts=2 sw=2 et
