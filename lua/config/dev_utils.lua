local M = {}

function _G.dump(...)
    local objects = vim.tbl_map(vim.inspect, {...})
    print(unpack(objects))
end

-- The function is called `t` for `termcodes`.
-- You don't have to call it that, but I find the terseness convenient
function M.replace_termcodes(str)
    -- Adjust boolean arguments as needed
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function M.save_and_exec()
  if vim.o.ft ~= 'lua' then
    return
  end

  print ('Reloading ' .. vim.fn.expand('%:t'))
  vim.cmd('silent! write')
  require 'plenary.reload'.reload_module'%'
  vim.cmd("luafile %")
end

return M
