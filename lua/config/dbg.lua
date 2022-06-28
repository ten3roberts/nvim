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
        { id = "scopes", size = 0.25 },
        "breakpoints",
        "stacks",
        "watches",
      },
      size = 40, -- 40 columns
      position = "right",
    },
    {
      elements = {
        "repl",
        "console",
      },
      size = 0.25, -- 25% of total lines
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

require("nvim-dap-virtual-text").setup()

dap.defaults.fallback.terminal_win_cmd = "10split new"

dap.listeners.after.event_initialized["dapui_config"] = function()
  ui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  ui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  ui.close()
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

function M.conditioal_break()
  vim.ui.input({ prompt = "Condition: " }, function(v)
    dap.set_breakpoint(v)
  end)
end

local function map(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, opts)
end

map("n", "<leader>dn", dap.step_over)
map("n", "]d", dap.step_over)
map("n", "[d", dap.step_back)
map("n", "<leader>di", dap.step_into)
map("n", "<leader>do", dap.step_out)
map("n", "<leader>dd", dap.down)
map("n", "<leader>du", dap.up)
map("n", "<leader>ds", dap.pause)
map("n", "<leader>dQ", dap.close)

map("n", "<leader>db", dap.toggle_breakpoint)
map("n", "<leader>dB", M.conditioal_break)

map("n", "<leader>dBe", dap.set_exception_breakpoints)

map("n", "<leader>dc", dap.continue)
-- map('n', '<leader>dr', dap.run_last)
map("n", "<leader>dg", dap.run_to_cursor)
map("n", "<leader>dO", ui.toggle)

map("n", "<leader>dlv", ":Telescope dap variables<CR>")
map("n", "<leader>dlb", ":Telescope dap list_breakpoints<CR>")
map("n", "<leader>dlf", ":Telescope dap frames<CR>")
map("n", "<leader>dlc", ":Telescope dap commands<CR>")

map("n", "<leader>de", function()
  ui.eval(nil, { enter = true })
end)
map("n", "<leader>dE", M.eval_input)
map("n", "<leader>d.", M.float)

map("n", "<leader>dw", require("dap.ui.widgets").hover)

map("n", "<F5>", dap.continue)
map("n", "<F10>", dap.step_over)
map("n", "<F11>", dap.step_into)
map("n", "<F12>", dap.step_out)

return M
