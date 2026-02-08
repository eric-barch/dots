-- Neovim LSP client configurations for various LSP servers
-- See `:help lspconfig`

local default_servers = {
  'lua_ls',
  'ts_ls',
  'ty',
}

local function load_project_config()
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

local function get_servers()
  load_project_config()

  if vim.g.project and vim.g.project.lsp then
    local servers = vim.g.project.lsp

    if type(servers) == 'table' then
      return servers
    end

    return { servers }
  end

  return default_servers
end

return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'mason-org/mason-lspconfig.nvim',
    },
    config = function()
      require('mason').setup()

      local servers = get_servers()

      require('mason-lspconfig').setup {
        automatic_installation = true,
        ensure_installed = servers,
        -- `automatic_enable` enables all _installed_ servers. We only want to
        -- enable servers in this project.
        automatic_enable = false,
      }

      for _, server in ipairs(servers) do
        vim.lsp.enable(server)
      end
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
