-- Autoformat
-- See `:help conform`

return {
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        astro = { 'prettierd' },
        c = { 'clang-format' },
        cpp = { 'clang-format' },
        lua = { 'stylua' },
        python = {
          'isort',
          'black',
        },
        html = { 'prettierd' },
        css = { 'prettierd' },
        javascript = { 'prettierd' },
        javascriptreact = { 'prettierd' },
        typescript = { 'prettierd' },
        typescriptreact = { 'prettierd' },
      },
      format_on_save = {
        lsp_format = 'fallback',
        timeout_ms = 500,
      },
      default_format_opts = {
        lsp_format = 'fallback',
        timeout_ms = 500,
      },
      notify_on_error = true,
      notify_no_formatters = true,
    },
  },
}

-- vim: ts=2 sts=2 sw=2 et
