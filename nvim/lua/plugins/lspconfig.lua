-- Neovim LSP client configurations for various LSP servers
-- See `:help lspconfig`

local function handle_lsp_attach(event)
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

  local client = vim.lsp.get_client_by_id(event.data.client_id)
  if client and client.server_capabilities.documentHighlightProvider then
    -- Highlight word references upon cursor rest
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      buffer = event.buf,
      callback = vim.lsp.buf.document_highlight,
    })

    -- Clear highlights when cursor moves
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
      buffer = event.buf,
      callback = vim.lsp.buf.clear_references,
    })
  end
end

return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim', -- LSP server management
      'williamboman/mason-lspconfig.nvim', -- Integration between Mason and lspconfig
      'WhoIsSethDaniel/mason-tool-installer.nvim', -- Tool installer for Mason
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = handle_lsp_attach,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      local servers = {
        clangd = {
          cmd = {
            -- ESP-IDF-compliant clangdd binary.
            string.format('%s/espressif/tools/esp-clang/16.0.1-fe4f10a809/esp-clang/bin/clangd', os.getenv 'XDG_DATA_HOME'),
          },
        },
        lua_ls = {
          filetypes = { 'lua' },
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
        prismals = { 'prisma' },
        pyright = { 'python' },
        tailwindcss = { 'css' },
        ts_ls = {
          filetypes = {
            'javascript',
            'javascriptreact',
            'javascript.jsx',
            'typescript',
            'typescriptreact',
            'typescript.tsx',
          },
        },
      }

      require('mason').setup()
      require('mason-tool-installer').setup { ensure_installed = vim.tbl_keys(servers) }
      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
