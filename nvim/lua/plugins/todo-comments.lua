-- Highlight todo, notes, etc in comments.
-- See `:help todo`.
return {
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    opts = {
      signs = false,
    },
  },
}

-- vim: ts=2 sts=2 sw=2 et
