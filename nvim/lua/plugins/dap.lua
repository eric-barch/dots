-- DAP client
-- See `:help nvim-dap`

return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui', -- Debugger UI
      'nvim-neotest/nvim-nio', -- Async I/O library, required for nvim-dap-ui
      'mxsdev/nvim-dap-vscode-js', -- Microsoft JavaScript debugger adapter
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'
      local vscode = require 'dap.ext.vscode'

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      vim.keymap.set('n', '<leader>dc', dap.continue, { desc = 'Debug: Start/Continue' })
      vim.keymap.set('n', '<leader>dv', dap.step_over, { desc = 'Debug: Step Over' })
      vim.keymap.set('n', '<leader>di', dap.step_into, { desc = 'Debug: Step Into' })
      vim.keymap.set('n', '<leader>du', dap.step_out, { desc = 'Debug: Step Out' })
      vim.keymap.set('n', '<leader>dt', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })

      dapui.setup {
        icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
        controls = {
          icons = {
            pause = '⏸',
            play = '▶',
            step_into = '⏎',
            step_over = '⏭',
            step_out = '⏮',
            step_back = 'b',
            run_last = '▶▶',
            terminate = '⏹',
            disconnect = '⏏',
          },
        },
      }

      require('dap-vscode-js').setup {
        debugger_path = '/Users/ericbarch/.local/share/nvim/vscode-js-debug',
        adapters = { 'pwa-node', 'pwa-chrome' },
      }

      local js_based_languages = { 'typescript', 'javascript' }

      -- Preset debug configurations for very simple projects. In practice,
      -- usually use project-specific configuration at `.vscode/launch.json`.
      for _, language in ipairs(js_based_languages) do
        dap.configurations[language] = {
          {
            type = 'pwa-node',
            request = 'launch',
            name = 'Launch file',
            program = '${file}',
            cwd = '${workspaceFolder}',
          },
          {
            type = 'pwa-node',
            request = 'attach',
            name = 'Attach',
            processId = require('dap.utils').pick_process,
            cwd = '${workspaceFolder}',
          },
        }
      end

      vscode.load_launchjs(vim.fn.getcwd() .. '/launch.json', {
        ['pwa-node'] = { 'typescript', 'javascript' },
      })
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
