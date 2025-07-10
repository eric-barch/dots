-- Color highlighter
-- See `:help colorizer`

return {
  'catgoose/nvim-colorizer.lua',
  event = 'BufReadPre',
  opts = {
    user_default_options = {
      names = false,
    },
  },
}

-- vim: ts=2 sts=2 sw=2 et
