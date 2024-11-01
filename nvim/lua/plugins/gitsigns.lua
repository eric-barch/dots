-- Git signs in the gutter
-- See `:help gitsigns`

return {
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '▌' },
        change = { text = '▌' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '▌' },
        untracked = { text = '▌' },
      },
      signs_staged = {
        add = { text = '▐' },
        change = { text = '▐' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '▐' },
        untracked = { text = '▐' },
      },
      signs_staged_enable = true,
      signcolumn = true,
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol',
        delay = 300,
        ignore_whitespace = false,
        virt_text_priority = 100,
        use_focus = true,
      },
      current_line_blame_formatter = '   <author>, <author_time:%R> - <summary>',
      current_line_blame_formatter_nc = '   Not committed',
    },
  },
}

-- vim: ts=2 sts=2 sw=2 et
