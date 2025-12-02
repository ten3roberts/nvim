local ui = require "dapui"
ui.setup {
  layouts = {
    {
      elements = {
        -- Elements can be strings or table with id and size keys.
        -- { id = "scopes", size = 0.25 },
        "scopes",
        "breakpoints",
        -- "stacks",
        "watches",
      },
      size = 10,
      position = "bottom",
    },
  },
  floating = {
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
}

local dap = require "dap"

require("nvim-dap-virtual-text").setup {
  highlight_new_as_changed = true,
}

dap.defaults.fallback.terminal_win_cmd = "vsplit new"

dap.listeners.after.event_initialized["dapui_config"] = function()
  dap.set_exception_breakpoints { "rust_panic" }
  ui.open {}
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

dap.defaults.rust.exception_breakpoints = { "rust_panic" }
local codelldb_adapter = require("config.codelldb").get_codelldb()
dap.adapters.rust = codelldb_adapter
dap.adapters.codelldb = codelldb_adapter

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

local keybinds = require("config.keybind_definitions")

vim.keymap.set("n", keybinds.getKeybind("dap-ui-toggle"), ui.toggle, { desc = keybinds.getDesc("dap-ui-toggle") })
vim.keymap.set("n", keybinds.getKeybind("dap-eval-input"), M.eval_input, { desc = keybinds.getDesc("dap-eval-input") })
vim.keymap.set("n", keybinds.getKeybind("dap-float-element"), M.float, { desc = keybinds.getDesc("dap-float-element") })
vim.keymap.set("n", keybinds.getKeybind("dap-hover"), function()
  require("dap.ui.widgets").hover()
end, { desc = keybinds.getDesc("dap-hover") })
vim.keymap.set("n", keybinds.getKeybind("dap-variables"), "<cmd>:Telescope dap variables<CR>", { desc = keybinds.getDesc("dap-variables") })
vim.keymap.set("n", keybinds.getKeybind("dap-breakpoints"), "<cmd>:Telescope dap list_breakpoints<CR>", { desc = keybinds.getDesc("dap-breakpoints") })
vim.keymap.set("n", keybinds.getKeybind("dap-frames"), "<cmd>:Telescope dap frames<CR>", { desc = keybinds.getDesc("dap-frames") })
vim.keymap.set("n", keybinds.getKeybind("dap-commands"), "<cmd>:Telescope dap commands<CR>", { desc = keybinds.getDesc("dap-commands") })

return M
