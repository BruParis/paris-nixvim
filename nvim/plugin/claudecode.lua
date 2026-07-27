if vim.g.did_load_claudecode_plugin then
  return
end
vim.g.did_load_claudecode_plugin = true

require("claudecode").setup({
  -- Terminal window settings
  terminal = {
    split_side = "right",           -- "left" or "right"
    split_width_percentage = 0.30,  -- width of the terminal split
    provider = "snacks",            -- "snacks" | "native" | "external"
    show_native_term_exit_tip = true,
  },
  -- Diff view settings
  diff_opts = {
    auto_close_on_accept = true,
    show_diff_stats = true,
    vertical_split = true,
    open_in_current_tab = true,
  },
})

-- Keymaps (mirrors the lazy.nvim `keys` spec you shared)
local map = vim.keymap.set

map("n", "<leader>a", "<Nop>", { desc = "AI/Claude Code" })
map("n", "<leader>ac", "<cmd>ClaudeCode<cr>", { desc = "Toggle Claude" })
map("n", "<leader>af", "<cmd>ClaudeCodeFocus<cr>", { desc = "Focus Claude" })
map("n", "<leader>ar", "<cmd>ClaudeCode --resume<cr>", { desc = "Resume Claude" })
map("n", "<leader>aC", "<cmd>ClaudeCode --continue<cr>", { desc = "Continue Claude" })
map("n", "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", { desc = "Select Claude model" })
map("n", "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", { desc = "Add current buffer" })
map("v", "<leader>as", "<cmd>ClaudeCodeSend<cr>", { desc = "Send to Claude" })

-- Diff management
map("n", "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "Accept diff" })
map("n", "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", { desc = "Deny diff" })

-- File-tree "add file" keymap, scoped to tree/picker filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw", "snacks_picker_list" },
  callback = function(args)
    map("n", "<leader>as", "<cmd>ClaudeCodeTreeAdd<cr>", { buffer = args.buf, desc = "Add file" })
  end,
})
