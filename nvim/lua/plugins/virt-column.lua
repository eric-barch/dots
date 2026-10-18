-- Vertical line at the formatter's line length
-- See `:help virt-column`

-- Columns for filetypes whose formatter doesn't wrap at 80
local widths_by_filetype = {
  gitcommit = '72', -- Commit message body convention
  lua = '120', -- stylua default
  python = '88', -- ruff default
  rust = '100', -- rustfmt default
}

return {
  {
    'lukas-reineke/virt-column.nvim',
    opts = {
      char = '▏',
      virtcolumn = '80',
    },
    config = function(_, opts)
      local virt_column = require 'virt-column'
      virt_column.setup(opts)

      vim.api.nvim_create_autocmd('FileType', {
        desc = 'Set virtual column per filetype',
        pattern = vim.tbl_keys(widths_by_filetype),
        callback = function(args)
          virt_column.setup_buffer(args.buf, { virtcolumn = widths_by_filetype[args.match] })
        end,
      })
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
