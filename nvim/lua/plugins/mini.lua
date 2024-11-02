-- Collection of small plugins
-- See `:help mini.nvim`

return {
  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }

      require('mini.surround').setup()

      require('mini.statusline').setup {
        content = {
          active = function()
            local mode, mode_hl = require('mini.statusline').section_mode {
              trunc_width = 120,
            }
            local filename = require('mini.statusline').section_filename {
              trunc_width = 140,
            }
            local search = require('mini.statusline').section_searchcount {
              trunc_width = 75,
            }
            local location = '%2l:%-2v' -- Define location directly here

            return require('mini.statusline').combine_groups {
              { hl = mode_hl, strings = { mode } },
              '%<', -- Mark truncate point
              { hl = 'statuslineFilename', strings = { filename } },
              '%=', -- End left alignment
              { hl = mode_hl, strings = { search, location } },
            }
          end,
          inactive = function()
            return require('mini.statusline').section_filename {
              trunc_width = 140,
            }
          end,
        },
        use_icons = vim.g.have_nerd_font,
      }
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
