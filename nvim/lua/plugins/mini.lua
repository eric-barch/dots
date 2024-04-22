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

      -- Simple, easy statusline.
      -- TODO: Try other statusline plugins.
      local statusline = require 'mini.statusline'

      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- Configure statusline by overriding default section behavior,
      -- e.g. set the section for cursor location to LINE:COLUMN.
      -- More: https://github.com/echasnovski/mini.nvim
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
