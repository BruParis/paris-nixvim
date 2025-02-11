 -- Exit if the rust-analyzer LSP server isn't available
if vim.fn.executable('rust-analyzer') ~= 1 then
  return
end

-- List of files that define the root directory of a Rust project
local root_files = {
  'Cargo.toml',
  '.git',
}

-- Start the Rust LSP server
vim.lsp.start {
  name = 'rust-analyzer',
  cmd = { 'rust-analyzer' },
  root_dir = vim.fn.getcwd(),
  capabilities = require('user.lsp').make_client_capabilities(),
}
