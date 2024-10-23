-- Exit if the language server isn't available
if vim.fn.executable('texlab') ~= 1 then
  return
end

local root_files = {
  'main.tex',
  '.git',
}

vim.lsp.start {
  name = 'texlab_ls',
  cmd = { 'texlab' },
  root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
  capabilities = require('user.lsp').make_client_capabilities(),
}

-- Additional settings for VimTeX
vim.g.vimtex_view_method = 'zathura'  -- Example PDF viewer setting for VimTeX
vim.g.vimtex_compiler_method = 'latexmk'  -- Example compiler setting for VimTeX

