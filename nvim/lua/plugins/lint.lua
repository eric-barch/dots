-- Linting
-- See `:help lint`

local project = require 'utils.project'

local default_linters = {
  javascript = { 'eslint_d' },
  javascriptreact = { 'eslint_d' },
  json = { 'jsonlint' },
  markdown = { 'markdownlint' },
  typescript = { 'eslint_d' },
  typescriptreact = { 'eslint_d' },
}

local function get_linters()
  project.load_config()

  if vim.g.project and vim.g.project.lint then
    local linters = vim.g.project.lint

    if type(linters) == 'table' then
      return linters
    end

    return { linters }
  end

  return default_linters
end

return {
  {
    'mfussenegger/nvim-lint',
    dependencies = {
      'williamboman/mason.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
    },
    config = function()
      require('mason').setup()

      local lint = require 'lint'
      lint.linters_by_ft = get_linters()

      local linters_to_install = {}
      for _, linters in pairs(lint.linters_by_ft) do
        for _, linter in ipairs(linters) do
          linters_to_install[linter] = true
        end
      end

      require('mason-tool-installer').setup {
        ensure_installed = vim.tbl_keys(linters_to_install),
      }

      local nvim_lint_augroup = vim.api.nvim_create_augroup('nvim-lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufWritePost', 'InsertLeave' }, {
        group = nvim_lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
