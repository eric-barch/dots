-- Highlight, edit, and navigate code.
-- See `:help treesitter` and `:help lsp-vs-treesitter`.

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').install {
        'bash',
        'c',
        'cpp',
        'javascript',
        'lua',
        'prisma',
        'python',
        'typescript',
        'yaml',
      }

      vim.api.nvim_create_autocmd('FileType', {
        desc = 'Start Tree-sitter highlighting and indent',
        callback = function(args)
          if pcall(vim.treesitter.start, args.buf) then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
