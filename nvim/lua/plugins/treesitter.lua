-- Highlight, edit, and navigate code.
-- See `:help treesitter` and `:help lsp-vs-treesitter`.

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'cpp',
        'javascript',
        'lua',
        'prisma',
        'python',
        'typescript',
      },
      auto_install = true,
      highlight = {
        enable = true,
      },
      indent = { enable = true },
    },
  },
}

-- vim: ts=2 sts=2 sw=2 et
