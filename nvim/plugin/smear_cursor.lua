if vim.g.did_load_smear_cursor_plugin then
  return
end

vim.g.did_load_smear_cursor_plugin = true

require('smear_cursor').setup({
  stiffness = 0.6,
  trailing_stiffness = 0.3,
  distance_stop_animating = 0.1,
  hide_target_hack = true,
})
