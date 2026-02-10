-- LSP
-- See `:help lspconfig`

local project = require 'utils.project'

local default_servers = {
  'lua_ls',
  'ts_ls',
  'ty',
}

local function get_servers()
  project.load_config()

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
      local servers = get_servers()

      require('mason').setup()
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
