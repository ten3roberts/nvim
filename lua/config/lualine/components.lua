local M = {}

-- Cache for expensive operations
local cache = {
  highlights = {},
  file_info = {},
  tab_data = {},
}

-- Helper to safely require modules
local function safe_require(module)
  local ok, result = pcall(require, module)
  return ok, result
end

-- Get palette colors with fallbacks
local function get_colors()
  local ok, palette = safe_require "config.palette"
  if not ok then
    return {
      signs = { E = { sign = "E" }, W = { sign = "W" }, I = { sign = "I" }, H = { sign = "H" } },
    }
  end
  return palette
end

local cached_theme = nil

-- Get theme colors from palette or highlight groups
function M.get_theme_colors()
  if cached_theme then
    return cached_theme
  end

  local ok, palette = safe_require "config.palette"
  if ok and palette.palette then
    local colors = palette.generate_palette()
    local theme = {
      branch = colors.orange,
      diff = colors.orange,
      diagnostics_error = colors.red,
      diagnostics_warn = colors.orange,
      diagnostics_info = colors.blue,
      diagnostics_hint = colors.green,
      lsp = colors.green,
      dap = colors.red,
      macro = colors.red,
      terminal = colors.green,
      graphene = colors.blue,
      statusline_bg = M.get_hl("StatusLine", "bg"),
    }
    cached_theme = theme
    return theme
  else
    -- Fallback to highlight groups
    local theme = {
      branch = M.get_hl("GitSignsChange", "fg") or M.get_hl("WarningMsg", "fg") or "#ffaf5f",
      diff = M.get_hl("GitSignsChange", "fg") or M.get_hl("WarningMsg", "fg") or "#ff8800",
      diagnostics_error = M.get_hl("DiagnosticError", "fg") or M.get_hl("ErrorMsg", "fg") or "#ff5f5f",
      diagnostics_warn = M.get_hl("DiagnosticWarn", "fg") or M.get_hl("WarningMsg", "fg") or "#ffaf5f",
      diagnostics_info = M.get_hl("DiagnosticInfo", "fg") or M.get_hl("Normal", "fg") or "#87afff",
      diagnostics_hint = M.get_hl("DiagnosticHint", "fg") or M.get_hl("Comment", "fg") or "#87af87",
      lsp = M.get_hl("DiagnosticInfo", "fg") or M.get_hl("String", "fg") or "#90EE90",
      dap = M.get_hl("DiagnosticError", "fg") or M.get_hl("ErrorMsg", "fg") or "#ff5f5f",
      macro = M.get_hl("DiagnosticError", "fg") or M.get_hl("ErrorMsg", "fg") or "#ff5f5f",
      terminal = M.get_hl("String", "fg") or M.get_hl("Normal", "fg") or "#87af87",
      graphene = M.get_hl("DiagnosticInfo", "fg") or M.get_hl("Normal", "fg") or "#87afff",
      statusline_bg = M.get_hl("StatusLine", "bg"),
    }
    cached_theme = theme
    return theme
  end
end

-- Get mode colors from palette or fallback to theme colors
local function get_mode_colors()
  local ok, palette = safe_require "config.palette"
  if ok and palette.palette then
    local colors = palette.generate_palette()
    return {
      n = colors.blue,
      i = colors.green,
      v = colors.cyan or colors.blue,
      V = colors.cyan or colors.blue,
      ["\22"] = colors.cyan or colors.blue,
      c = colors.orange,
      s = colors.purple,
      S = colors.purple,
      ["\19"] = colors.purple,
      R = colors.orange,
      r = colors.orange,
      ["!"] = colors.red,
      t = colors.green,
    }
  end

  -- Fallback to highlight groups
  return {
    n = M.get_hl("Normal", "fg") or "#5f87af",
    i = M.get_hl("String", "fg") or "#87af87",
    v = M.get_hl("Visual", "bg") or "#87afaf",
    V = M.get_hl("Visual", "bg") or "#87afaf",
    ["\22"] = M.get_hl("Visual", "bg") or "#87afaf",
    c = M.get_hl("WarningMsg", "fg") or "#ffaf5f",
    s = M.get_hl("Special", "fg") or "#af87af",
    S = M.get_hl("Special", "fg") or "#af87af",
    ["\19"] = M.get_hl("Special", "fg") or "#af87af",
    R = M.get_hl("WarningMsg", "fg") or "#ffaf5f",
    r = M.get_hl("WarningMsg", "fg") or "#ffaf5f",
    ["!"] = M.get_hl("ErrorMsg", "fg") or "#ff5f5f",
    t = M.get_hl("String", "fg") or "#87af87",
  }
