-- Automatically close brackets, quotes, etc.
-- See `:help autopairs`

return {
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {},
  },
}

-- vim: ts=2 sts=2 sw=2 et
