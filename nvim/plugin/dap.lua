local dap = require('dap')
local dapui = require('dapui')

-- dap-ui
dapui.setup()

-- listeners to open and close dap-ui automatically
dap.listeners.after.event_initialized['dapui_config'] = function()
  dapui.open()
end
dap.listeners.before.event_terminated['dapui_config'] = function()
  dapui.close()
end
dap.listeners.before.event_exited['dapui_config'] = function()
  dapui.close()
end


-- Python Adapter
dap.adapters.python = {
  type = 'executable',
  command = 'python',
  args = { '-m', 'debugpy.adapter' },
}

dap.configurations.python = {
  {
    type = 'python',
    request = 'launch',
    name = 'Launch file',
    program = '${file}',
    pythonPath = function()
      local venv = os.getenv('VIRTUAL_ENV')
      if venv then
        print('Using virtual environment Python interpreter: ' .. venv .. '/bin/python')
        return venv .. '/bin/python'
      else
        local default_path = vim.fn.exepath('python') or 'python'
        print('Using default Python interpreter: ' ..
          default_path .. '\nTip: Set up a virtual environment to use a different interpreter automatically.')
        return vim.fn.input('Path to Python interpreter: ', default_path, 'file')
      end
    end,
  },
}

vim.keymap.set('n', '<F5>', function() dap.continue() end, { desc = 'Start/Continue Debugging' })
vim.keymap.set('n', '<F10>', function() dap.step_over() end, { desc = 'Step Over' })
vim.keymap.set('n', '<F11>', function() dap.step_into() end, { desc = 'Step Into' })
vim.keymap.set('n', '<F12>', function() dap.step_out() end, { desc = 'Step Out' })
vim.keymap.set('n', '<leader>b', function() dap.toggle_breakpoint() end, { desc = 'Toggle Breakpoint' })
vim.keymap.set('n', '<leader>B', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
  { desc = 'Set Conditional Breakpoint' })

vim.fn.sign_define('DapBreakpoint', { text = '🟥', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '▶️', texthl = '', linehl = '', numhl = '' })