end

-- Helper to get highlight color
function M.get_hl(hl_name, property)
  local hl = vim.api.nvim_get_hl(0, { name = hl_name, link = false })
  if hl and hl[property] then
    return string.format("#%06x", hl[property])
  end
  return nil
end

function M.get_mode_color()
  local mode_colors = get_mode_colors()
  local mode = vim.fn.mode()
  return mode_colors[mode] or mode_colors.n
end

-- File info component with caching
function M.get_file_info()
  local bufnr = vim.api.nvim_get_current_buf()
  local bufname = vim.api.nvim_buf_get_name(bufnr)

  -- Check cache first
  local cache_key = bufnr
    .. ":"
    .. tostring(vim.bo.modified)
    .. ":"
    .. tostring(vim.bo.readonly)
    .. ":"
    .. tostring(vim.bo.modifiable)
  if cache.file_info[cache_key] then
    return cache.file_info[cache_key]
  end

  local filename = vim.fn.fnamemodify(bufname, ":~:.")
  if filename == "" then
    filename = "[No Name]"
  end

  local extension = vim.fn.fnamemodify(filename, ":e")
  local icon, icon_color

  if vim.bo.buftype == "terminal" then
    filename = "Terminal"
    icon = ""
    local theme_colors = M.get_theme_colors()
    icon_color = theme_colors.terminal
  else
    local ok, devicons = safe_require "nvim-web-devicons"
    if ok then
      icon, icon_color = devicons.get_icon_color(filename, extension, { default = true })
    end
  end

  local theme = M.get_theme_colors()
  -- Create cached highlight
  local statusline_bg = theme.statusline_bg

  if icon and icon_color then
    local hl_name = "LualineFileInfoIcon" .. bufnr
    vim.api.nvim_set_hl(0, hl_name, { fg = icon_color, bg = statusline_bg })
    icon = string.format("%%#%s#%s%%#StatusLine#", hl_name, icon)
  end

  local modified = vim.bo.modified and "%#DiagnosticError#󰆓%#StatusLine#" or nil
  local readonly = (not vim.bo.modifiable or vim.bo.readonly) and "" or nil

  -- Don't set a custom background - let lualine handle it

  local items = {}
  if icon then
    table.insert(items, icon)
  end
  if filename then
    table.insert(items, filename)
  end
  if modified then
    table.insert(items, modified)
  end
  if readonly then
    table.insert(items, readonly)
  end

  local result = table.concat(items, " ")
  cache.file_info[cache_key] = result

  return result
end

function M.branch()
  return {
    "branch",
    icon = "󰘬",
    separator = " ",
    color = { fg = M.get_theme_colors().branch, bg = M.get_theme_colors().statusline_bg },
    padding = { left = 1, right = 1 },
  }
end

-- Enhanced diagnostics component
function M.diagnostics()
  local palette = get_colors()
  local theme_colors = M.get_theme_colors()
  return {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    sections = { "error", "warn", "info", "hint" },
    diagnostics_color = {
      error = { fg = theme_colors.diagnostics_error },
      warn = { fg = theme_colors.diagnostics_warn },
      info = { fg = theme_colors.diagnostics_info },
      hint = { fg = theme_colors.diagnostics_hint },
    },
    icons = {
      error = palette.signs.E.sign or "E",
      warn = palette.signs.W.sign or "W",
      info = palette.signs.I.sign or "I",
      hint = palette.signs.H.sign or "H",
    },
    update = { "DiagnosticChanged", "BufEnter" },
    padding = { left = 0, right = 1 },
  }
