local M = {}

local function get_module_name(path)
  local i,j = path:find('lua')

  if i and j then
    return path:sub(j + 2)
  else
    return path
  end
end

function _G.dump(...)
  local objects = vim.tbl_map(vim.inspect, {...})
  print(unpack(objects))
end

function _G.dump_mod(module)
  module = get_module_name(module or vim.fn.expand('%:p:r'))
  dump(require(module))
end

-- The function is called `t` for `termcodes`.
-- You don't have to call it that, but I find the terseness convenient
function M.replace_termcodes(str)
  -- Adjust boolean arguments as needed
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end


function M.save_and_exec()
  if vim.o.ft ~= 'lua' then
    error("Not a lua module!")
    return
  end

  local path = vim.fn.expand('%:p:r')
  local module = get_module_name(path)


  print ('Reloading ' .. module)

  vim.cmd('silent! write')
  require 'plenary.reload'.reload_module (module)
  require 'plenary.reload'.reload_module (module:gsub('/', '.'))

  local mod = require(module)

  if type(mod) == 'table' and mod.setup then
    mod.setup {}
  end
end

return M
