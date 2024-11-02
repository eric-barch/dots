-- Pass linter output to `vim.diagnostic` module
-- See `:help lint`

return {
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
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

      -- So disable the unwanted ones by setting filetypes to nil:
      lint.linters_by_ft['clojure'] = nil
      lint.linters_by_ft['inko'] = nil
      lint.linters_by_ft['janet'] = nil
      lint.linters_by_ft['markdown'] = nil
      lint.linters_by_ft['rst'] = nil
      lint.linters_by_ft['ruby'] = nil
      lint.linters_by_ft['terraform'] = nil

      -- TODO: Make sure necessary tools are installed using mason tools installer

      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          require('lint').try_lint()
        end,
      })
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
