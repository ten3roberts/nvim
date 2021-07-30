local api = vim.api
local cmd = vim.cmd
local fn = vim.fn

local M = {}

function M.close_hidden()
  local visible = {}
  for i=1,fn.tabpagenr('$') do
    for _,bufnr in ipairs(fn.tabpagebuflist(i)) do
      visible[bufnr] = true
    end
  end

  local closed = 0
  for bufnr=1,fn.bufnr('$') do
    if fn.bufexists(bufnr) == 1 and fn.buflisted(bufnr) == 1 and visible[bufnr] ~= true then
      closed = closed + 1
      cmd('bdelete ' .. bufnr)
    end
  end
  print('Closed ' .. closed .. ' buffers')
  cmd('redraw')
end

function M.close(bufnr)
  bufnr = bufnr or fn.bufnr('%')

  local prev = fn.bufnr('#')

  for w=1,fn.winnr('$') do
    local winid = fn.win_getid(w)
    if api.nvim_win_get_buf(winid) == bufnr and fn.buflisted(bufnr) then
      api.nvim_win_set_buf(winid, prev)
    end
  end

  cmd('bdelete ' .. bufnr)
  cmd('redraw')
end

return M
