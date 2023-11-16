local ui = require "dapui"
ui.setup {
  -- icons = { expanded = "▾", collapsed = "▸" },
  -- mappings = {
  --   -- Use a table to apply multiple mappings
  --   expand = { "<CR>", "<2-LeftMouse>", "<Tab>" },
  --   open = { "o" },
  --   remove = "d",
  --   edit = "e",
  --   repl = "r",
  -- },
  -- layouts = {
  --   {
  --     elements = {
  --       "scopes",
  --       "watches",
  --       "stacks",
  --       { id = "breakpoints", size = 0.1 },
  --     },
  --     size = 8, -- 40 columns
  --     -- position = "bottom",
  --   },
  -- },
  layouts = {
    {
      elements = {
        -- Elements can be strings or table with id and size keys.
        -- { id = "scopes", size = 0.25 },
        "scopes",
        "breakpoints",
        "stacks",
        "watches",
      },
      size = 10,
      position = "bottom",
    },
    -- {
    --   elements = { "console" },
    --   position = "bottom",
    --   size = 16,
    -- },
  },
  floating = {
    -- max_height = nil, -- These can be integers or a float between 0 and 1.
    -- max_width = nil, -- Floats will be treated as percentage of your screen.
    -- border = "none",
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  -- windows = { indent = 0 },
}

local dap = require "dap"

require("nvim-dap-virtual-text").setup {
  highlight_new_as_changed = true,
}

dap.defaults.fallback.terminal_win_cmd = "vsplit new"

dap.listeners.after.event_initialized["dapui_config"] = function()
  dap.set_exception_breakpoints { "rust_panic" }
  -- require("qf").close "l"
  require("qf").close "c"

  -- ui.open {}
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  -- ui.close {}
end
dap.listeners.before.event_exited["dapui_config"] = function()
  ui.close {}
end

dap.configurations.rust = {
  {
    name = "Launch",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    justMyCode = true,
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
  },
}

-- require("dap").defaults.fallback.exception_breakpoints = "rust_panic"
-- dap.defaults.codelldb.exception_breakpoints = { "rust_panic" }
dap.defaults.rust.exception_breakpoints = { "rust_panic" }
dap.adapters.rust = require("config.codelldb").get_codelldb()
-- dap.defaults.rust.exception_breakpoints = { "rust_panic" }

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
  vim.ui.input({ prompt = "Condition: " }, function(cond)
    vim.ui.input({ prompt = "Hit Condition" }, function(hit)
      dap.set_breakpoint(cond, hit)
    end)
  end)
end

function M.log_breakpoint()
  vim.ui.input({ prompt = "Condition: " }, function(v)
    dap.set_breakpoint(nil, nil, v)
  end)
end

local tree = require "config.treebind"

tree.register({
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

  l = {
    v = { "<cmd>:Telescope dap variables", "Variables" },
    b = { "<cmd>:Telescope dap list_breakpoints", "Breakpoints" },
    f = { "<cmd>:Telescope dap frames", "Frames" },
    c = { "<cmd>:Telescope dap commands", "Commands" },
  },
}, { prefix = "<leader>d" })

tree.register({
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
