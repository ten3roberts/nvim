local cmd = vim.cmd
local fn = vim.fn
local g = vim.g

local M = {}

local fd = 'fd -t f'

-- Makes files closer to the current file favored.
function M.proximity()
  if vim.o.buftype ~= '' then
    return fd
  end

  return fd .. ' | proximity-sort ' .. fn.expand('%')
end

function M.setup()
  g.fzf_layout = { window = { width = 0.8, height = 0.6 } }

  cmd [[
  function! FZFProximity()
  return luaeval('require"config.fzf".proximity()')
  endfunc
  ]]

  cmd [[
  command! -bang -nargs=? -complete=dir Buffers call fzf#vim#buffers(<q-args>, {}, <bang>0)
  ]]

  cmd [[
  command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, {'source': FZFProximity(), 'options': '--tiebreak=index'}, <bang>0)
  ]]
end

return M
