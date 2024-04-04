-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`

require('telescope').setup {
  extensions = {
    file_browser = {
      hijack_netrw = true,
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
  },
}

-- Enable telescope fzf native
require('telescope').load_extension 'fzf'

-- Enable file browser
require('telescope').load_extension 'file_browser'

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
  -- Use the current buffer's path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  -- If the buffer is not associated with a file, return nil
  if current_file == '' then
    current_dir = cwd
  else
    -- Extract the directory from the current file's path
    current_dir = vim.fn.fnamemodify(current_file, ':h')
  end

  -- Find the Git root directory from the current file's path
  local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
  if vim.v.shell_error ~= 0 then
    print 'Not a git repository. Searching on current working directory'
    return cwd
  end
  return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    require('telescope.builtin').live_grep {
      search_dirs = { git_root },
    }
  end
end

vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>/', function()
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = 'Fuzzily [/] search current buffer' })

vim.keymap.set('n', '<leader>/f', function()
  require('telescope.builtin').live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end, { desc = 'Fuzzily [/] search open [f]iles' })

vim.keymap.set('n', '<leader>f', function()
  require('telescope').extensions.file_browser.file_browser {
    path = '%:p:h',
    select_buffer = true,
  }
end, { desc = 'Browse [f]iles' })

vim.keymap.set('n', '<leader>b', require('telescope.builtin').buffers, { desc = 'Browse open [b]uffers' })
vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [g]it [f]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [f]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [h]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [w]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [g]rep' })
vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by grep on [G]it Root' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [d]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [r]esume' })

-- vim: ts=2 sts=2 sw=2 et
