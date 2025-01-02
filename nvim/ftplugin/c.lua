-- Exit if the clangd LSP server isn't available
if vim.fn.executable('clangd') ~= 1 then
  return
end

-- List of files that define the root directory of a C++ project
local root_files = {
  'compile_commands.json',
  'Makefile',
  '.git',
}

-- Start the C++ LSP server
vim.lsp.start {
  name = 'clangd',
  cmd = { 'clangd' },
  root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
  capabilities = require('user.lsp').make_client_capabilities(),
}
