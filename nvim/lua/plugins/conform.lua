-- Formatting
-- See `:help conform`

local project = require 'utils.project'

local default_formatters = {
  css = { 'prettierd' },
  html = { 'prettierd' },
  javascript = { 'prettierd' },
  javascriptreact = { 'prettierd' },
  json = { 'prettierd' },
  jsonc = { 'prettierd' },
  lua = { 'stylua' },
  markdown = { 'mdformat' },
  python = { 'ruff_fix', 'ruff_format', 'ruff_organize_imports' },
  rust = { 'rustfmt' },
  svg = { 'prettierd' },
  typescript = { 'prettierd' },
  typescriptreact = { 'prettierd' },
}

local function get_formatters()
  project.load_config()

  if vim.g.project and vim.g.project.format then
    local formatters = vim.g.project.format

    if type(formatters) == 'table' then
      return formatters
    end
  end

  return default_formatters
end

return {
  {
    'stevearc/conform.nvim',
    dependencies = {
      'williamboman/mason.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
    },
    opts = function()
      local formatters_by_ft = get_formatters()

      local formatters_to_install = {}
      for _, formatters in pairs(formatters_by_ft) do
        for _, formatter in ipairs(formatters) do
          -- Map conform formatter names to Mason package names
          local mason_name = formatter:gsub('^ruff_.*', 'ruff')
          if mason_name ~= 'rustfmt' and mason_name ~= 'mdformat' then
            formatters_to_install[mason_name] = true
          end
        end
      end

      require('mason').setup()
      require('mason-tool-installer').setup {
        ensure_installed = vim.tbl_keys(formatters_to_install),
      }

      return {
        formatters_by_ft = formatters_by_ft,
        formatters = {
          mdformat = {
            prepend_args = { '--wrap', '80' },
          },
        },
        format_after_save = {
          async = true,
          timeout_ms = 10000,
        },
        notify_on_error = true,
        notify_no_formatters = true,
      }
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
