local M = {}

-- Helper to safely require modules
local function safe_require(module)
  local ok, result = pcall(require, module)
  return ok, result
end

-- Get theme colors
local function get_theme_colors()
  local ok, palette = safe_require("config.palette")
  if ok and palette.generate_palette then
    local colors = palette.generate_palette()
    return {
      terminal = colors.green,
      graphene = colors.blue,
    }
  end
  return {
    terminal = "#87af87",
    graphene = "#87afff",
  }
end

-- Check if buffer should be shown in tabline
local function should_show_buffer(bufnr)
  local ft = vim.bo[bufnr].filetype
  local bt = vim.bo[bufnr].buftype

  local excluded_ft = {
    aerial = true,
    snacks_notif = true,
    snacks_win = true,
    snacks_notify = true,
    notify = true,
    neo_tree = true,
    NvimTree = true,
    qf = true,
    help = true,
  }
  local excluded_bt = {
    quickfix = true,
    help = true,
    terminal = false,
  }

  return not (excluded_ft[ft] or excluded_bt[bt])
end

-- Get tab background color
local function get_tab_bg(is_active)
  local hl_name = is_active and "TabLineSel" or "TabLine"
  local hl = vim.api.nvim_get_hl(0, { name = hl_name, link = false })
  return hl.bg
end

-- Get buffer display with colored icon using vim statusline highlight codes
local function get_buffer_display(bufnr, is_active)
  if not should_show_buffer(bufnr) then
    return nil
  end

  local bt = vim.bo[bufnr].buftype
  local ft = vim.bo[bufnr].filetype
  local reset_hl = is_active and "%#TabLineSel#" or "%#TabLine#"
  local tab_bg = get_tab_bg(is_active)
  local suffix = is_active and "_sel" or ""

  if bt == "terminal" then
    local job_info = vim.b[bufnr].terminal_job_info or {}
    local cmd = job_info.cmd or "Terminal"
    local colors = get_theme_colors()
    local hl_name = "TablineTerminal" .. suffix
    vim.api.nvim_set_hl(0, hl_name, { fg = colors.terminal, bg = tab_bg })
    return string.format("%%#%s#%s %s", hl_name, "", cmd) .. reset_hl
  elseif ft == "graphene" then
    local colors = get_theme_colors()
    local hl_name = "TablineGraphene" .. suffix
    vim.api.nvim_set_hl(0, hl_name, { fg = colors.graphene, bg = tab_bg })
    return string.format("%%#%s#%s %s", hl_name, "󰉋", "graphene") .. reset_hl
  else
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    local filename = vim.fn.fnamemodify(bufname, ":t")
    if filename == "" then
      return nil
    end

    local extension = vim.fn.fnamemodify(filename, ":e")
    local ok, devicons = safe_require("nvim-web-devicons")
    if ok then
      local icon, icon_color = devicons.get_icon_color(filename, extension, { default = true })
      if icon and icon_color then
        local hl_name = "TablineIcon_" .. (extension ~= "" and extension or "default") .. suffix
        vim.api.nvim_set_hl(0, hl_name, { fg = icon_color, bg = tab_bg })
        return string.format("%%#%s#%s%s %s", hl_name, icon, reset_hl, filename)
      end
    end
    return filename
  end
end

-- Main tabline function (for vim's native tabline)
function M.tabline()
  local current_tab = vim.api.nvim_get_current_tabpage()
  local parts = {}

  for i, tabnr in ipairs(vim.api.nvim_list_tabpages()) do
    local is_active = tabnr == current_tab
    local windows = vim.api.nvim_tabpage_list_wins(tabnr)
    local buffers = {}

    for _, winid in ipairs(windows) do
      local bufnr = vim.api.nvim_win_get_buf(winid)
      local display = get_buffer_display(bufnr, is_active)
      if display then
        table.insert(buffers, display)
      end
    end

    local buffer_str = #buffers > 0 and table.concat(buffers, " | ") or "[Empty]"
    local tab_hl = is_active and "%#TabLineSel#" or "%#TabLine#"
    table.insert(parts, string.format("%s %d. %s ", tab_hl, i, buffer_str))
  end

  return table.concat(parts, "") .. "%#TabLineFill#"
end

-- Cleanup function
function M.cleanup()
end

-- Setup autocmds
function M.setup_autocmds()
end

return M
