-- LSP
-- See `:help lsp` and `:help lsp-vs-treesitter`.
return {
  {
    -- Configs for the nvim LSP client.
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Language server manager.
      'williamboman/mason.nvim',

      -- Bridge between mason.nvim and nvim-lspconfig.
      'williamboman/mason-lspconfig.nvim',

      -- Use Mason to keep third party tools up to date.
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- Configure LSP for nvim config, runtime and plugins.
      -- Used for completion, annotations and signatures of nvim APIs.
      { 'folke/neodev.nvim', opts = {} },
    },
    config = function()
      --  Runs when an LSP attaches to a buffer.
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- Helper function to define LSP-specific keymaps in normal mode.
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('gd', require('telescope.builtin').lsp_definitions, 'Go to [d]efinition')
          map('gD', vim.lsp.buf.declaration, 'Go to [D]eclaration')
          map('gr', require('telescope.builtin').lsp_references, 'Go to [r]eferences')
          map('gI', require('telescope.builtin').lsp_implementations, 'Go to [I]mplementation')
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Go to type [D]efinition')
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[d]ocument [s]ymbols')
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[w]orkspace [s]ymbols')
          map('<leader>rn', vim.lsp.buf.rename, '[r]e[n]ame')
          -- Execute a code action. Usually requires cursor to be on top of an
          -- error or LSP suggestion.
          map('<leader>ca', vim.lsp.buf.code_action, '[c]ode [a]ction')
          -- Display documentation about the word under the cursor.
          -- See `:help K`.
          map('K', vim.lsp.buf.hover, 'Hover Documentation')

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            -- Highlight word references upon cursor rest.
            -- See `:help CursorHold`.
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })

            -- Clear highlights when cursor moves.
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      --  Broadcast new, non-default nvim capabilities to language servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- Define servers table.
      local servers = {
        -- See `:help lspconfig-all` for a list of all the pre-configured LSPs.
        html = {},
        lua_ls = {
          -- cmd = {...},
          -- filetypes = {...},
          -- capabilities = {...},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- Toggle below to ignore lua_ls's noisy `missing-fields` warnings.
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
        prismals = {},
        -- NOTE: Try https://github.com/pmizio/typescript-tools.nvim
        tsserver = {
          filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx' },
        },
      }

      -- Ensure the servers and tools above are installed.
      -- To check status or install manually: `:Mason`.
      require('mason').setup()

      local ensure_installed = vim.tbl_keys(servers or {})

      vim.list_extend(ensure_installed, {
        -- Formats Lua.
        'stylua',
      })

      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- Override values explicitly passed by the server configuration
            -- above. Useful to disable certain LSP features (e.g. to turn off
            -- tsserver formatting).
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
