-- Formatting
-- See `:help conform`

return {
  {
    'stevearc/conform.nvim',
    opts = function()
      -- Find nearest package.json up the tree and check if it defines scripts.format
      local function get_pkg_root_and_has_format(bufnr)
        local fname = vim.api.nvim_buf_get_name(bufnr)
        if fname == '' then
          return nil, false
        end

        local start_dir = vim.fs.dirname(fname)
        local pkg = vim.fs.find('package.json', { path = start_dir, upward = true, type = 'file' })[1]
        if not pkg then
          return nil, false
        end

        local root = vim.fs.dirname(pkg)

        local ok_read, lines = pcall(vim.fn.readfile, pkg)
        if not ok_read then
          return root, false
        end

        local ok_json, obj = pcall(vim.json.decode, table.concat(lines, '\n'))
        if not ok_json or type(obj) ~= 'table' then
          return root, false
        end

        local has_format = type(obj.scripts) == 'table' and type(obj.scripts.format) == 'string'
        return root, has_format
      end

      -- 1) If package.json has scripts.format -> run that (nothing else)
      -- 2) Else -> prettierd
      local function project_or_prettierd(bufnr)
        local _, has_format = get_pkg_root_and_has_format(bufnr)
        if has_format then
          return { 'project_format' }
        end
        return { 'prettierd' }
      end

      local formatters_by_ft = {
        astro = project_or_prettierd,
        c = { 'clang-format' },
        cpp = { 'clang-format' },
        css = project_or_prettierd,
        html = project_or_prettierd,
        htmldjango = { 'djlint' },
        javascript = project_or_prettierd,
        javascriptreact = project_or_prettierd,
        json = project_or_prettierd,
        jsonc = project_or_prettierd,
        lua = { 'stylua' },
        markdown = { 'mdformat' },
        python = { 'isort', 'black' },
        rust = { 'rustfmt' },
        svg = project_or_prettierd,
        typescript = project_or_prettierd,
        typescriptreact = project_or_prettierd,
      }

      local formatters_to_install = {}
      for _, formatters in pairs(formatters_by_ft) do
        if type(formatters) == 'table' then
          for _, formatter in ipairs(formatters) do
            if formatter ~= 'rustfmt' and formatter ~= 'mdformat' then
              formatters_to_install[formatter] = true
            end
          end
        end
      end
      formatters_to_install['prettierd'] = true

      require('mason-tool-installer').setup {
        ensure_installed = vim.tbl_keys(formatters_to_install),
      }

      local formatters = {
        mdformat = {
          prepend_args = { '--wrap', '80' },
        },

        -- Runs the repo's format script if it exists.
        -- Note: we pass $FILENAME so repos can choose to format only that file,
        -- but if their script ignores it and formats everything, that's on the repo.
        project_format = {
          command = 'pnpm',
          args = { 'run', '-s', 'format', '--', '$FILENAME' },
          cwd = function(_, ctx)
            local root = select(1, get_pkg_root_and_has_format(ctx.buf))
            return root
          end,
          stdin = false,
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
