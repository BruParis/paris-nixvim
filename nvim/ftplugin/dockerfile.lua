-- Exit if the Docker LSP server isn't available
if vim.fn.executable("docker-langserver") ~= 1 then
  return
end

-- Start the Docker LSP server
vim.lsp.start {
  name = "dockerls",
  cmd = { "docker-langserver", "--stdio" },
  root_dir = vim.fs.dirname(vim.fs.find({ ".git" }, { upward = true })[1]),
  capabilities = require("user.lsp").make_client_capabilities(),
}
