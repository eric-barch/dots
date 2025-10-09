-- Linting
-- See `:help lint`

return {
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      -- Allow other plugins to add linters to require('lint').linters_by_ft
      lint.linters_by_ft = lint.linters_by_ft or {}

      -- This enables a set of default linters, which will cause errors unless
      -- these tools are available:
      -- {
      --   clojure = { "clj-kondo" },
      --   dockerfile = { "hadolint" },
      --   inko = { "inko" },
      --   janet = { "janet" },
      --   json = { "jsonlint" },
      --   markdown = { "vale" },
      --   rst = { "vale" },
      --   ruby = { "ruby" },
      --   terraform = { "tflint" },
      --   text = { "vale" }
      -- }

      -- So disable or change as necessary:
      lint.linters_by_ft['clojure'] = nil
      lint.linters_by_ft['inko'] = nil
      lint.linters_by_ft['janet'] = nil
      lint.linters_by_ft['markdown'] = { 'markdownlint' }
      lint.linters_by_ft['rst'] = nil
      lint.linters_by_ft['ruby'] = nil
      lint.linters_by_ft['terraform'] = nil

      local linters_to_install = {}
      for _, linters in pairs(lint.linters_by_ft) do
        for _, linter in ipairs(linters) do
          linters_to_install[linter] = true
        end
      end

      require('mason-tool-installer').setup {
        ensure_installed = vim.tbl_keys(linters_to_install),
      }

      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufWritePost', 'InsertLeave', 'TextChanged' }, {
        group = lint_augroup,
        callback = function()
          require('lint').try_lint()
        end,
      })
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
