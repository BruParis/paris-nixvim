-- Exit if the typescript-language-server LSP server isn't available
if vim.fn.executable('typescript-language-server') ~= 1 then
  return
end

-- List of files that define the root directory of a TypeScript project
local root_files = {
  'tsconfig.json',
  'package.json',
  '.git',
}

-- Function to find the root directory of the project
local function get_root_dir()
  local cwd = vim.fn.getcwd()
  for _, root_file in ipairs(root_files) do
    if vim.fn.filereadable(cwd .. '/' .. root_file) == 1 then
      return cwd
    end
  end
  return nil
end

-- Start the TypeScript LSP server
vim.lsp.start({
  name = 'tsserver',
  cmd = { 'typescript-language-server', '--stdio' },
  root_dir = get_root_dir(),
  capabilities = require('user.lsp').make_client_capabilities(),
})

