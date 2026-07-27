if vim.g.did_load_treesitter_plugin then
  return
end
vim.g.did_load_treesitter_plugin = true

-- nvim-treesitter's `main` branch is a full, incompatible rewrite: no more
-- `nvim-treesitter.configs`, no `highlight`/`textobjects` config tables.
-- Parsers are already installed on the runtimepath via Nix, so no
-- `require('nvim-treesitter').setup { install_dir = ... }` is needed here.
vim.g.skip_ts_context_commentstring_module = true

-- Highlighting is no longer managed by this plugin; Neovim's native
-- treesitter highlighter is started per-buffer (see :h treesitter-highlight).
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local max_filesize = 100 * 1024 -- 100 KiB
    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
    if ok and stats and stats.size > max_filesize then
      return
    end
    pcall(vim.treesitter.start, args.buf)
  end,
})

local textobjects = require('nvim-treesitter-textobjects')

textobjects.setup {
  select = {
    -- Automatically jump forward to textobject, similar to targets.vim
    lookahead = true,
    selection_modes = {
      ['@parameter.outer'] = 'v', -- charwise
      ['@function.outer'] = 'V', -- linewise
      ['@class.outer'] = '<c-v>', -- blockwise
    },
  },
  move = {
    set_jumps = true, -- whether to set jumps in the jumplist
  },
}

local function select_textobject(query)
  return function()
    require('nvim-treesitter-textobjects.select').select_textobject(query, 'textobjects')
  end
end

local select_keymaps = {
  ['af'] = '@function.outer',
  ['if'] = '@function.inner',
  ['ac'] = '@class.outer',
  ['ic'] = '@class.inner',
  ['aC'] = '@call.outer',
  ['iC'] = '@call.inner',
  ['a#'] = '@comment.outer',
  ['i#'] = '@comment.outer',
  ['ai'] = '@conditional.outer',
  ['ii'] = '@conditional.outer',
  ['al'] = '@loop.outer',
  ['il'] = '@loop.inner',
  ['aP'] = '@parameter.outer',
  ['iP'] = '@parameter.inner',
}
for lhs, query in pairs(select_keymaps) do
  vim.keymap.set({ 'x', 'o' }, lhs, select_textobject(query))
end

local swap = require('nvim-treesitter-textobjects.swap')
vim.keymap.set('n', '<leader>a', function()
  swap.swap_next '@parameter.inner'
end)
vim.keymap.set('n', '<leader>A', function()
  swap.swap_previous '@parameter.inner'
end)

local move = require('nvim-treesitter-textobjects.move')
local function goto_textobject(fn, query)
  return function()
    fn(query, 'textobjects')
  end
end

vim.keymap.set({ 'n', 'x', 'o' }, ']m', goto_textobject(move.goto_next_start, '@function.outer'))
vim.keymap.set({ 'n', 'x', 'o' }, ']P', goto_textobject(move.goto_next_start, '@parameter.outer'))
vim.keymap.set({ 'n', 'x', 'o' }, ']M', goto_textobject(move.goto_next_end, '@function.outer'))
vim.keymap.set({ 'n', 'x', 'o' }, '[m', goto_textobject(move.goto_previous_start, '@function.outer'))
vim.keymap.set({ 'n', 'x', 'o' }, '[P', goto_textobject(move.goto_previous_start, '@parameter.outer'))
vim.keymap.set({ 'n', 'x', 'o' }, '[M', goto_textobject(move.goto_previous_end, '@function.outer'))

require('treesitter-context').setup {
  max_lines = 3,
}

require('ts_context_commentstring').setup()

-- Tree-sitter based folding
-- vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
