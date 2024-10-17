-- Base16 colorschemes

return {
  {
    'RRethy/base16-nvim',
    lazy = false,
    config = function()
      require('base16-colorscheme').setup {
        base00 = '',
        base01 = '',
        base02 = '',
        base03 = '',
        base04 = '',
        base05 = '',
        base06 = '',
        base07 = '',
        base08 = '',
        base09 = '',
        base0A = '',
        base0B = '',
        base0C = '',
        base0D = '',
        base0E = '',
        base0F = '',
        -- Map Base16 terminal palette
        cterm00 = 0,
        cterm01 = 18,
        cterm02 = 19,
        cterm03 = 8,
        cterm04 = 20,
        cterm05 = 7,
        cterm06 = 21,
        cterm07 = 15,
        cterm08 = 1,
        cterm09 = 16,
        cterm0A = 3,
        cterm0B = 2,
        cterm0C = 6,
        cterm0D = 4,
        cterm0E = 5,
        cterm0F = 17,
      }
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
