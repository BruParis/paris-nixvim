-- nvim/plugins/null-ls.lua
local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    -- Python formatter
    null_ls.builtins.formatting.black,

    -- Javascript, Typescript, ... formatter
    null_ls.builtins.formatting.prettier.with({
      extra_filetypes = { "json", "yaml", "markdown" },
    }),
  },
})
