-- Formatting
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
        markdown = { 'mdformat' },
        rust = { 'rustfmt' },
        svg = { 'prettierd' },
        typescript = { 'prettierd' },
        typescriptreact = { 'prettierd' },
      }

      local formatters_to_install = {}
      for _, formatters in pairs(formatters_by_ft) do
        for _, formatter in ipairs(formatters) do
          -- Use system binaries for Rust and Markdown.
          if formatter ~= 'rustfmt' and formatter ~= 'mdformat' then
            formatters_to_install[formatter] = true
          end
        end
      end

      require('mason-tool-installer').setup {
        ensure_installed = vim.tbl_keys(formatters_to_install),
      }

      formatters = {
        mdformat = {
          prepend_args = { '--wrap', '80' },
        },
      }

      return {
        formatters_by_ft = formatters_by_ft,
        formatters = formatters,
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
