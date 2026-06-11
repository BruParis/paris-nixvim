if vim.fn.executable('pylsp') ~= 1 then
  vim.notify('pylsp not found!', vim.log.levels.WARN, { title = 'Nvim-config' })
  return
end

local venv_path = os.getenv('VIRTUAL_ENV')
local py_path = venv_path and (venv_path .. '/bin/python') or vim.fn.exepath('python3') or vim.fn.exepath('python')

-- To override settings for a specific project, add a .nvim.lua at the project root:
--
--   vim.lsp.config('pylsp', {
--     settings = { pylsp = { plugins = { isort = { enabled = false } } } }
--   })
--
vim.lsp.config('pylsp', {
  cmd = { 'pylsp' },
  root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' },
  capabilities = require('user.lsp').make_client_capabilities(),
  settings = {
    pylsp = {
      plugins = {
        black = { enabled = true },
        autopep8 = { enabled = false },
        yapf = { enabled = false },
        pylint = { enabled = true, executable = 'pylint' },
        ruff = { enabled = false },
        pyflakes = { enabled = false },
        pycodestyle = { enabled = false },
        pylsp_mypy = {
          enabled = true,
          dmypy = true,
          dmypy_status_file = '.dmypy.json',
          overrides = { '--python-executable', py_path, true },
          report_progress = true,
          live_mode = false,
        },
        jedi_completion = { fuzzy = true },
        isort = { enabled = true },
      },
    },
  },
})

-- TODO: migrate other ftplugin/*.lua files from vim.lsp.start to vim.lsp.config + vim.lsp.enable
--       so that per-project .nvim.lua overrides work for all language servers, not just pylsp.
