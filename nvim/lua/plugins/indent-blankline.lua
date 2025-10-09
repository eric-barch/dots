-- Indentation guidelines
-- See `:help ibl`

return {
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {
      indent = {
        char = '▏',
      },
    },
  },
}

-- vim: ts=2 sts=2 sw=2 et
