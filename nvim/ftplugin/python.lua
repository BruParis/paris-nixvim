-- Exit if the Python LSP server isn't available
if vim.fn.executable('pylsp') ~= 1 then
  vim.notify("pylsp not found!", vim.log.levels.WARN, { title = "Nvim-config" })
  return
end

-- List of files that define the root directory of a Python project
local root_files = {
  'pyproject.toml',
  'setup.py',
  'setup.cfg',
  'requirements.txt',
  '.git',
}

-- vim.lsp.set_log_level("debug")

local venv_path = os.getenv("VIRTUAL_ENV")
local py_path = nil
if venv_path then
  py_path = venv_path .. '/bin/python'
else
  py_path = vim.fn.exepath('python3') or vim.fn.exepath('python')
end

-- Start the Python LSP server
vim.lsp.start {
  name = 'pylsp',
  cmd = { 'pylsp' },
  root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
  capabilities = require('user.lsp').make_client_capabilities(),
  settings = {
    pylsp = {
      plugins = {
        -- formatter options
        black = { enabled = true },
        autopep8 = { enabled = false },
        yapf = { enabled = false },
        -- linter options
        pylint = { enabled = true, executable = "pylint" },
        ruff = { enabled = false },
        pyflakes = { enabled = false },
        pycodestyle = { enabled = false },
        -- type checker
        pylsp_mypy = {
          enabled = true,
          overrides = { "--python-executable", py_path, true },
          report_progress = true,
          live_mode = false
        },
        -- auto-completion options
        jedi_completion = { fuzzy = true },
        -- import sorting
        isort = { enabled = true },
      }
    }
  }
}
