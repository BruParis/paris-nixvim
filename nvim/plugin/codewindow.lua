-- Require the codewindow module
local codewindow = require('codewindow')

-- Attach codewindow to the current buffer and enable it by default
codewindow.setup({
    auto_enable = true,  -- Automatically enable codewindow on startup
    exclude_filetypes = {},  -- No filetypes excluded
    minimap_width = 10,  -- Width of the minimap
    window_border = 'single',
})
