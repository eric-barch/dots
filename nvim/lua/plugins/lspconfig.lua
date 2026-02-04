-- Neovim LSP client configurations for various LSP servers
-- See `:help lspconfig`

local default_servers = {
  'clangd',
  'lua_ls',
  'prismals',
  'pyright',
  'rust_analyzer',
  'tailwindcss',
  'ts_ls',
  'ty',
}

local function load_project_config()
  local start_dir = vim.fn.getcwd()
  local buf = vim.api.nvim_get_current_buf()
  local fname = vim.api.nvim_buf_get_name(buf)
  if fname and fname ~= '' then
    start_dir = vim.fs.dirname(fname)
  end

  local found = vim.fs.find('.nvim.lua', { path = start_dir, upward = true, type = 'file' })[1]

  if found then
    pcall(vim.cmd.source, found)
    return true
  end
  return false
end

local function get_servers()
  -- Use vim.g.project if exrc already set it (e.g. opened from project root)
  if vim.g.project and vim.g.project.lsp then
    local lsp = vim.g.project.lsp
    return type(lsp) == 'table' and lsp or { lsp }
  end
  -- Otherwise find .nvim.lua from buffer path or cwd
  load_project_config()
  if vim.g.project and vim.g.project.lsp then
    local lsp = vim.g.project.lsp
    return type(lsp) == 'table' and lsp or { lsp }
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

      local function set_up_lsp()
        local servers = get_servers()

        require('mason-lspconfig').setup {
          automatic_installation = true,
          ensure_installed = servers,
          automatic_enable = false,
        }

        for _, server in ipairs(servers) do
          vim.lsp.enable(server)
        end
      end

      -- Defer so exrc can run first when opening from project root (cwd);
      -- then we use vim.g.project from exrc or load from buffer path/cwd.
      vim.api.nvim_create_autocmd('VimEnter', {
        once = true,
        callback = function()
          vim.schedule(set_up_lsp)
        end,
      })
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
