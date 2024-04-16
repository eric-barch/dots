-- Highlight, edit, and navigate code
-- See `:help treesitter` and `:help lsp-vs-treesitter`
return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      ensure_installed = { 'bash', 'c', 'cpp', 'javascript', 'lua', 'prisma', 'python', 'typescript', 'vim', 'vimdoc' },
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as
        -- Ruby) for indent rules. To troubleshoot weird indenting issues, add
        -- the language to additional_vim_regex_highlighting and indent disabled
        -- languages.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    config = function(_, opts)
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup(opts)

      -- NOTE: Check out these treesitter modules:
      -- Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      -- Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      -- Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