end

-- Search count component
function M.search_count()
  return {
    function()
      if vim.v.hlsearch == 0 then
        return ""
      end

      local ok, search = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 500 })
      if not ok or search.total == 0 then
        return ""
      end

      return string.format("[%d/%d]", search.current, search.total)
    end,
    cond = function()
      return vim.v.hlsearch > 0
    end,
    update = { "CmdlineChanged", "BufEnter" },
  }
end

-- Macro recording indicator
function M.macro_recording()
  return {
    function()
      local reg = vim.fn.reg_recording()
      if reg == "" then
        return ""
      end
      return " " .. reg
    end,
    cond = function()
      return vim.fn.reg_recording() ~= ""
    end,
    color = function()
      local theme_colors = M.get_theme_colors()
      return { fg = theme_colors.macro }
    end,
    update = { "RecordingEnter", "RecordingLeave" },
  }
end

-- DAP integration component
function M.dap_status()
  return {
    function()
      local ok, dap = safe_require "dap"
      if not ok then
        return ""
      end

      local session = dap.session()
      if not session then
        return ""
      end

      return " " .. dap.status()
    end,
    icon = "",
    cond = function()
      local ok, dap = safe_require "dap"
      return ok and dap.session() ~= nil
    end,
    color = function()
      local theme_colors = M.get_theme_colors()
      return { fg = theme_colors.dap }
    end,
    update = { "DAPProgressUpdate", "DAPBreakpointAdded", "DAPBreakpointRemoved" },
  }
end

-- Enhanced LSP status
function M.lsp_status()
  return {
    function()
      local clients = vim.lsp.get_clients { bufnr = 0 }
      if #clients == 0 then
        return ""
      end

      local names = {}
      for _, client in pairs(clients) do
        table.insert(names, client.name)
      end

      return table.concat(names, " ")
    end,
    cond = function()
      return #vim.lsp.get_clients { bufnr = 0 } > 0
    end,
    color = function()
      local theme_colors = M.get_theme_colors()
      return { fg = theme_colors.lsp }
    end,
    update = { "LspAttach", "LspDetach" },
  }
end

-- Enhanced diff component with better error handling
function M.diff_source()
  return {
    "diff",
    source = function()
      local ok, mini_diff = safe_require "mini.diff"
      if not ok then
        return { added = 0, modified = 0, removed = 0 }
      end

      local data = mini_diff.get_buf_data() or {}
      local summary = data.summary or {}
      return {
        added = summary.add or 0,
        modified = summary.change or 0,
        removed = summary.delete or 0,
      }
    end,
    color = function()
      local theme_colors = M.get_theme_colors()
      return { fg = theme_colors.diff }
    end,
    update = { "BufWritePost", "FileChangedPost" },
  }
end

-- Theme function with proper color handling
function M.get_theme()
  local mode_color = M.get_mode_color()
  local normal_hl = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
  local normal_fg = normal_hl.fg and string.format("#%06x", normal_hl.fg) or "#ffffff"
  local normal_bg = normal_hl.bg and string.format("#%06x", normal_hl.bg) or "#000000"

  local base = {
    a = { fg = normal_bg, bg = mode_color, gui = "bold" },
    b = { fg = normal_fg, bg = normal_bg },
    c = { fg = normal_fg, bg = normal_bg },
  }

  return {
    normal = base,
    insert = base,
    visual = base,
    replace = base,
    command = base,
    inactive = {
      a = { fg = normal_fg, bg = normal_bg },
      b = { fg = normal_fg, bg = normal_bg },
      c = { fg = normal_fg, bg = normal_bg },
    },
    separators = {
      left = { fg = mode_color, bg = normal_bg },
      right = { fg = normal_bg, bg = mode_color },
    },
  }
end

-- Cleanup function for cache
function M.cleanup()
  cache.highlights = {}
  cache.file_info = {}
  cache.tab_data = {}
end

return M
