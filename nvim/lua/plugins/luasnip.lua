-- Snippet engine
-- See `:help luasnip-basics`

return {
  {
    'L3MON4D3/LuaSnip', -- Snippet engine and associated nvim-cmp source
    build = (function() -- Build step required for regex support in snippets
      return 'make install_jsregexp'
    end)(),
    dependencies = {
      'rafamadriz/friendly-snippets', -- Premade snippets
      config = function()
        require('luasnip.loaders.from_vscode').lazy_load()
      end,
    },
  },
}

-- vim: ts=2 sts=2 sw=2 et
