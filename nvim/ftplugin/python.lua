-- Exit if the Python LSP server isn't available
if vim.fn.executable('pylsp') ~= 1 then
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

-- Start the Python LSP server
vim.lsp.start {
  name = 'pylsp',
  cmd = { 'pylsp' },
  root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
  capabilities = require('user.lsp').make_client_capabilities(),
}
