-- null-ls (none-ls) provides formatting/linting for languages without native LSP support.
--
-- When to use null-ls:
--   - The language's LSP doesn't support formatting (use null_ls.builtins.formatting.*)
--   - You need additional linters beyond what the LSP provides (use null_ls.builtins.diagnostics.*)
--   - You want code actions from external tools (use null_ls.builtins.code_actions.*)
--
-- When NOT to use null-ls:
--   - The LSP already handles formatting (e.g., pylsp with python-lsp-black, rust-analyzer)
--
-- Available builtins: https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md
-- Remember to add the formatter/linter to extraPackages in nix/neovim-overlay.nix

local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    -- Example: null_ls.builtins.formatting.prettier,
    -- Example: null_ls.builtins.diagnostics.eslint,
  },
})
