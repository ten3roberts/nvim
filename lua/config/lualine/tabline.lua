local M = {}

-- Cache for tabline data
local cache = {
  tabs = {},
  buffers = {},
  last_update = 0,
}

-- Helper to safely require modules
local function safe_require(module)
  local ok, result = pcall(require, module)
  return ok, result
end

-- Get theme colors from palette or highlight groups
local function get_theme_colors()
  local ok, palette = safe_require("config.palette")
  if ok and palette.palette then
    local colors = palette.generate_palette()
    return {
      terminal = colors.green,
      graphene = colors.blue,
    }
  end
  
  -- Fallback to highlight groups
  local function get_hl_color(hl_name, property)
    local hl = vim.api.nvim_get_hl(0, { name = hl_name, link = false })
    if hl and hl[property] then
      return string.format("#%06x", hl[property])
    end
    return nil
  end
  
  return {
    terminal = get_hl_color("String", "fg") or get_hl_color("Normal", "fg") or "#87af87",
    graphene = get_hl_color("DiagnosticInfo", "fg") or get_hl_color("Normal", "fg") or "#87afff",
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
    terminal = false, -- terminals are handled separately
  }

  return not (excluded_ft[ft] or excluded_bt[bt])
end

-- Get buffer display with caching
local function get_buffer_display(bufnr, is_active_tab)
  if not should_show_buffer(bufnr) then
    return nil
  end

  -- Check cache
  local cache_key = bufnr .. ":" .. is_active_tab
  if cache.buffers[cache_key] then
    return cache.buffers[cache_key]
  end

  local bt = vim.bo[bufnr].buftype
  local ft = vim.bo[bufnr].filetype

  -- Get tab background colors
  local tabline_hl = vim.api.nvim_get_hl(0, { name = "TabLine", link = false })
  local tabline_sel_hl = vim.api.nvim_get_hl(0, { name = "TabLineSel", link = false })
  local tabline_fill_hl = vim.api.nvim_get_hl(0, { name = "TabLineFill", link = false })
  local normal_hl = vim.api.nvim_get_hl(0, { name = "Normal", link = false })

  local tab_bg = is_active_tab and (tabline_sel_hl.bg or normal_hl.bg) or (tabline_hl.bg or tabline_fill_hl.bg)

  local result

  if bt == "terminal" then
    local job_info = vim.b[bufnr].terminal_job_info or {}
    local cmd = job_info.cmd or "Terminal"
    -- Create colored terminal icon with tab background
    local theme_colors = get_theme_colors()
    local hl_name = "TablineTerminalIcon" .. bufnr .. (is_active_tab and "_active" or "_inactive")
    vim.api.nvim_set_hl(0, hl_name, { fg = theme_colors.terminal, bg = tab_bg })
    local reset_hl = is_active_tab and "TabLineSel" or "TabLine"
    result = string.format("%%#%s#%%#%s# %s", hl_name, reset_hl, cmd)
  elseif ft == "graphene" then
    -- Create colored graphene icon with tab background
    local theme_colors = get_theme_colors()
    local hl_name = "TablineGrapheneIcon" .. bufnr .. (is_active_tab and "_active" or "_inactive")
    vim.api.nvim_set_hl(0, hl_name, { fg = theme_colors.graphene, bg = tab_bg })
    local reset_hl = is_active_tab and "TabLineSel" or "TabLine"
    result = string.format("%%#%s#󰉋%%#%s# graphene", hl_name, reset_hl)
  else
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    local filename = vim.fn.fnamemodify(bufname, ":t")
    if filename == "" then
      return nil
    end

    -- Add colored filetype icon with tab background
    local extension = vim.fn.fnamemodify(filename, ":e")
    local ok, devicons = safe_require("nvim-web-devicons")
    if ok then
      local icon, icon_color = devicons.get_icon_color(filename, extension, { default = true })
      if icon then
        local hl_name = "TablineDevIcon" .. bufnr .. (is_active_tab and "_active" or "_inactive")
        vim.api.nvim_set_hl(0, hl_name, { fg = icon_color, bg = tab_bg })
        local reset_hl = is_active_tab and "TabLineSel" or "TabLine"
        result = string.format("%%#%s#%s%%#%s# %s", hl_name, icon, reset_hl, filename)
      else
        result = filename
      end
    else
      result = filename
    end
  end

  -- Cache the result
  cache.buffers[cache_key] = result
  return result
end

-- Main tabline function with performance optimizations
function M.tabline()
  -- Only show tabline if there are 2 or more tabpages
  if #vim.api.nvim_list_tabpages() < 2 then
    return ""
  end

  local current_tab = vim.api.nvim_get_current_tabpage()
  local parts = {}

  for i, tabnr in ipairs(vim.api.nvim_list_tabpages()) do
    local is_active = tabnr == current_tab
    local windows = vim.api.nvim_tabpage_list_wins(tabnr)
    local buffers = {}

    for _, winid in ipairs(windows) do
      local bufnr = vim.api.nvim_win_get_buf(winid)
      local buffer_display = get_buffer_display(bufnr, is_active)
      if buffer_display and buffer_display ~= "" then
        table.insert(buffers, buffer_display)
      end
    end

    local buffer_str = #buffers > 0 and table.concat(buffers, " | ") or "[No buffers]"
    local tab_content = string.format("%d. %s", i, buffer_str)

    if is_active then
      table.insert(parts, string.format("%%#TabLineSel# %s %%*", tab_content))
    else
      table.insert(parts, string.format("%%#TabLine# %s %%*", tab_content))
    end
  end

  return table.concat(parts, "")
end

-- Cleanup function for cache
function M.cleanup()
  cache.tabs = {}
  cache.buffers = {}
  cache.last_update = 0
end

-- Setup autocmds for cache invalidation
function M.setup_autocmds()
  local group = vim.api.nvim_create_augroup("LualineTabline", { clear = true })

  vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete", "BufEnter", "BufWritePost" }, {
    group = group,
    callback = function()
      -- Clear buffer cache when buffers change
      cache.buffers = {}
    end,
  })

  vim.api.nvim_create_autocmd({ "TabNew", "TabClosed", "TabEnter" }, {
    group = group,
    callback = function()
      -- Clear tab cache when tabs change
      cache.tabs = {}
      cache.buffers = {}
    end,
  })
end

return M