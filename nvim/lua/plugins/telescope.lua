-- Fuzzy finder.
-- See `:help telescope`.
return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',

        -- Runs only on install and update, not every time nvim starts.
        build = 'make',

        -- Used to determine whether this plugin should be installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      'nvim-telescope/telescope-ui-select.nvim',
      'nvim-telescope/telescope-file-browser.nvim',
      {
        -- Pretty icons. Requires a Nerd Font.
        'nvim-tree/nvim-web-devicons',
        enabled = vim.g.have_nerd_font,
      },
    },
    config = function()
      -- [[ Configure Telescope ]]
      -- See `:help telescope.setup()`
      require('telescope').setup {
        defaults = {
          layout_strategy = 'horizontal',
          layout_config = {
            horizontal = {
              prompt_position = 'top',
              preview_width = 0.5,
            },
          },
          sorting_strategy = 'ascending',
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
          file_browser = {
            cwd_to_path = true,
            grouped = true,
            hijack_netrw = true,
            hidden = true,
            respect_gitignore = false,
          },
        },
        pickers = {
          buffers = {
            mappings = {
              n = {
                ['x'] = function(prompt_bufnr)
                  require('telescope.actions').delete_buffer(prompt_bufnr)
                end,
              },
            },
          },
          planets = {
            show_pluto = true,
            show_moon = true,
          },
          colorscheme = {
            enable_preview = true,
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
      pcall(require('telescope').load_extension, 'file_browser')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'

      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Search in current buffer' })

      vim.keymap.set('n', '<leader>so', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Search in open files',
        }
      end, { desc = 'Search in [o]pen files' })

      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = 'Search for [n]eovim files' })

      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = 'Search [h]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = 'Search for [k]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = 'Search for [f]iles' })
      vim.keymap.set('n', '<leader>st', builtin.builtin, { desc = 'Search for [t]elescope pickers' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = 'Search for current [w]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = 'Search in all files ([g]rep)' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = 'Search in [d]iagnostics' })
      vim.keymap.set('n', '<leader>sc', builtin.resume, { desc = 'Search [c]ontinue' })
      vim.keymap.set('n', '<leader>sr', builtin.oldfiles, { desc = 'Search for [r]ecent files' })
      vim.keymap.set('n', '<leader>bb', builtin.buffers, { desc = 'Browse [b]uffers' })

      vim.keymap.set('n', '<leader>bf', function()
        require('telescope').extensions.file_browser.file_browser {
          path = '%:p:h',
          select_buffer = true,
        }
      end, { desc = 'Browse [f]iles' })
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
