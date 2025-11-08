return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-mini/mini.icons',
    },
    opts = {
      heading = {
        position = 'inline',
        sign = false,
      },
    },
  },
}
