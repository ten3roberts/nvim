local ui = require'dapui'
ui.setup{
  icons = { expanded = "▾", collapsed = "▸" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
  },
  sidebar = {
    open_on_start = false,
    -- You can change the order of elements in the sidebar
    elements = {
      -- Provide as ID strings or tables with "id" and "size" keys
      { id = "breakpoints", size = 0.1 },
      { id = "watches", size = 0.2 },
      { id = "scopes", size = 0.7 },
    },
    size = 40,
    position = "right", -- Can be "left", "right", "top", "bottom"
  },
  -- tray = {
  --   open_on_start = false,
  --   elements = { "repl" },
  --   size = 10,
  --   position = "bottom", -- Can be "left", "right", "top", "bottom"
  -- },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 }
}

local dap = require'dap'

dap.listeners.after.event_initialized['dapui_config'] = function() ui.open() end
dap.listeners.before.event_terminated['dapui_config'] = function() ui.close() end
dap.listeners.before.event_exited['dapui_config'] = function() ui.close() end

dap.adapters.rust_lldb = {
  type = 'executable',
  command = 'rust-lldb', -- adjust as needed
  name = "rust_lldb"
}

dap.configurations.rust = {
  name = "rust_lldb",
  type = "rust_lldb",
  program = function()
    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
  end,
  cwd = '${workspaceFolder}',
  args = {},
  stopOnEntry = true,

  -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
  --
  --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
  --
  -- Otherwise you might get the following error:
  --
  --    Error on launch: Failed to attach to the target process
  --
  -- But you should be aware of the implications:
  -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
  runInTerminal = false
}

dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb-vscode', -- adjust as needed
  name = "lldb"
}

dap.configurations.rust = { {
    name = "Launch",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},

    -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
    --
    --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    --
    -- Otherwise you might get the following error:
    --
    --    Error on launch: Failed to attach to the target process
    --
    -- But you should be aware of the implications:
    -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
    runInTerminal = false,
} }

return {
  dap = dap,
  ui = ui,
}
