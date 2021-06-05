local M = {}

function _G.dump(...)
    local objects = vim.tbl_map(vim.inspect, {...})
    print(unpack(objects))
end

function _G.dump_mod(module)
  module = module or vim.fn.expand('%:t:r')
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

  local module = vim.fn.expand('%:t:r')

  print ('Reloading ' .. module)
  vim.cmd('silent! write')
  require 'plenary.reload'.reload_module (module)
  require(module).setup()
end

return M
