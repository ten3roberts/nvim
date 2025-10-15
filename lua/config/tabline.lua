local api = vim.api
local fn = vim.fn

local M = {}

M.tab_hide = {
  NvimTree = true,
  qf = true,
  aerial = true,
}

M.buffer_names = {}
M.buffer_ids = {}
M.tabpages = {}

local separator = "/"

local function subtbl(tbl, first, last)
  if type(tbl) == "string" then
    return string.sub(tbl, first, last)
  end

  if first < 0 then
    first = #tbl + 1 + first
  end

  if last ~= nil and last < 0 then
    last = #tbl + 1 + last
  end

  local sliced = {}

  for i = first or 1, last or #tbl do
    sliced[#sliced + 1] = tbl[i]
  end

  return sliced
end

local function get_unique_name(a, b)
  local a_parts = fn.split(a, separator)
  local b_parts = fn.split(b, separator)

  local shortest = math.min(#a_parts, #b_parts)

  -- Find the last index of the common divisors
  local common_divisor = 1
  for i = 1, shortest do
    local a_part = a_parts[i]
    local b_part = b_parts[i]

    if a_part ~= b_part then
      common_divisor = i
      break
    end
  end

  return fn.join(subtbl(a_parts, common_divisor), separator), fn.join(subtbl(b_parts, common_divisor), separator)
end

local Recipe = require "recipe.recipe"

function M.get_buffername(bufnr)
  if vim.bo[bufnr].buftype == "terminal" then
    local task_info = vim.b[bufnr].recipe_task_info
    if task_info then
      local recipe = setmetatable(task_info.recipe, Recipe)
      M.buffer_ids[bufnr] = string.format("  %s", recipe.label)
    else
      local tname = fn.fnamemodify(fn.bufname(bufnr), ":t")
      if tname == "" then tname = "Terminal" end
      M.buffer_ids[bufnr] = " " .. tname
    end
    return
  end

  local filename = fn.fnamemodify(fn.bufname(bufnr), ":t")

  if filename == nil or filename == "" then
    return
  end

  if M.buffer_names[filename] ~= nil then
    local other = M.buffer_names[filename]

    local cur_bufname = fn.fnamemodify(fn.bufname(bufnr), ":~")
    local other_bufname = fn.fnamemodify(fn.bufname(other), ":~")

    if cur_bufname ~= other_bufname then
      local new_other, new_cur = get_unique_name(other_bufname, cur_bufname)

      if new_other == "" or new_cur == "" then
        vim.notify(string.format("%s got turned into empty colliding with %s", cur_bufname, other_bufname))
      end

      M.buffer_names[new_other] = other
      M.buffer_ids[other] = new_other

      filename = new_cur
    end
  end

  M.buffer_names[filename] = bufnr
  M.buffer_ids[bufnr] = filename
end

function M.update_buffers_and_tabpages()
  -- Clear and update all buffer names to unique paths
  M.buffer_names = {}
  M.buffer_ids = {}
  for _, bufnr in ipairs(api.nvim_list_bufs()) do
    if not M.tab_hide[vim.bo[bufnr].ft] and api.nvim_buf_is_loaded(bufnr) then
      M.get_buffername(bufnr)
    end
  end

  -- Update the buffers listed in each tabpage
  M.tabpages = {}

  for _, id in ipairs(api.nvim_list_tabpages()) do
    local windows = api.nvim_tabpage_list_wins(id)

    local tabpage = {}
    local found = {}

    for _, win in ipairs(windows) do
      local bufnr = api.nvim_win_get_buf(win)

      if not found[bufnr] and M.buffer_ids[bufnr] then
        table.insert(tabpage, bufnr)
      end
      found[bufnr] = true
    end

    M.tabpages[id] = tabpage
  end
end

function M.get_buffer_display(bufnr)
  local name = M.buffer_ids[bufnr] or "[No Name]"
  local icon_str = ""
  if not name:find("^") then
    local icon = require("nvim-web-devicons").get_icon(name, fn.fnamemodify(name, ":e"), { default = true })
    icon_str = icon and icon .. " " or ""
  end
  local modified = vim.bo[bufnr].modified and " 󰆓" or ""
  return icon_str .. name .. modified
end

function M.setup_autocmd()
  api.nvim_create_autocmd({ "VimEnter", "UIEnter", "WinClosed", "WinNew", "BufWinEnter", "BufWinLeave" }, {
    callback = function()
      vim.schedule(M.update_buffers_and_tabpages)
    end,
  })
end

return M