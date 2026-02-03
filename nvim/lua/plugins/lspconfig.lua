-- Neovim LSP client configurations for various LSP servers
-- See `:help lspconfig`

local function assign_filetype_to_server(servers, server_name, filetype)
  local server_config = servers[server_name] or {}
  server_config.filetypes = { filetype }
  servers[server_name] = server_config
end

local function use_project_language_servers(servers)
  local project = vim.g.project or {}
  for filetype, config in pairs(project) do
    if type(config) == 'table' and config.lsp ~= nil then
      local lsps = config.lsp
      if type(lsps) == 'string' then
        lsps = { lsps }
      end
      if type(lsps) == 'table' then
        for _, server_name in ipairs(lsps) do
          if type(server_name) == 'string' then
            assign_filetype_to_server(servers, server_name, filetype)
          end
        end
      end
    end
  end
end

return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      local lspconfig = require 'lspconfig'
      local mason = require 'mason'
      local mason_lspconfig = require 'mason-lspconfig'
      local cmp_nvim_lsp = require 'cmp_nvim_lsp'

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = handle_lsp_attach,
      })

      local capabilities = cmp_nvim_lsp.default_capabilities()

      local servers = {
        lua_ls = { filetypes = { 'lua' } },
        prismals = { filetypes = { 'prisma' } },
        pyright = { filetypes = { 'python' } },
        rust_analyzer = { filetypes = { 'rust' } },
        tailwindcss = { filetypes = { 'css' } },
        ts_ls = {
          filetypes = {
            'javascript',
            'javascriptreact',
            'typescript',
            'typescriptreact',
          },
        },
      }

      use_project_language_servers(servers)
      print(vim.inspect(servers))

      mason.setup()

      local servers_to_install = vim.tbl_keys(servers)
      table.sort(servers_to_install)

      mason_lspconfig.setup {
        automatic_installation = true,
        ensure_installed = servers_to_install,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            lspconfig[server_name].setup(server)
          end,
        },
      }
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
