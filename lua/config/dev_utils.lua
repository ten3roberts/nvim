local M = {}

local function get_module_name(path)
  path = path:gsub("/", ".")

  local i, j = path:find "lua"

  if i and j then
    return path:sub(j + 2)
  else
    return path
  end
end

function M.dump(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  print(unpack(objects))
end

function M.dump_mod(module)
  module = get_module_name(module or vim.fn.expand "%:p:r")
  M.dump(require(module))
end

_G.dump_mod = M.dump_mod

-- The function is called `t` for `termcodes`.
-- You don't have to call it that, but I find the terseness convenient
function M.replace_termcodes(str)
  -- Adjust boolean arguments as needed
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function M.reload(module)
  module = module or get_module_name(vim.fn.expand "%:p:r")

  vim.notify("Reloading: " .. module)
  module = module or vim.fn.expand "%"
  require("plenary.reload").reload_module(module)

  return require(module)
end

function M.save_and_exec()
  vim.cmd "write"

  if vim.o.ft == "vim" then
    vim.cmd "w | source %"
    return
  end
  if vim.o.ft ~= "lua" then
    return
  end

  local path = vim.fn.expand "%:p:r"
  local module = get_module_name(path)

  local mod = M.reload(module)

  if type(mod) == "table" then
    if type(mod.setup) == "function" then
      mod.setup {}
    end
    if type(mod.test) == "function" then
      local async = require "plenary.async"
      async.run(mod.test)
    end
  end
end

_G.P = function(...)
  print(vim.inspect(...))
end

return M
