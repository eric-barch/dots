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
  local in_project = load_project_config()

  if not in_project or not vim.g.project or not vim.g.project.lsp then
    return default_servers
  end

  local lsp = vim.g.project.lsp

  if type(lsp) == 'table' then
    return lsp
  end
  return { lsp }
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
          automatic_enable = true,
        }
      end

      -- Defer so we can load .nvim.lua from project root (buffer path or cwd)
      vim.api.nvim_create_autocmd('VimEnter', {
        once = true,
        callback = set_up_lsp,
      })
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
