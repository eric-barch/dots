-- Formatting
-- See `:help conform`

return {
  {
    'stevearc/conform.nvim',
    opts = function()
      local formatters_by_ft = {
        astro = { 'prettier_dev_dep' },
        c = { 'clang-format' },
        cpp = { 'clang-format' },
        htmldjango = { 'djlint' },
        json = { 'prettier_dev_dep' },
        jsonc = { 'prettier_dev_dep' },
        lua = { 'stylua' },
        python = { 'isort', 'black' },
        html = { 'prettier_dev_dep' },
        css = { 'prettier_dev_dep' },
        javascript = { 'prettier_dev_dep' },
        javascriptreact = { 'prettier_dev_dep' },
        markdown = { 'mdformat' },
        rust = { 'rustfmt' },
        svg = { 'prettier_dev_dep' },
        typescript = { 'prettier_dev_dep' },
        typescriptreact = { 'prettier_dev_dep' },
      }

      local formatters_to_install = {}
      for _, formatters in pairs(formatters_by_ft) do
        for _, formatter in ipairs(formatters) do
          if formatter ~= 'rustfmt' and formatter ~= 'mdformat' and formatter ~= 'prettier_dev_dep' then
            formatters_to_install[formatter] = true
          end
        end
      end
      formatters_to_install['prettierd'] = true

      require('mason-tool-installer').setup {
        ensure_installed = vim.tbl_keys(formatters_to_install),
      }

      -- Temporary workaround: `prettierd` does not reliably pick up project
      -- Prettier configs when they are defined outside of `.prettierrc` (e.g.
      -- in the newer `prettier.config.ts` or `prettier.config.js`).
      -- TODO: See if I can get newer config files to work with `prettierd`.
      local function find_prettier_dev_dep(bufnr)
        local fname = vim.api.nvim_buf_get_name(bufnr)
        if fname == '' then
          return nil
        end

        local start_dir = vim.fs.dirname(fname)
        local match = vim.fs.find('node_modules/.bin/prettier', {
          path = start_dir,
          upward = true,
          type = 'file',
        })[1]

        return match
      end

      local formatters = {
        mdformat = {
          prepend_args = { '--wrap', '80' },
        },

        prettier_dev_dep = {
          command = function(_, ctx)
            return find_prettier_dev_dep(ctx.buf) or 'prettierd'
          end,
          args = { '--stdin-filepath', '$FILENAME' },
          stdin = true,
        },
      }

      return {
        formatters_by_ft = formatters_by_ft,
        formatters = formatters,
        format_on_save = {
          async = true,
          timeout_ms = 10000,
        },
        -- log_level = vim.log.levels.DEBUG,
        notify_on_error = true,
        notify_no_formatters = true,
      }
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
