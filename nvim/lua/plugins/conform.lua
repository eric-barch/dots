-- Autoformat
-- See `:help conform`

return {
  {
    'stevearc/conform.nvim',
    opts = function()
      local formatters_by_ft = {
        astro = { 'prettierd' },
        c = { 'clang-format' },
        cpp = { 'clang-format' },
        htmldjango = { 'djlint' },
        lua = { 'stylua' },
        python = { 'isort', 'black' },
        html = { 'prettierd' },
        css = { 'prettierd' },
        javascript = { 'prettierd' },
        javascriptreact = { 'prettierd' },
        svg = { 'prettierd' },
        typescript = { 'prettierd' },
        typescriptreact = { 'prettierd' },
      }

      local unique_formatters = {}
      for _, formatters in pairs(formatters_by_ft) do
        for _, formatter in ipairs(formatters) do
          unique_formatters[formatter] = true
        end
      end

      require('mason-tool-installer').setup {
        ensure_installed = vim.tbl_keys(unique_formatters),
      }

      return {
        formatters_by_ft = formatters_by_ft,
        format_on_save = {},
        default_format_opts = {
          lsp_format = 'fallback',
          timeout_ms = 500,
        },
        notify_on_error = true,
        notify_no_formatters = true,
      }
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
