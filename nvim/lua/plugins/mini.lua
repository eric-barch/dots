-- Collection of small, independent plugins.
-- See `:help mini.nvim`.
return {
  {
    'echasnovski/mini.nvim',
    config = function()
      -- Better navigation around and inside textobjects, e.g.:
      -- va)  - [v]isually select [a]round [)]paren.
      -- yin' - [y]ank [i]nside [n]ext [']quote.
      -- ci'  - [c]hange [i]nside [']quote.
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings, e.g.:
      -- saiw) - [s]urround [a]dd [i]nner [w]ord [)]paren.
      -- sd'   - [s]urround [d]elete [']quotes.
      -- sr)'  - [s]urround [r]eplace [)] ['].
      require('mini.surround').setup()

      local statusline = require 'mini.statusline'
      statusline.setup {
        content = {
          active = function()
            local mode, mode_hl = statusline.section_mode { trunc_width = 120 }
            local filename = statusline.section_filename { trunc_width = 140 }
            local search = statusline.section_searchcount { trunc_width = 75 }
            local location = statusline.section_location()

            return statusline.combine_groups {
              { hl = mode_hl, strings = { mode } },
              '%<', -- Mark truncate point
              { hl = 'statuslineFilename', strings = { filename } },
              '%=', -- End left alignment
              { hl = mode_hl, strings = { search, location } },
            }
          end,
          inactive = function()
            return statusline.section_filename { trunc_width = 140 }
          end,
        },
        use_icons = vim.g.have_nerd_font,
      }

      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      require('mini.hipatterns').setup {
        highlighters = {
          hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
        },
      }
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
