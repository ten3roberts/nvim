local api = vim.api
local cmd = vim.cmd
local fn = vim.fn

local M = {}

-- Close all hidden, listed, normal buffers
function M.close_hidden()
  local visible = {}
  for _, tp in ipairs(api.nvim_list_tabpages()) do
    for _, win in ipairs(api.nvim_tabpage_list_wins(tp)) do
      local bufnr = api.nvim_win_get_buf(win)
      visible[bufnr] = true
    end
  end

  local closed = 0
  for _, bufnr in ipairs(api.nvim_list_bufs()) do
    if
      not visible[bufnr]
      and vim.api.nvim_buf_is_loaded(bufnr)
      and vim.bo[bufnr].buflisted
      and vim.bo[bufnr].buftype == ""
      and not vim.bo[bufnr].readonly
      and api.nvim_buf_get_option(bufnr, "modifiable")
    then
      local ok = pcall(api.nvim_buf_delete, bufnr, { force = false })
      if ok then
        closed = closed + 1
      end
    end
  end
  vim.notify(string.format("Closed %d hidden buffers", closed))
  cmd "redraw"
end

return M
