local ui = require "dapui"
ui.setup {
  icons = { expanded = "▾", collapsed = "▸" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "<2-LeftMouse>", "<Tab>" },
    open = { "o" },
    remove = "d",
    edit = "e",
    repl = "r",
  },
  layouts = {
    {
      elements = {
        "scopes",
        { id = "breakpoints", size = 0.1 },
        "stacks",
        "watches",
      },
      size = 8, -- 40 columns
      position = "bottom",
    },
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    border = "none",
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 0 },
}

local dap = require "dap"

require("nvim-dap-virtual-text").setup {
  highlight_new_as_changed = true,
}

dap.defaults.fallback.terminal_win_cmd = "80vsplit new"

dap.listeners.after.event_initialized["dapui_config"] = function()
  ui.open {}
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  ui.close {}
end
dap.listeners.before.event_exited["dapui_config"] = function()
  ui.close {}
end

dap.configurations.rust = {
  name = "rust_lldb",
  type = "rust_lldb",
  program = function()
    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
  end,
  cwd = "${workspaceFolder}",
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
  runInTerminal = false,
}

dap.defaults.rust.exception_breakpoints = { "rust_panic" }

dap.adapters.lldb = {
  type = "executable",
  command = "lldb-vscode", -- adjust as needed
  name = "lldb",
  env = { LLDB_LAUNCH_FLAG_LAUNCH_IN_TTY = "YES" },
}

dap.configurations.rust = {
  {
    name = "Launch",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
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
  },
}

local M = {
  dap = dap,
  ui = ui,
}

function M.float()
  vim.ui.select({ "scopes", "breakpoints", "watches", "stacks" }, {
    prompt = "Open: ",
  }, function(choice)
    if choice then
      ui.float_element(choice, { enter = true })
    end
  end)
end

function M.eval_input()
  vim.ui.input({ prompt = "Expr: " }, function(input)
    if input then
      ui.eval(input, { enter = true })
    end
  end)
end

function M.conditional_breakpoint()
  vim.ui.input({ prompt = "Condition: " }, function(v)
    vim.ui.input({ prompt = "Hit Condition" }, function(hit)
      dap.set_breakpoint(v, hit)
    end)
  end)
end

local function map(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, opts)
end

local wk = require "which-key"

wk.register({
  name = "dap",
  n = { dap.step_over, "Step over" },
  i = { dap.step_into, "Step into" },
  o = { dap.step_out, "Step out" },
  d = { dap.down, "Down" },
  u = { dap.up, "Up" },
  s = { dap.pause, "Pause" },
  q = { dap.terminate, "Terminate" },
  c = { dap.continue, "Continue" },
  g = { dap.run_to_cursor, "Run to cursor" },
  r = { dap.run_last, "Run last" },
  O = { ui.toggle, "Toggle dap ui" },

  e = {
    function()
      ui.eval(nil, { enter = true })
    end,
    "Evaluate expression under cursor",
  },
  E = { M.eval_input, "Evaluate input" },
  ["."] = { M.float, "Open floating element" },
  w = {
    function()
      require("dap.ui.widgets").hover()
    end,
    "Hover",
  },

  b = {
    b = { dap.toggle_breakpoint, "Toggle breakpoint" },
    B = { M.conditioal_break, "Conditional breakpoint" },
    e = { dap.set_exception_breakpoints, "Exception breakpoints" },
  },

  l = {
    name = "Telescope",
    v = { "<cmd>:Telescope dap variables", "Variables" },
    b = { "<cmd>:Telescope dap list_breakpoints", "Breakpoints" },
    f = { "<cmd>:Telescope dap frames", "Frames" },
    c = { "<cmd>:Telescope dap commands", "Commands" },
  },
}, { prefix = "<leader>d" })

wk.register({
  ["]d"] = {
    dap.step_over,
    "Next diagnostic item",
  },
  ["[d"] = {
    dap.step_back,
    "Prev diagnostic item",
  },
}, {})

return M
