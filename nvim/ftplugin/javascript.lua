-- Exit if the javascript-typescript-langserver LSP server isn't available
if vim.fn.executable('typescript-language-server') ~= 1 then
  return
end

-- List of files that define the root directory of a JavaScript project
local root_files = {
  'package.json',
  '.git',
  -- You can add other root files specific to JavaScript projects if needed
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

-- Start the Typescript LSP server
-- (since any javascript is valid typescript)
vim.lsp.start({
  name = 'tsserver',
  cmd = { 'typescript-language-server', '--stdio' },
  root_dir = get_root_dir(),
  capabilities = require('user.lsp').make_client_capabilities(),
})


