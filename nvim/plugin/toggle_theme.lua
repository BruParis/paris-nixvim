local state_file = vim.fn.expand('~/.local/share/theme-mode')

local function apply_theme_from_state()
  local f = io.open(state_file, 'r')
  local mode = f and f:read('*l') or 'dark'
  if f then f:close() end
  vim.cmd('colorscheme catppuccin-' .. (mode == 'light' and 'latte' or 'macchiato'))
end

vim.api.nvim_create_user_command('ToggleTheme', function()
  local next_mode = vim.g.colors_name == 'catppuccin-latte' and 'dark' or 'light'
  local f = io.open(state_file, 'w')
  if f then
    f:write(next_mode)
    f:close()
  end
  apply_theme_from_state()
end, {})
