local api = vim.api
local cmd = vim.cmd
local fn = vim.fn

local M = {}

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
    if not visible[bufnr] and vim.bo[bufnr].buflisted and vim.bo[bufnr].buftype == "" then
      api.nvim_buf_delete(bufnr, { force = false })
      closed = closed + 1
    end
  end
  -- for bufnr = 1, fn.bufnr "$" do
  --   if
  --     fn.bufexists(bufnr) == 1
  --     and visible[bufnr] ~= true
  --     and fn.buflisted(bufnr) == 1
  --     and api.nvim_buf_get_option(bufnr, "buftype") == ""
  --   then
  --     if pcall(cmd, "bdelete " .. bufnr) then
  --       closed = closed + 1
  --     end
  --   end
  -- end
  vim.notify(string.format("Closed %d hidden buffers", closed))
  cmd "redraw"
end

function M.close(bufnr)
  bufnr = bufnr or api.nvim_get_current_buf()

  local prev = fn.bufnr "#"

  -- Close special splits
  if vim.bo[bufnr].buftype == "" then
    for _, win in ipairs(api.nvim_list_wins()) do
      if api.nvim_win_get_buf(win) == bufnr then
        if prev and prev ~= -1 then
          api.nvim_win_set_buf(win, prev)
        end
      end
    end
  end

  api.nvim_buf_delete(bufnr, { force = false })

  cmd "redraw"
end

return M
